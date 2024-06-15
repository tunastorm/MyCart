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
    
    var delegate: SearchViewController?
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configHierarchy()
        configLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(priceLabel)
    }
    
    func configLayout() {
        imageView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.7)
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.bottom.trailing.equalTo(imageView).inset(16)
        }
        
        mallNameLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.equalTo(imageView.snp.bottom).offset(2)
            $0.horizontalEdges.equalToSuperview()
        }
        
        itemNameLabel.snp.makeConstraints {
            $0.height.lessThanOrEqualTo(40)
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
    
    func configCell(_ data: ShopItem, _ isLiked: Bool) {
        let url = URL(string: data.image)
        imageView.kf.setImage(with: url)
    
        likeButton.setTitle(data.productId, for: .normal)
        if isLiked {
            likeButton.setImage(Resource.SystemImage.cartFill, for: .normal)
            likeButton.tintColor = Resource.MyColor.black
            likeButton.backgroundColor = Resource.MyColor.white
            likeButton.alpha = Resource.Alpha.full
        } else {
            likeButton.setImage(Resource.SystemImage.cart, for: .normal)
            likeButton.tintColor = Resource.MyColor.white
            likeButton.backgroundColor = Resource.MyColor.black
            likeButton.alpha = Resource.Alpha.half
        }
        
        mallNameLabel.text = data.mallName
        
        var itemName = data.title.replacingOccurrences(of: "<b>", with: "")
        itemNameLabel.text = itemName.replacingOccurrences(of: "</b>", with: "")
        
        guard let intPrice = Int(data.lprice) else {return}
        priceLabel.text = intPrice.formatted(.number) + "원"
    }
    
    @objc func likeButtonClicked(_ sender: UIButton) {
        print(#function, sender.title(for: .normal))
        guard let productId = sender.title(for: .normal) else {return}
        delegate?.setIsLiked(productId)
    }
}
