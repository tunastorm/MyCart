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
    
    var delegate: SearchViewController?
    
    private var total: Int?
    
    var nowSort = APIRouter.Sorting.sim
    
    var itemList: [ShopItem]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var likedList: [String]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let totalLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = Resource.MyColor.orange
        $0.font = Resource.Font.boldSystem15
    }
    
    let sortingView = UIView()
    
    let simButton = UIButton().then {
        $0.setTitleColor( Resource.MyColor.white, for: .normal)
        $0.backgroundColor = Resource.MyColor.darkGray
        $0.layer.borderWidth = Resource.Border.widthZero
    }
    
    let dateButton = UIButton().then {
        $0.setTitleColor(Resource.MyColor.black, for: .normal)
        $0.backgroundColor = Resource.MyColor.white
        $0.layer.borderWidth = Resource.Border.width1
        $0.layer.borderColor = Resource.MyColor.lightGray.cgColor
    }
    
    let dscButton = UIButton().then {
        $0.setTitleColor(Resource.MyColor.black, for: .normal)
        $0.backgroundColor = Resource.MyColor.white
        $0.layer.borderWidth = Resource.Border.width1
        $0.layer.borderColor = Resource.MyColor.lightGray.cgColor
    }
    
    let ascButton = UIButton().then {
        $0.setTitleColor(Resource.MyColor.black, for: .normal)
        $0.backgroundColor = Resource.MyColor.white
        $0.layer.borderWidth = Resource.Border.width1
        $0.layer.borderColor = Resource.MyColor.lightGray.cgColor
    }
    
    
    lazy var collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: collectionViewLayout())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBaseSetting()
        configHierarchy()
        configLayout()
        configView()
        configSortingView()
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let horizontalCount = CGFloat(2)
        let verticalCount = CGFloat(2)
        let lineSpacing = CGFloat(20)
        let itemSpacing = CGFloat(10)
        let inset = CGFloat(20)
        
        let width = UIScreen.main.bounds.width - (inset * 2) - (itemSpacing * horizontalCount-1)
        let height = 300 - (inset * 2) - (lineSpacing * verticalCount-1)
        
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
        collectionView.register(SearchCollectionViewCell.self,
                                forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    func configHierarchy() {
        view.addSubview(totalLabel)
        view.addSubview(sortingView)
        view.addSubview(collectionView)
    }
    
    func configLayout() {
        totalLabel.snp.makeConstraints{
            $0.height.equalTo(30)
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        sortingView.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(totalLabel.snp.bottom).offset(5)
        }
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(sortingView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configView() {
        view.backgroundColor = Resource.MyColor.white
        navigationItem.title = delegate?.query
        
        if let total = delegate?.getTotal(){
            totalLabel.text = Int(total).formatted() + Resource.Text.searchTotal
        }
    }
    
    func configSortingView() {
        for (idx, button) in [simButton, dateButton, dscButton, ascButton].enumerated() {
            let title = APIRouter.Sorting.allCases[idx].buttonTitle
            print(#function, title)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = Resource.Font.system13
            button.layer.masksToBounds = true
            button.layer.cornerRadius = Resource.CornerRadious.sortingButton
            button.addTarget(self, action: #selector(sortSearching), for: .touchUpInside)
            button.tag = idx
    
            sortingView.addSubview(button)
    
            button.snp.makeConstraints {
                $0.height.equalTo(34)
                $0.width.equalTo(24 + title.count * 10)
                $0.centerY.equalToSuperview()
            }
        }
        
        dateButton.snp.makeConstraints {
            $0.leading.equalTo(simButton.snp.trailing).offset(6)
        }
        
        dscButton.snp.makeConstraints {
            $0.leading.equalTo(dateButton.snp.trailing).offset(6)
        }
        
        ascButton.snp.makeConstraints {
            $0.leading.equalTo(dscButton.snp.trailing).offset(6)
        }
    }
    
    @objc func sortSearching(_ sender: UIButton) {
        nowSort = APIRouter.Sorting.allCases[sender.tag]
        sender.setTitleColor(Resource.MyColor.white, for: .normal)
        sender.backgroundColor = Resource.MyColor.darkGray
        sender.layer.borderWidth = Resource.Border.widthZero
        
        for (idx, view) in sortingView.subviews.enumerated() {
            if idx != sender.tag {
                let button = view as! UIButton
                button.setTitleColor(Resource.MyColor.black, for: .normal)
                button.backgroundColor = Resource.MyColor.white
                button.layer.borderWidth = Resource.Border.width1
                button.layer.borderColor = Resource.MyColor.lightGray.cgColor
            }
        }
        print(#function,nowSort)
        delegate?.clearSearchResponse()
        delegate?.requestSearch(nowSort)
    }
}
