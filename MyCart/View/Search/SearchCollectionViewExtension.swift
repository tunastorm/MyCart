//
//  SearchCollectionViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit


extension SearchCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(delegate?.getDisplay() ?? 1)
        return itemList?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        
        if let dataList = itemList, dataList.count > 0 {
           let data = dataList[indexPath.row]
            guard let isLiked = delegate?.getIsLiked(productId: data.productId) else {return cell}
            
            cell.configCell(data, like: isLiked)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        guard let itemSize = itemList?.count else {return}
        indexPaths.forEach {
            if let isEnd = delegate?.getIsEnd(), !isEnd, itemSize - 4 == $0.row {
                delegate?.scrollDown()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
    }
}
