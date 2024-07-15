//
//  LikedItemCollectionViewCell.swift
//  MyCart
//
//  Created by 유철원 on 7/11/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then


class LikedItemCollectionViewCell: BaseCollectionViewCell {
    
    var delegate: LikedItemCollectionViewCellDelegate?
    
    let imageView = UIImageView().then {
        $0.backgroundColor = Resource.MyColor.lightGray
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = Resource.CornerRadious.searchImage
        $0.layer.masksToBounds = true
    }
    
    let likeButton = UIButton().then{
        $0.layer.cornerRadius = Resource.CornerRadious.likeButton
        $0.layer.masksToBounds = true
        $0.titleLabel?.layer.opacity = 0
        $0.titleLabel?.font = .systemFont(ofSize: 0)
        $0.backgroundColor = Resource.MyColor.white
        $0.tintColor = Resource.MyColor.orange
        $0.setImage(Resource.NamedImage.likeSelected, for: .normal)
        $0.alpha = Resource.Alpha.full
        $0.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
    }
    
    let mallNameLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = Resource.MyColor.lightGray
        $0.font = Resource.Font.system13
    }
    
    let itemNameLabel = UILabel().then {
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = Resource.Font.system14
    }
    
    let priceLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = Resource.Font.boldSystem16
    }
    
    override func configHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(priceLabel)
    }
    
    override func configLayout() {
        imageView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.7)
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.bottom.trailing.equalTo(imageView).inset(10)
        }
        
        mallNameLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.equalTo(imageView.snp.bottom).offset(2)
            $0.horizontalEdges.equalToSuperview()
        }
        
        itemNameLabel.snp.makeConstraints {
            $0.height.lessThanOrEqualTo(34)
            $0.top.equalTo(mallNameLabel.snp.bottom).offset(2)
            $0.horizontalEdges.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints{
            $0.height.equalTo(30)
            $0.top.equalTo(itemNameLabel.snp.bottom).offset(2)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.greaterThanOrEqualToSuperview()
        }
    }
    
    func configCell(_ data: LikedItem) {
        let url = URL(string: data.image)
        imageView.kf.setImage(with: url)
        
        likeButton.setTitle(data.productId, for: .normal)
        
        mallNameLabel.text = data.mallName
        itemNameLabel.text = data.title.replacing("<b>", with: "").replacing("</b>", with: "")
        
        let intPrice = Int(data.lprice) ?? 0
        priceLabel.text = intPrice.formatted(.number) + "원"
    }
    
    @objc func likeButtonClicked(_ sender: UIButton) {
        guard let productId = sender.title(for: .normal), let delegate else {
            return
        }
        delegate.deleteLikedItem(productId, inDetail: false)
    }
    
}
