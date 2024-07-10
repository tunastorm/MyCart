//
//  categoryCollectionViewCell.swift
//  MyCart
//
//  Created by 유철원 on 7/11/24.
//

import UIKit
import SnapKit
import Then


class CategoryCollectionViewCell: BaseCollectionViewCell {
    
    let categoryButton = {
        let button = UIButton()
        button.titleLabel?.font = Resource.Font.system13
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Resource.CornerRadious.sortingButton
//        button.addTarget(self, action: #selector(sortSearching), for: .touchUpInside)
        return button
    }()
    
    override func configHierarchy() {
        contentView.addSubview(categoryButton)
    }
    
    override func configLayout() {
        categoryButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func configView() {
        super.configView()
    }
    
//    configCell(data: ) {
//        button.tag = idx
//        categoryButton.setTitle(title, for: .normal)
    
//    }
}

