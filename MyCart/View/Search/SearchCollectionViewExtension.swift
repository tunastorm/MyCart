//
//  SearchCollectionViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit


extension SearchCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        
        if let dataList = itemList, dataList.count > 0 {
            let data = dataList[indexPath.row]
            guard let likedList else {return cell}
            
            let isLiked = likedList.contains(data.productId)
            
            cell.delegate = self.delegate
            cell.configCell(data, isLiked)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        guard let itemSize = itemList?.count else {return}
        indexPaths.forEach {
            if let isEnd = delegate?.getIsEnd(), !isEnd, itemSize - 2 == $0.row, let nowSort {
                delegate?.searchScrollDown(nowSort)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductDetailViewController()
        vc.delegate = self.delegate
        
        if let dataList = itemList, dataList.count > 0 {
            vc.product = dataList[indexPath.row]
        }
        setNavigationBarUI()
        pushAfterView(view: vc, backButton: true, animated: true)
    }
}
