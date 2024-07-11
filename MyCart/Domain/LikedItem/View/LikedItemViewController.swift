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
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
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

    lazy var categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categoryLayout() )
    
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
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
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
            let nextVC = LikedItemDetailViewController()
            nextVC.delegate = self
            nextVC.row = row
            nextVC.product = product
            self.pushAfterView(view: nextVC, backButton: true, animated: true)
        }
        viewModel.outputCategoryList.bind { _ in
            self.categoryCollectionView.reloadData()
        }
        viewModel.outputPopDetaileView.bind { _ in
            print(#function, "디테일뷰컨 팝 시도")
            guard let vc = self.navigationController?.viewControllers.last, vc is LikedItemDetailViewController else {
                return
            }
            vc.popBeforeView(animated: true)
            print(#function, vc, " 팝 완료")
        }
        viewModel.outputLikedList.bind { _ in
            self.likedItemCollectionView.reloadData()
        }
        viewModel.outputLikedListResult.bind { result in
            guard let result else { return }
            makeBasicToast(message: result.message, duration: 3.0, position: .bottom)
        }
    }
//    func configcategoryView() {
//        print(#function, "정렬뷰 설정")
//        for (idx, button) in [simButton, dateButton, dscButton, ascButton].enumerated() {
//            let title = APIRouter.Sorting.allCases[idx].buttonTitle
//           
////            button.backgroundColor = .red
//            categoryView.addSubview(button)
//            
//            button.snp.makeConstraints {
//                $0.height.equalTo(34)
//                $0.width.equalTo(24 + title.count * 10)
//                $0.centerY.equalToSuperview()
//            }
//            print(#function, "\(title)버튼 설정")
//        }
//    }
    
//    @objc func sortSearching(_ sender: UIButton) {
//        let sort = APIRouter.Sorting.allCases[sender.tag]
//        viewModel.inputRequestSearchTrigger.value = (query, sort)
//    }
    
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
}
