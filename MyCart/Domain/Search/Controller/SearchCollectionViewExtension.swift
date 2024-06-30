//
//  SearchCollectionViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit


extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        
        if let dataList = itemList, dataList.count > 0 {
            let data = dataList[indexPath.row]
            guard let likedList else {return cell}
            
            let isLiked = likedList.contains(data.productId)
            
            cell.delegate = self
            cell.configCell(data, isLiked)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        guard let itemSize = itemList?.count else {return}
        
        indexPaths.forEach {
            if isEnd, itemSize - 2 == $0.row {
                scrollDown()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = ProductDetailViewController()
        
        if let dataList = itemList, dataList.count > 0 {
            nextVC .product = dataList[indexPath.row]
        }
        pushAfterView(view: nextVC, backButton: true, animated: true)
    }
}
