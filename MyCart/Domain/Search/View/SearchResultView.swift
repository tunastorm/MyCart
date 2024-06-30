//
//  SearchViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit

import SnapKit
import Then
import Toast


class SearchResultView: BaseView {
    
    var delegate: SearchResultViewDelegate?
    
    private var total: Int?
    
    let totalLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = Resource.MyColor.orange
        $0.font = Resource.Font.boldSystem15
    }
    
    let sortingView = UIView()
    
    let simButton = UIButton()
    
    let dateButton = UIButton()
    
    let dscButton = UIButton()
    
    let ascButton = UIButton()
    
    lazy var collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: collectionViewLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSortingView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let horizontalCount = CGFloat(2)
        let verticalCount = CGFloat(2)
        let lineSpacing = CGFloat(20)
        let itemSpacing = CGFloat(10)
        let inset = CGFloat(20)
        
        let width = UIScreen.main.bounds.width - (inset * 2) - (itemSpacing * horizontalCount-1)
        let height = UIScreen.main.bounds.height - 240 - (inset * 2) - (lineSpacing * verticalCount-1)
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width / horizontalCount,
                                 height: height / verticalCount)
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        return layout
    }
    
    override func configInteraction() {
        guard let delegate else {
            return
        }
        delegate.configInteraction()
    }
    
    override func configHierarchy() {
        self.addSubview(totalLabel)
        self.addSubview(sortingView)
        self.addSubview(collectionView)
    }
    
    override func configLayout() {
        totalLabel.snp.makeConstraints{
            $0.height.equalTo(30)
            $0.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        sortingView.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(totalLabel.snp.bottom).offset(5)
        }
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(sortingView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        self.backgroundColor = Resource.MyColor.white
        configSortingView()
    }
    
    func configSortingView() {
        for (idx, button) in [simButton, dateButton, dscButton, ascButton].enumerated() {
            let title = APIRouter.Sorting.allCases[idx].buttonTitle
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = Resource.Font.system13
            button.layer.masksToBounds = true
            button.layer.cornerRadius = Resource.CornerRadious.sortingButton
            button.addTarget(self, action: #selector(sortSearching), for: .touchUpInside)
            button.tag = idx
            
            sortingView.addSubview(button)
            
            button.snp.makeConstraints {
                $0.height.equalTo(34)
                $0.width.equalTo(24 + title.count * 10)
                $0.centerY.equalToSuperview()
            }
        }
        configSortButtonLayout()
    }
    
    func configSortButtonLayout() {
        dateButton.snp.makeConstraints {
            $0.leading.equalTo(simButton.snp.trailing).offset(6)
        }
        dscButton.snp.makeConstraints {
            $0.leading.equalTo(dateButton.snp.trailing).offset(6)
        }
        ascButton.snp.makeConstraints {
            $0.leading.equalTo(dscButton.snp.trailing).offset(6)
        }
    }
    
    
    func updateSortingView() {
        for (idx, button) in [simButton, dateButton, dscButton, ascButton].enumerated() {
            guard let nowSort = delegate?.getNowSort() else {return}
            if APIRouter.Sorting.allCases[idx] == nowSort {
                button.setTitleColor(Resource.MyColor.white, for: .normal)
                button.backgroundColor = Resource.MyColor.darkGray
                button.layer.borderWidth = Resource.Border.widthZero
            } else {
                button.setTitleColor(Resource.MyColor.black, for: .normal)
                button.backgroundColor = Resource.MyColor.white
                button.layer.borderWidth = Resource.Border.width1
                button.layer.borderColor = Resource.MyColor.lightGray.cgColor
            }
        }
    }
    
    @objc func sortSearching(_ sender: UIButton) {
        guard let delegate else {
            return
        }
        delegate.setNowSort(sort: APIRouter.Sorting.allCases[sender.tag])
        updateSortingView()
        delegate.clearSearchRecord()
        delegate.requestSearch()
    }
    
    func popUpErrorToast(_ error: APIError) {
        switch error {
        case .networkError:
            let image = Resource.SystemImage.wifiExclamationmark
            makeToastWithImage(message: error.message,duration: 3.0, position: .bottom,
                               title: error.title, image: image)
        default: makeBasicToast(message: error.message, duration: 3.0 , position: .bottom, title: error.title)
        }
    }
    
    func popUpStatusToast(_ messageEnum: StatusMessage.APIStatus) {
        switch messageEnum {
        case .loading:
            makeLoadingToast(positon: .center)
        case .lastPage:
            makeBasicToast(message: StatusMessage.APIStatus.lastPage.message, duration: 3.0, position: .bottom)
        }
    }
}
