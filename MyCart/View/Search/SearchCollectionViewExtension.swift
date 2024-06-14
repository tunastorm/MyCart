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
        return delegate?.getDisplay() ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        
        if let dataList = itemList, dataList.count > 0 {
           let data = dataList[indexPath.row]
           cell.configCell(data)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
}
