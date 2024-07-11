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
        categoryButton.addTarget(self, action: #selector(categoryButtonClicked), for: .touchUpInside)
        self.layer.masksToBounds = true
    }
    
    func configCell(row: Int, category: String) {
        categoryButton.tag = row
        categoryButton.setTitle(category, for: .normal)
    }
    
    @objc func categoryButtonClicked(_ sender: UIButton) {
        print(#function, "카테고리 버튼 클릭", sender.tag)
        delegate?.filterCategory(row: sender.tag)
    }
    
    func clickedToggle(_ selected: Int? = nil) {
        print(#function, "클릭됨", selected)
        if categoryButton.tag == selected {
            categoryButton.setTitleColor(Resource.MyColor.white, for: .normal)
            self.backgroundColor = Resource.MyColor.darkGray
            self.layer.borderWidth = Resource.Border.widthZero
            self.isUserInteractionEnabled = false
        } else {
            categoryButton.setTitleColor(Resource.MyColor.black, for: .normal)
            self.backgroundColor = Resource.MyColor.white
            self.layer.cornerRadius = Resource.CornerRadious.sortingButton
            self.layer.borderWidth = Resource.Border.width1
            self.layer.borderColor = Resource.MyColor.lightGray.cgColor
            self.isUserInteractionEnabled = true
        }
    }
}

