//
//  MainView.swift
//  MyCart
//
//  Created by 유철원 on 6/30/24.
//

import UIKit


class MainView: BaseView {
    
    var delegate: MainViewDelegate?
    
    var searchBar: UISearchBar?
    
    let imageView = UIImageView(image: Resource.NamedImage.empty).then {
        $0.contentMode = .scaleToFill
    }
    
    let noSearchedListLabel = UILabel().then {
        $0.font = Resource.Font.boldSystem16
        $0.textAlignment = .center
        $0.text = Resource.Text.noListMessgae
    }
    
    let currentSearchedView = UIView()
    
    let currentSearchedlabel = UILabel().then {
        $0.font = Resource.Font.boldSystem16
        $0.textAlignment = .left
        $0.text = Resource.Text.currentSearched
    }
    
    let allDeleteButton = UIButton().then {
        $0.titleLabel?.font = Resource.Font.boldSystem14
        $0.titleLabel?.textAlignment = .right
        $0.setTitle(Resource.Text.allDelete, for: .normal)
        $0.setTitleColor(Resource.MyColor.orange, for: .normal)
        $0.addTarget(self, action: #selector(deleteAllWords), for: .touchUpInside)
    }
    
    let tableView = UITableView().then {
        $0.separatorInset = .zero
    }
    
    override func configHierarchy() {
        if let searchBar {
            self.addSubview(searchBar)
        }
        self.addSubview(imageView)
        self.addSubview(noSearchedListLabel)
        self.addSubview(currentSearchedView)
        currentSearchedView.addSubview(currentSearchedlabel)
        currentSearchedView.addSubview(allDeleteButton)
        self.addSubview(tableView)
    }
    
    override func configLayout() {
        imageView.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(280)
            $0.top.equalTo(safeAreaLayoutGuide).inset(120)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
        noSearchedListLabel.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(120)
        }
        currentSearchedView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        currentSearchedlabel.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.leading.verticalEdges.equalToSuperview().inset(20)
        }
        allDeleteButton.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.trailing.verticalEdges.equalToSuperview().inset(20)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(currentSearchedView.snp.bottom)
            $0.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        self.backgroundColor = Resource.MyColor.white
        guard let searchBar, let delegate else {
            return
        }
        searchBar.placeholder = Resource.Text.searchBarPlaceHolder
        searchedListToggle()
    }
    
    func searchedListToggle() {
        guard let delegate else {
            return
        }
        if delegate.getSearchedListCount() > 0 {
            imageView.isHidden = true
            noSearchedListLabel.isHidden = true
            currentSearchedView.isHidden = false
            tableView.isHidden = false
        } else {
            imageView.isHidden = false
            noSearchedListLabel.isHidden = false
            currentSearchedView.isHidden = true
            tableView.isHidden = true
        }
    }
    
    @objc func deleteAllWords() {
        guard let delegate else {
            return
        }
        delegate.deleteSearchedList()
        searchedListToggle()
    }
}
