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
    
    func getSearchedListCount() -> Int
    
    func deleteSearchedList()
}

protocol MainTableViewCellDelegate {
    
    func goSearchResultView(query: String)
    
    func deleteSearchedWord(deleteWord: String)
    
    func updateSearchedList()
}


class MainViewController: BaseViewController<MainView> {
    
    var searchResultVC: SearchResultViewController?
    var productDetailVC: ProductDetailViewController?
    
    var searchedList: [String]? {
        didSet {
            rootView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        rootView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBaseSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchedList = userModel.getSearchedList()
        navigationItem.title = "\(userModel.nowUser.nickName)\(Resource.Text.mainViewTitle)"
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
        return userModel.getSearchedList()
    }
    
    func setSearchedList(newWord: String) {
        userModel.setSearchedList(newWord: newWord)
    }
    
    func updateSearchedList() {
        searchedList = getSearchedList()
        rootView.searchedListToggle()
    }
    
    func goSearchResultView(query: String) {
        if searchResultVC == nil {
            searchResultVC = SearchResultViewController()
        }
        guard let searchResultVC else {
            return
        }
        searchResultVC.query = query
        searchResultVC.clearSearchRecord()
        searchResultVC.requestSearch()
        pushAfterView(view: searchResultVC, backButton: true, animated: true)
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
    
    func getSearchedListCount() -> Int {
        guard let searchedList, searchedList.count > 0 else {
            return 0
        }
        return searchedList.count
    }
    
    func deleteSearchedList() {
        userModel.setSearchedList(newWord: nil)
    }
  
}

extension MainViewController: MainTableViewCellDelegate {
    
    func deleteSearchedWord(deleteWord: String) {
        userModel.deleteSearchedWord(deleteWord: deleteWord)
    }
}
