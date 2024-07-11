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
    
    var delegate: CategoryCollectionViewCellDelegate?
    
    let categoryButton = {
        let button = UIButton()
        button.titleLabel?.font = Resource.Font.system13
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
        self.backgroundColor = Resource.MyColor.gray
        self.layer.masksToBounds = true
        self.layer.cornerRadius = Resource.CornerRadious.sortingButton
        categoryButton.addTarget(self, action: #selector(categoryButtonClicked), for: .touchUpInside)
    }
    
    func configCell(row: Int, category: String) {
        categoryButton.tag = row
        categoryButton.setTitle(category, for: .normal)
    }
    
    @objc func categoryButtonClicked(_ sender: UIButton) {
        print(#function, "카테고리 버튼 클릭", sender.tag)
        delegate?.filterCategory(row: sender.tag)
    }
    
    func clickedToggle() {
        categoryButton.setTitleColor(Resource.MyColor.white, for: .normal)
        categoryButton.backgroundColor = Resource.MyColor.darkGray
        categoryButton.layer.borderWidth = Resource.Border.widthZero
        categoryButton.isUserInteractionEnabled = false
    }
}

