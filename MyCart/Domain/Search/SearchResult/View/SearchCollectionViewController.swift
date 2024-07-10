//
//  SearchCollectionViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit


extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputItemList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
        guard viewModel.outputItemList.value.count > 0 else {
            return cell
        }
        
        let data = viewModel.outputItemList.value[indexPath.row]
        let isLiked = viewModel.outputLikedProductIdDict.value.keys.contains(data.productId)
        print(#function, "data: ", data, "isLiked: ", isLiked)
        cell.delegate = self
        cell.likeButton.tag = indexPath.row
        cell.configCell(data, isLiked)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let itemSize = viewModel.outputItemList.value.count
        indexPaths.forEach { indexPath in
            print(#function, indexPath.row, itemSize, query, "스크롤")
            if itemSize - 1 == indexPath.row, let query {
                print(#function, "스크롤 실행")
                viewModel.inputRequestSearchTrigger.value = (query, viewModel.outputSort.value)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = ProductDetailViewController()
        nextVC.delegate = self
        nextVC.row = indexPath.row
        if viewModel.outputItemList.value.count > 0 {
            nextVC.product = viewModel.outputItemList.value[indexPath.row]
        }
        pushAfterView(view: nextVC, backButton: true, animated: true)
    }
}
