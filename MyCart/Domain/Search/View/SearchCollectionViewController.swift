//
//  SearchCollectionViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit


extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputItemList.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
        guard let dataList = viewModel.outputItemList.value, dataList.count > 0 else {
            return cell
        }
        
        let data = dataList[indexPath.row]
        let isLiked = viewModel.outputLikedProductIdDict.value.keys.contains(data.productId)
        print(#function, "data: ", data, "isLiked: ", isLiked)
        cell.delegate = self
        cell.likeButton.tag = indexPath.row
        cell.configCell(data, isLiked)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let itemSize = viewModel.outputItemList.value?.count else {
            return
        }
        indexPaths.forEach {
            if itemSize - 2 == $0.row, let query {
                viewModel.inputRequestSearchTrigger.value = (query, nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = ProductDetailViewController()
        nextVC.delegate = self
        nextVC.row = indexPath.row
        if let dataList = viewModel.outputItemList.value, dataList.count > 0 {
            nextVC.product = dataList[indexPath.row]
        }
        pushAfterView(view: nextVC, backButton: true, animated: true)
    }
}
