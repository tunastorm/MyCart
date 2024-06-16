//
//  MainTableViewCell.swift
//  MyCart
//
//  Created by 유철원 on 6/16/24.
//

import UIKit

import SnapKit
import Then

class MainTableViewCell: UITableViewCell {
    
    var delegate: SearchViewController?
    
    let clockImageView = UIImageView(image: Resource.SystemImage.clock).then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Resource.MyColor.black
    }
    
    let wordLabel = UILabel().then {
        $0.font = Resource.Font.boldSystem15
        $0.textAlignment = .left
    }

    let xMarkImageView = UIImageView(image: Resource.SystemImage.xmark).then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Resource.MyColor.black
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configHierarchy()
        configLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configHierarchy() {
        contentView.addSubview(clockImageView)
        contentView.addSubview(wordLabel)
        contentView.addSubview(xMarkImageView)
    }
    
    func configLayout() {
        clockImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.leading.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview().inset(10)
        }
        
        wordLabel.snp.makeConstraints {
            $0.leading.equalTo(clockImageView.snp.trailing).offset(20)
            $0.verticalEdges.equalToSuperview().inset(10)
        }
        
        xMarkImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.leading.equalTo(wordLabel.snp.trailing).offset(4)
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
    }

    func configCell(data: String) {
        wordLabel.text = data
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteThisCell))
        xMarkImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func deleteThisCell() {
        
    }

}
