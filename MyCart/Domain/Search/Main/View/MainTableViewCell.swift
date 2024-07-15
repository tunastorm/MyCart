//
//  MainTableViewCell.swift
//  MyCart
//
//  Created by 유철원 on 6/16/24.
//

import UIKit

import SnapKit
import Then

final class MainTableViewCell: BaseTableViewCell {
    
    var delegate: MainTableViewCellDelegate?
    
    private let selectView = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    
    private let clockImageView = UIImageView(image: Resource.SystemImage.clock).then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Resource.MyColor.black
    }
    
    private let wordLabel = UILabel().then {
        $0.font = Resource.Font.boldSystem15
        $0.textAlignment = .left
    }
    
    private let searchedDateLabel = UILabel().then {
        $0.font = Resource.Font.system13
        $0.textColor = Resource.MyColor.lightGray
        $0.textAlignment = .right
    }

    private let xMarkImageView = UIImageView(image: Resource.SystemImage.xmark).then {
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Resource.MyColor.black
    }
    
    override func configHierarchy() {
        contentView.addSubview(selectView)
        selectView.addSubview(clockImageView)
        selectView.addSubview(wordLabel)
        selectView.addSubview(searchedDateLabel)
        contentView.addSubview(xMarkImageView)
    }
    
    override func configLayout() {
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
            $0.verticalEdges.equalToSuperview().inset(10)
        }
        searchedDateLabel.snp.makeConstraints {
            $0.leading.equalTo(wordLabel.snp.trailing).offset(20)
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

    func configCell(_ row: Int, _ data: SearchedWord) {
        self.selectionStyle = .none
        wordLabel.text = data.word
        Utils.dateFormatter.dateFormat = "yy. M. d hh:mm a"
        searchedDateLabel.text = Utils.dateFormatter.string(from: data.regDate)
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(goSearchResultView))
        selectView.addGestureRecognizer(tapGesture1)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(deleteThisCell))
        xMarkImageView.addGestureRecognizer(tapGesture2)
        xMarkImageView.tag = row
    }
    
    @objc private func goSearchResultView() {
        guard let delegate, let searchText = wordLabel.text else {
            return
        }
        delegate.goSearchResultView(query: searchText)
    }
    
    @objc private func deleteThisCell() {
        guard let searchedWord = wordLabel.text, let delegate else {return}
        delegate.deleteSearchedWord(row: xMarkImageView.tag)
    }

}
