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
    
    var searchCon: SearchViewController?
    var delegate: MainTableViewController?
    
    let selectView = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    
    let clockImageView = UIImageView(image: Resource.SystemImage.clock).then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Resource.MyColor.black
    }
    
    let wordLabel = UILabel().then {
        $0.font = Resource.Font.boldSystem15
        $0.textAlignment = .left
    }

    let xMarkImageView = UIImageView(image: Resource.SystemImage.xmark).then {
        $0.isUserInteractionEnabled = true
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
        contentView.addSubview(selectView)
        selectView.addSubview(clockImageView)
        selectView.addSubview(wordLabel)
        contentView.addSubview(xMarkImageView)
    }
    
    func configLayout() {
        selectView.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview()
            $0.trailing.equalTo(xMarkImageView.snp.leading)
        }
        
        
        clockImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.leading.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview().inset(10)
        }
        
        wordLabel.snp.makeConstraints {
            $0.leading.equalTo(clockImageView.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview().inset(10)
        }
        
        xMarkImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.leading.equalTo(selectView.snp.trailing)
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
    }

    func configCell(data: String) {
        wordLabel.text = data
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(goDetailview))
        selectView.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(deleteThisCell))
        xMarkImageView.addGestureRecognizer(tapGesture2)
    }
    
    @objc func goDetailview() {
        searchCon?.query = wordLabel.text
        searchCon?.requestSearch(.sim)
        
        guard let nextVC = searchCon?.vc else {return}
        nextVC.delegate = searchCon
        
        delegate?.pushAfterView(view: nextVC, backButton: true, animated: true)
    }
    
    @objc func deleteThisCell() {
        print(#function, "하이")
        guard let searchedWord = wordLabel.text else {return}
        searchCon?.deleteSearchedWord(deleteWord: searchedWord)
        delegate?.searchedList = searchCon?.getSearchedList()
        delegate?.searchedListToggle()
    }

}
