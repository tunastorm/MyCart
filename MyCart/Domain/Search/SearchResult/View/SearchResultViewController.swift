//
//  SearchResultViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/30/24.
//

import UIKit
import SnapKit
import Then


protocol SearchResultCollectionViewCellDelegate: AnyObject {
    func getQuery() -> String?
    func checkIsLikedItem(_ productId: String) -> Bool
    func updateLikedList(_ row: Int, _ productId: String)
}


final class SearchResultViewController: BaseViewController {
    
    let viewModel = SearchResultViewModel()
    
    private let noItemView = UIView().then {
        $0.isHidden = true
    }
    
    private let noItemImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = Resource.NamedImage.likeSelected
        $0.tintColor = Resource.MyColor.lightGray
    }
    
    private let noItemLabel = UILabel().then {
        $0.textColor = Resource.MyColor.lightGray
        $0.textAlignment = .center
        $0.font = Resource.Font.boldSystem16
        $0.numberOfLines = 0
        $0.text = "앗... 검색결과가 없어요. 다시 검색하세요!"
    }
    
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
        view.addSubview(noItemView)
        noItemView.addSubview(noItemImageView)
        noItemView.addSubview(noItemLabel)
        view.addSubview(totalLabel)
        view.addSubview(sortingView)
        view.addSubview(collectionView)
    }
    
    override func configLayout() {
        noItemView.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(130)
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
        noItemImageView.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        noItemLabel.snp.makeConstraints {
            $0.top.equalTo(noItemImageView.snp.bottom)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
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
        viewModel.outputSort.bind { [weak self] sort in
            guard let sort else { return }
            self?.updateSortingView(sort)
        }
        viewModel.outputItemList.bind { [weak self] itemList in
            self?.noItemsToggle()
            self?.collectionView.reloadData()
        }
        viewModel.outputLikedItemIndex.bind { [weak self] indexPath in
            guard let indexPath else { return }
            self?.collectionView.reloadItems(at: [indexPath])
        }
        viewModel.inputRequestSearchTrigger.value = .sim
    }
    
    private func noItemsToggle() {
        let isNoItem = viewModel.outputItemList.value.count == 0
        print(#function, viewModel.outputItemList.value.count, isNoItem)
        noItemView.isHidden = !isNoItem
        totalLabel.isHidden = isNoItem
        collectionView.isHidden = isNoItem
        sortingView.isHidden = isNoItem
    }
    
    func configQuery(_ query: String) {
        viewModel.inputQuery.value = query
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
        if let title = viewModel.outputQuery.value {
            navigationItem.title = "\(title) 검색결과"
        }
    }
    
    private func configSortingView() {
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
    
    private func configSortButtonLayout() {
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
    
    private func updateSortingView(_ sort: APIRouter.Sorting) {
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
    
    @objc private func sortSearching(_ sender: UIButton) {
        let sort = APIRouter.Sorting.allCases[sender.tag]
        viewModel.inputSortFilterTrigger.value = sort
        collectionView.scrollsToTop = true
    }
}

extension SearchResultViewController: SearchResultCollectionViewCellDelegate {
    
    func getQuery() -> String? {
        let query = viewModel.outputQuery.value
        return query
    }
    
    func checkIsLikedItem(_ productId: String) -> Bool {
        let result = viewModel.outputLikedProductIdDict.value.keys.contains(productId)
        return result
    }
    
    func updateLikedList(_ row: Int, _ productId: String) {
        viewModel.inputLikeListButtonTrigger.value = (row,productId)
    }
}


