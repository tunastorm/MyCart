//
//  SearchCollectionViewCell.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then


class SearchCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView().then {
        $0.backgroundColor = Resource.MyColor.lightGray
        $0.contentMode = .scaleToFill
    }
    
    let mallNameLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = Resource.MyColor.lightGray
        $0.font = Resource.Font.system13
    }
    
    let itemNameLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = Resource.Font.system14
    }
    
    let priceLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = Resource.Font.boldSystem15
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configHierarchy()
        configLayout()
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configHierarchy() {
        contentView.addSubview(imageView)
    }
    
    func configLayout() {
        imageView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.7)
            $0.top.horizontalEdges.equalToSuperview()
        }
    }
    
    func configUI() {
        backgroundColor = .blue
    }
    
    func configCell(_ data: ShopItem) {
        let url = URL(string: data.image)
        imageView.kf.setImage(with: url)
    }
}
