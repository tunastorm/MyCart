//
//  MainViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

import SnapKit
import Then


protocol MainViewDelegate {
    func configBaseSetting()
    
    func deleteSearchedList()
    
    func searchedListToggle()
}

protocol MainTableViewCellDelegate {
    func deleteSearchedWord(deleteWord: String)
}


class MainViewController: BaseViewController {
    
    let rootView = MainView()
    let query: String?
    var searchedList: [String]? {
        didSet {
            rootView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        view = rootView
        rootView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBaseSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.setUser()
        searchedList = delegate?.getSearchedList()
        navigationItem.title = "\(userModel?.nowUser.nickName)\(Resource.Text.mainViewTitle)"
        rootView.searchedListToggle()
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        rootView.searchBar = searchController.searchBar
        rootView.searchBar?.setShowsCancelButton(false, animated: false)
    }
    
    func getSearchedList() -> [String]? {
        return userModel?.getSearchedList()
    }
    
    func setSearchedList(newWord: String) {
        userModel?.setSearchedList(newWord: newWord)
    }
}

extension MainViewController: MainViewDelegate {
    
    func configBaseSetting() {
        rootView.searchBar?.delegate = self
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        rootView.tableView.register(MainTableViewCell.self,
                           forCellReuseIdentifier: MainTableViewCell.identifier)
    }
    
    func deleteSearchedList() {
        userModel?.setSearchedList(newWord: nil)
    }
    
    func searchedListToggle() {
        if let searchedList, searchedList.count > 0 {
            rootView.imageView.isHidden = true
            rootView.noSearchedListLabel.isHidden = true
            rootView.currentSearchedView.isHidden = false
            rootView.tableView.isHidden = false
        } else {
            rootView.imageView.isHidden = false
            rootView.noSearchedListLabel.isHidden = false
            rootView.currentSearchedView.isHidden = true
            rootView.tableView.isHidden = true
        }
    }
}

extension MainViewController: MainTableViewCellDelegate {
    
    func deleteSearchedWord(deleteWord: String) {
        userModel?.deleteSearchedWord(deleteWord: deleteWord)
    }
    
}
