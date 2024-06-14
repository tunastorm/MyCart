//
//  SearchViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit

import SnapKit
import Then


class SearchCollectionViewController: UIViewController {

    let searchViewController = SearchViewController()
   
    var itemList: [ShopItem] = []
    
    let totalLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = Resource.MyColor.orange
        $0.font = Resource.Font.boldSystem13
    }
    
    let sortingStackView = UIStackView()
    
    lazy var collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: collectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBaseSetting()
        configHierarchy()
        configLayout()
        configUI()
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let horizontalCount = CGFloat(2)
        let verticalCount = CGFloat(2)
        let lineSpacing = CGFloat(20)
        let itemSpacing = CGFloat(10)
        let inset = CGFloat(20)
        
        let width = UIScreen.main.bounds.width - (inset * 2) - (itemSpacing * horizontalCount-1)
        let height = UIScreen.main.bounds.height - 240 - (inset * 2) - (lineSpacing * verticalCount-1)
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width / horizontalCount,
                                 height: height / verticalCount)
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: inset,
                                           left: inset,
                                           bottom: inset,
                                           right: inset)
        return layout
    }
    
    func configBaseSetting() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        print(SearchCollectionViewCell.identifier)
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    func configHierarchy() {
        view.addSubview(totalLabel)
        view.addSubview(sortingStackView)
        view.addSubview(collectionView)
    }
    
    func configLayout() {
        totalLabel.snp.makeConstraints{
            $0.height.equalTo(20)
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        sortingStackView.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.top.equalTo(totalLabel.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(sortingStackView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configUI() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .lightGray
    }
}

extension SearchCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            searchViewController.requestSearch(searchText, sort: .sim)
        }
    }
}


