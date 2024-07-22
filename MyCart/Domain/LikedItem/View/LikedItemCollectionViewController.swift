//
//  LikedItemCollectionViewController.swift
//  MyCart
//
//  Created by 유철원 on 7/11/24.
//

import UIKit


extension LikedItemViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width: CGFloat?
        var height: CGFloat?
        
        if collectionView == categoryCollectionView {
            let horizontalCount = CGFloat(5)
            let verticalCount = CGFloat(1)
            let lineSpacing = CGFloat(10)
            let itemSpacing = CGFloat(1)
            let inset = CGFloat(5)
    
            let textCount = viewModel.outputCategoryList.value[indexPath.item].count
            let widthValue = 80 + CGFloat(textCount * 66)
            let heightValue = 54 - (inset * 2) - (lineSpacing * verticalCount-1)
            
            width = CGFloat(widthValue/horizontalCount)
            height = CGFloat(heightValue/verticalCount)
        }
        
        if collectionView == likedItemCollectionView {
            let horizontalCount = CGFloat(2)
            let verticalCount = CGFloat(2)
            let lineSpacing = CGFloat(20)
            let itemSpacing = CGFloat(10)
            let inset = CGFloat(20)
            
            let widthValue = UIScreen.main.bounds.width - (inset * 2) - (itemSpacing * horizontalCount-1)
            let heightValue = UIScreen.main.bounds.height - 240 - (inset * 2) - (lineSpacing * verticalCount-1)
            width = CGFloat(widthValue/horizontalCount)
            height = CGFloat(heightValue/verticalCount)
        }
        
        guard let width, let height else {
            return CGSize()
        }
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == likedItemCollectionView {
            viewModel.inputConvertShopItem.value = indexPath.row
            return
        }
    }

}

