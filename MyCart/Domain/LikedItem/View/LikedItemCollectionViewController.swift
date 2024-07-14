//
//  LikedItemCollectionViewController.swift
//  MyCart
//
//  Created by 유철원 on 7/11/24.
//

import UIKit


extension LikedItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemSize = collectionView == likedItemCollectionView ?
        viewModel.outputLikedList.value.count : viewModel.outputCategoryList.value.count
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        if collectionView == likedItemCollectionView, 
           let likedCell = collectionView.dequeueReusableCell(withReuseIdentifier: LikedItemCollectionViewCell.identifier, for: indexPath) as? LikedItemCollectionViewCell {
            guard viewModel.outputLikedList.value.count > 0 else {
                return likedCell
            }
            let data = viewModel.outputLikedList.value[indexPath.row]
            likedCell.delegate = self
            likedCell.likeButton.tag = indexPath.row
            likedCell.configCell(data)
            return likedCell
        }
        
        if collectionView == categoryCollectionView,
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell {
            
            categoryCell.delegate = self
            categoryCell.configCell(row: indexPath.row, category: viewModel.outputCategoryList.value[indexPath.row])
            categoryCell.clickedToggle(viewModel.outputClickedCategory.value)
            return categoryCell
        }

        return UICollectionViewCell()

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == likedItemCollectionView {
            viewModel.inputConvertShopItem.value = indexPath.row
            return
        }
    }
}

