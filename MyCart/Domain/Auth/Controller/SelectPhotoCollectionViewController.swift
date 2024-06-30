//
//  SelectPhotoCollectionViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/30/24.
//

import UIKit


extension SelectPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectPhotoCollectionViewCell.identifier,
                                                      for: indexPath) as! SelectPhotoCollectionViewCell
        
        
        let thisPhoto = photoList[indexPath.row]
        cell.configCell(image: thisPhoto)
        
        guard let selectedPhoto else {return cell}
        
        // UIImage 객체 생성 시 입력한 에셋파일의 이름 가져오기
        var selectedName = String(selectedPhoto.description).split(separator: " ")[2].replacingOccurrences(of: ")", with: "")
        var thisName = String(thisPhoto.description).split(separator: " ")[2].replacingOccurrences(of: ")", with: "")
        
        // 이름이 같을 경우 해당 셀을 선택된 상태로 설정
        // -> 페이지 로드시 이전 화면에서 랜덤 생성된 이미지가 기본 선택됨
        if selectedName == thisName {
            cell.configSelectedUI()
            selectedCell = indexPath
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let selectedCell {
            let lastCell = collectionView.cellForItem(at: selectedCell) as! SelectPhotoCollectionViewCell
            lastCell.configUnselectedUI()
        }
      
        let cell = collectionView.cellForItem(at: indexPath) as! SelectPhotoCollectionViewCell
        cell.configSelectedUI()
        selectedCell = indexPath
        selectedPhoto = cell.imageView.image
        rootView.profileImageView.image = selectedPhoto
        guard let delegate else {
            return
        }
        delegate.receiveData(data: selectedPhoto)
    }
}
