//
//  MainViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

import SnapKit
import Then


class MainViewController: UIViewController {
    
    var delegate: SearchViewController?
    
    var searchBar: UISearchBar?
    
    let imageView = UIImageView(image: Resource.NamedImage.empty).then {
        $0.contentMode = .scaleToFill
    }
    
    let noSearchedListLabel = UILabel().then {
        $0.font = Resource.Font.boldSystem16
        $0.textAlignment = .center
        $0.text = Resource.Text.noListMessgae
    }
    
    let tableView = UITableView()

    var searchedList: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBaseSetting()
        configHierarchy()
        configLayout()
        configView()
        searchedListToggle()
    }
    
    func configBaseSetting() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchBar = searchController.searchBar
        searchBar?.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    func configHierarchy() {
        if let searchBar {
            view.addSubview(searchBar)
        }
        view.addSubview(imageView)
        view.addSubview(noSearchedListLabel)
        view.addSubview(tableView)
    }
    
    func configLayout() {
        
        imageView.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(280)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(120)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        noSearchedListLabel.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configView() {
        setNavigationBarUI()
        view.backgroundColor = Resource.MyColor.white
        navigationItem.title = "\(delegate?.getUserNickName() ?? "")\(Resource.Text.mainViewTitle)"
        searchBar?.placeholder = Resource.Text.searchBarPlaceHolder
    }
    
    func searchedListToggle() {
        if let searchedList {
            imageView.isHidden = true
            noSearchedListLabel.isHidden = true
            tableView.isHidden = false
        } else {
            imageView.isHidden = false
            noSearchedListLabel.isHidden = false
            tableView.isHidden = true
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.query = searchBar.text
        delegate?.requestSearch(.sim)
        guard let nextVC = delegate?.vc else { return }
        nextVC.delegate = self.delegate
        pushAfterView(view: nextVC, backButton: true, animated: true)
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
    }
}
