//
//  LikedItemViewController.swift
//  MyCart
//
//  Created by 유철원 on 7/11/24.
//

import UIKit
import SnapKit
import Then


protocol LikedItemCollectionViewCellDelegate {
    func deleteLikedItem(_ productId: String, inDetail: Bool)
}

protocol CategoryCollectionViewCellDelegate {
    func filterCategory(row: Int)
    func scrollToLeft() 
}


final class LikedItemViewController: BaseViewController {
    
    let viewModel = LikedItemViewModel()
    
    private let totalLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = Resource.MyColor.orange
        $0.font = Resource.Font.boldSystem15
    }
    
    private let categoryLayout = {
        let layout = UICollectionViewFlowLayout()
        
        let horizontalCount = CGFloat(5)
        let verticalCount = CGFloat(1)
        let lineSpacing = CGFloat(10)
        let itemSpacing = CGFloat(1)
        let inset = CGFloat(5)
        
        let width = UIScreen.main.bounds.width - (inset * 2) - (itemSpacing * horizontalCount-1)
        let height = 54 - (inset * 2) - (lineSpacing * verticalCount-1)
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width / horizontalCount,
                                 height: height / verticalCount)
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset * 4, bottom: inset, right: inset)
        return layout
    }
    
    private let likedItemLayout = {
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

    lazy var categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categoryLayout())
    
    lazy var likedItemCollectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: likedItemLayout())

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputFatchLikedItemList.value = ()
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
        navigationItem.title = Resource.Text.appTitle
    }
    
    override func configHierarchy() {
        view.addSubview(totalLabel)
        view.addSubview(categoryCollectionView)
        view.addSubview(likedItemCollectionView)
    }
    
    override func configLayout() {
        totalLabel.snp.makeConstraints{
            $0.height.equalTo(30)
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        categoryCollectionView.snp.makeConstraints{
            $0.height.equalTo(54)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(totalLabel.snp.bottom).offset(5)
        }
        likedItemCollectionView.snp.makeConstraints{
            $0.top.equalTo(categoryCollectionView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configInteraction() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        
        likedItemCollectionView.delegate = self
        likedItemCollectionView.dataSource = self
        likedItemCollectionView.register(LikedItemCollectionViewCell.self,
                                forCellWithReuseIdentifier: LikedItemCollectionViewCell.identifier)
    }
    
    override func bindData() {
        viewModel.outputTotal.bind { total in
            self.totalLabel.text = total
        }
        viewModel.outputShopItem.bind { itemInfo in
            guard let row = itemInfo?.0, let product = itemInfo?.1 else { return }
            self.pushToDetailViewController(row, product)
        }
        viewModel.outputCategoryList.bind { _ in
            self.categoryCollectionView.reloadData()
        }
        viewModel.outputClickedCategory.bind { _ in
            self.categoryCollectionView.reloadData()
        }
        viewModel.outputPopDetaileView.bind { _ in
            self.popDetailViewController()
        }
        viewModel.outputLikedList.bind { _ in
            self.likedItemCollectionView.reloadData()
        }
        viewModel.outputLikedListResult.bind { result in
            guard let result else { return }
            makeBasicToast(message: result.message, duration: 3.0, position: .bottom)
        }
    }
    
    private func pushToDetailViewController(_ row: Int, _ product: ShopItem) {
        let nextVC = LikedItemDetailViewController()
        nextVC.delegate = self
        nextVC.row = row
        nextVC.product = product
        pushAfterView(view: nextVC, backButton: true, animated: true)
    }
    
    private func popDetailViewController() {
        guard let vc = navigationController?.viewControllers.last, vc is LikedItemDetailViewController else {
            return
        }
        vc.popBeforeView(animated: true)
    }
}

extension LikedItemViewController: LikedItemCollectionViewCellDelegate {

    func deleteLikedItem(_ productId: String, inDetail: Bool) {
        if inDetail {
            viewModel.inputDeleteLikedItemInDetail.value = productId
        } else {
            viewModel.inputDeleteLikedItem.value = productId
        }
    }
}

extension LikedItemViewController: CategoryCollectionViewCellDelegate {
    
    func filterCategory(row: Int) {
        viewModel.inputCategoryButtonTrigger.value = row
    }
    
    func scrollToLeft() {
        categoryCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .right, animated: false)
    }
    
}
