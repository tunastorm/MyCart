//
//  SearchResultViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/30/24.
//

import UIKit
import SnapKit
import Then


protocol SearchResultCollectionViewCellDelegate {
    func getQuery() -> String?
    func checkIsLikedItem(_ productId: String) -> Bool
    func updateLikedList(_ row: Int, _ productId: String)
}


final class SearchResultViewController: BaseViewController {
    
    let viewModel = SearchResultViewModel()
    var query: String?
    
    private let totalLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = Resource.MyColor.orange
        $0.font = Resource.Font.boldSystem15
    }
    
    private let sortingView = UIView()
    
    private let simButton = UIButton()
    
    private let dateButton = UIButton()
    
    private let dscButton = UIButton()
    
    private let ascButton = UIButton()
    
    lazy var collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: collectionViewLayout())
    
    private func collectionViewLayout() -> UICollectionViewLayout {
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
    
    override func configHierarchy() {
        view.addSubview(totalLabel)
        view.addSubview(sortingView)
        view.addSubview(collectionView)
    }
    
    override func configLayout() {
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
    
    override func configView() {
        super.configView()
        configSortingView()
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
        guard let query else {
            return
        }
        navigationItem.title = "\(query) 검색결과"
    }
    
    override func configInteraction() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(SearchCollectionViewCell.self,
                                forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    override func bindData() {
        viewModel.outputTotal.bind { [weak self] total in
            self?.totalLabel.text = total
        }
        viewModel.outputSort.bind {sort in
            guard let sort else { return }
            self.updateSortingView(sort)
        }
        viewModel.outputItemList.bind { [weak self] _ in
            print(#function, "콜렉션뷰 리로드")
            self?.collectionView.reloadData()
        }
        viewModel.outputLikedItemIndex.bind { indexPath in
            guard let indexPath else { return }
            self.collectionView.reloadItems(at: [indexPath])
        }
        guard let query else { return }
        viewModel.inputRequestSearchTrigger.value = (query, .sim)
    }
    
    func configSortingView() {
        print(#function, "정렬뷰 설정")
        for (idx, button) in [simButton, dateButton, dscButton, ascButton].enumerated() {
            let title = APIRouter.Sorting.allCases[idx].buttonTitle
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = Resource.Font.system13
            button.layer.masksToBounds = true
            button.layer.cornerRadius = Resource.CornerRadious.sortingButton
            button.addTarget(self, action: #selector(sortSearching), for: .touchUpInside)
            button.tag = idx
//            button.backgroundColor = .red
            sortingView.addSubview(button)
            
            button.snp.makeConstraints {
                $0.height.equalTo(34)
                $0.width.equalTo(24 + title.count * 10)
                $0.centerY.equalToSuperview()
            }
            print(#function, "\(title)버튼 설정")
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
    
    func updateSortingView(_ sort: APIRouter.Sorting) {
        print(#function, "정렬 뷰 업데이트")
        for (idx, button) in [simButton, dateButton, dscButton, ascButton].enumerated() {
            if APIRouter.Sorting.allCases[idx] == sort {
                button.setTitleColor(Resource.MyColor.white, for: .normal)
                button.backgroundColor = Resource.MyColor.darkGray
                button.layer.borderWidth = Resource.Border.widthZero
                button.isUserInteractionEnabled = false
            } else {
                button.setTitleColor(Resource.MyColor.black, for: .normal)
                button.backgroundColor = Resource.MyColor.white
                button.layer.borderWidth = Resource.Border.width1
                button.layer.borderColor = Resource.MyColor.lightGray.cgColor
                button.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc func sortSearching(_ sender: UIButton) {
        guard let query else {
            return
        }
        let sort = APIRouter.Sorting.allCases[sender.tag]
        print(#function, sort)
        viewModel.inputSortFilterTrigger.value = (query, sort)
    }
    
//    func popUpErrorToast(_ error: APIError?) {
//        guard let error else {
//            return
//        }
//        switch error {
//        case .networkError:
//            let image = Resource.SystemImage.wifiExclamationmark
//            makeToastWithImage(message: error.message,duration: 3.0, position: .bottom,
//                               title: error.title, image: image)
//        default: makeBasicToast(message: error.message, duration: 3.0 , position: .bottom, title: error.title)
//        }
//    }
//    
//    func popUpStatusToast(_ messageEnum: StatusMessage.APIStatus) {
//        switch messageEnum {
//        case .loading:
//            makeLoadingToast(positon: .center)
//        case .lastPage:
//            makeBasicToast(message: StatusMessage.APIStatus.lastPage.message, duration: 3.0, position: .bottom)
//        }
//    }
}

extension SearchResultViewController: SearchResultCollectionViewCellDelegate {
    
    func getQuery() -> String? {
        print(#function, query)
        guard let query else {
            print(#function, "query 없음")
            return nil
        }
        return query
    }
    
    func checkIsLikedItem(_ productId: String) -> Bool {
        return viewModel.outputLikedProductIdDict.value.keys.contains(productId)
    }
    
    func updateLikedList(_ row: Int, _ productId: String) {
        viewModel.inputLikeListButtonTrigger.value = (row,productId)
    }
}
