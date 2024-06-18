//
//  SearchViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit

import SnapKit
import Then


class SearchCollectionViewController: UIViewController {
    
    var delegate: SearchViewController?
    
    private var total: Int?
    
    var nowSort: APIRouter.Sorting?
    
    var itemList: [ShopItem]? {
        didSet {
            print(#function, "itemList didSet")
            print(#function, nowSort)
            updateSortingView()
            collectionView.reloadData()
           
        }
    }
    
    var likedList: [String]? {
        didSet {
            print(#function, "likedList didSet")
            collectionView.reloadData()
        }
    }
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBaseSetting()
        configHierarchy()
        configLayout()
        configView()
        configSortingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = delegate?.query
        
        if let total = delegate?.getTotal(){
            totalLabel.text = Int(total).formatted() + Resource.Text.searchTotal
        }
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
        layout.sectionInset = UIEdgeInsets(top: inset,
                                           left: inset,
                                           bottom: inset,
                                           right: inset)
        return layout
    }
    
    func configBaseSetting() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(SearchCollectionViewCell.self,
                                forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    func configHierarchy() {
        view.addSubview(totalLabel)
        view.addSubview(sortingView)
        view.addSubview(collectionView)
    }
    
    func configLayout() {
        totalLabel.snp.makeConstraints{
            $0.height.equalTo(30)
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        sortingView.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(totalLabel.snp.bottom).offset(5)
        }
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(sortingView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configView() {
        view.backgroundColor = Resource.MyColor.white
    }
    
    func configSortingView() {
        for (idx, button) in [simButton, dateButton, dscButton, ascButton].enumerated() {
            let title = APIRouter.Sorting.allCases[idx].buttonTitle
            print(#function, title)
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
            guard let nowSort else {return}
            print(#function, APIRouter.Sorting.allCases[idx], nowSort)
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
        nowSort = APIRouter.Sorting.allCases[sender.tag]
        updateSortingView()
        print(#function,nowSort)
        delegate?.clearSearchResponse()
        guard let nowSort else {return}
        delegate?.requestSearch(nowSort)
    }
    
    func popUpToast(messageEnum: ErrorMessage.API) {
        makeToast2(message: messageEnum.message, duration: 3.0, position: .center)
    }
}
