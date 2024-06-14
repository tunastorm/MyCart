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
        $0.backgroundColor = .green
        $0.contentMode = .scaleToFill
    }
    
    let mallNameLabel = UILabel().then {
    
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
        
    }
    
    func configLayout() {
        
    }
    
    func configUI() {
        backgroundColor = .blue
    }
    
    func configCell() {
       
    }
}
