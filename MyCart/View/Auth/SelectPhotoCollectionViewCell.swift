//
//  SelectPhotoCollectionViewCell.swift
//  MyCart
//
//  Created by 유철원 on 6/16/24.
//

import UIKit

import SnapKit
import Then

class SelectPhotoCollectionViewCell: UICollectionViewCell {
    
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configHierarchy()
        configLayout()
        configUnselectedUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configHierarchy() {
        contentView.addSubview(imageView)
    }
    
    func configLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configCell(image: UIImage) {
        imageView.layer.cornerRadius = contentView.frame.height * 0.5
        imageView.image = image
        
    }
    
    func configUnselectedUI() {
        imageView.layer.borderWidth = Resource.Border.width1
        imageView.layer.borderColor = Resource.MyColor.lightGray.cgColor
        imageView.alpha = Resource.Alpha.half
    }
    
    func configSelectedUI() {
        imageView.layer.borderWidth = Resource.Border.width3
        imageView.layer.borderColor = Resource.MyColor.orange.cgColor
        imageView.alpha = Resource.Alpha.full
    }
}
