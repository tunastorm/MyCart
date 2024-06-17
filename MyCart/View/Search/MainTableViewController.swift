//
//  MainViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

import SnapKit
import Then


class MainTableViewController: UIViewController {
    
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

    var searchedList: [String]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBaseSetting()
        configHierarchy()
        configLayout()
        configView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchedList = delegate?.getSearchedList()
        searchedListToggle()
    }
    
    func configBaseSetting() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchBar = searchController.searchBar
        searchBar?.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainTableViewCell.self,
                           forCellReuseIdentifier: MainTableViewCell.identifier)
    }

    func configHierarchy() {
        if let searchBar {
            view.addSubview(searchBar)
        }
        view.addSubview(imageView)
        view.addSubview(noSearchedListLabel)
        view.addSubview(currentSearchedView)
        currentSearchedView.addSubview(currentSearchedlabel)
        currentSearchedView.addSubview(allDeleteButton)
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
        
        currentSearchedView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
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
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configView() {
        setNavigationBarUI()
        view.backgroundColor = Resource.MyColor.white
        navigationItem.title = "\(delegate?.getUserNickName() ?? "")\(Resource.Text.mainViewTitle)"
        searchBar?.placeholder = Resource.Text.searchBarPlaceHolder
    }
    
    func searchedListToggle() {
        if let searchedList, searchedList.count > 0 {
            print(#function, searchedList, searchedList.count)
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
        delegate?.deleteSearchedList()
        searchedList = delegate?.getSearchedList()
        searchedListToggle()
    }
}

extension MainTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.query = searchBar.text
        
        guard let query = delegate?.query else {return}
        delegate?.setSearchedList(newWord: query)
        delegate?.requestSearch(.sim)
        
        guard let nextVC = delegate?.vc else { return }
        nextVC.delegate = self.delegate
        pushAfterView(view: nextVC, backButton: true, animated: true)
    }
}


extension MainTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        
        guard let searchedList else {return cell}
        
        cell.delegate = self
        cell.searchCon = self.delegate
        cell.configCell(data: searchedList[indexPath.row])
        
        return cell
    }
}
