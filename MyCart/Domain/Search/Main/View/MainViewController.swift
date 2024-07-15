//
//  MainViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

import SnapKit
import Then

protocol MainTableViewCellDelegate {
    func goSearchResultView(query: String)
    func deleteSearchedWord(row: Int)
}


class MainViewController: BaseViewController {
    
    let viewModel = MainViewModel()
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
        $0.addTarget(self, action: #selector(truncateSearchedList), for: .touchUpInside)
    }
    
    let tableView = UITableView().then {
        $0.separatorInset = .zero
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configInteraction()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layer.addBorder([.top], color: Resource.MyColor.lightGray, width: 0.8, opacity: 0.5)
        view.layoutIfNeeded()
    }
    
    override func configHierarchy() {
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
    
    override func configLayout() {
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(120)
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
    
    override func configView() {
        super.configView()
        searchBar?.placeholder = Resource.Text.searchBarPlaceHolder
    }
    
    override func bindData() {
        viewModel.outputTitle.bind { [weak self] title in
            self?.navigationItem.title = title
        }
        viewModel.outputSearchedList.bind { [weak self] list in
            self?.searchedListToggle(list.count)
            self?.tableView.reloadData()
            self?.tableView.scrollsToTop = true
        }
        viewModel.outputDeleteSearchedWordResult.bind { [weak self] result in
            makeBasicToast(message: result.message, duration: 3.0, position: .bottom)
        }
        viewModel.outputTruncateSearchedListResult.bind { [weak self] result in
            makeBasicToast(message: "전체 \(result.message)", duration: 3.0, position: .bottom)
        }
        viewModel.inputUpdateUserTrigger.value = ()
    }
    
    override func configInteraction() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchBar = searchController.searchBar
        searchBar?.setShowsCancelButton(false, animated: false)
        searchBar?.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainTableViewCell.self,
                           forCellReuseIdentifier: MainTableViewCell.identifier)
    }
    
    func searchedListToggle(_ count: Int) {
        if count > 0 {
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
    
    @objc func truncateSearchedList() {
        viewModel.inputTruncateSearchedListTrigger.value = ()
    }
}

extension MainViewController: MainTableViewCellDelegate {
    
    func deleteSearchedWord(row: Int) {
        viewModel.inputDeleteSearchedWord.value = row
    }
    
    func goSearchResultView(query: String) {
        let vc = SearchResultViewController()
        vc.configQuery(query)
        pushAfterView(view: vc, backButton: true, animated: true)
    }
}
