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
        cell.delegate = self
        cell.likeButton.tag = indexPath.row
        cell.configCell(data, isLiked)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let itemSize = viewModel.outputItemList.value.count
        indexPaths.forEach { indexPath in
            if itemSize - 1 == indexPath.row {
                viewModel.inputRequestSearchTrigger.value = nil
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductDetailViewController()
        vc.delegate = self
        vc.row = indexPath.row
        if viewModel.outputItemList.value.count > 0 {
            vc.product = viewModel.outputItemList.value[indexPath.row]
        }
        pushAfterView(view: vc, backButton: true, animated: true)
    }
}
