//
//  SearchResultViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/30/24.
//

import UIKit

protocol SearchResultViewDelegate {
    func configInteraction()
    func getNowSort() -> APIRouter.Sorting
    func setNowSort(sort: APIRouter.Sorting)
    func clearSearchRecord()
    func requestSearch()
    func scrollDown()
}

protocol SearchResultCollectionViewCellDelegate {
    func getQuery() -> String?
    func setIsLiked(productId: String)
}


class SearchResultViewController: BaseViewController<SearchResultView> {
    
    var isEnd = false
    var page = 1
    var responseInfo = SearchResponse<ShopItem>(total: 0, start: 1, display: 30)
    var query: String?
    var nowSort: APIRouter.Sorting = .sim
    var itemList: [ShopItem]? {
        didSet {
            rootView.updateSortingView()
            rootView.collectionView.reloadData()
            hideToastActivity()
        }
    }
    
    var likedList: [String]? {
        didSet {
            rootView.collectionView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        rootView.delegate = self
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
    }
    
    func clearSearchRecord() {
        itemList = []
        responseInfo.total = 0
        responseInfo.start = 1
    }
    
    func pageNation() {
        let start = responseInfo.start + 30
        if start > responseInfo.total || start > 1000 {
            isEnd = true
        }
        isEnd = false
    }
    
    func setNewResponse(_ response: SearchResponse<ShopItem>) {
        if responseInfo.start > 1, itemList != nil, let items = response.items {
            responseInfo.start = response.start
            itemList?.append(contentsOf: items)
        } else if responseInfo.start == 1 {
            responseInfo = response
            responseInfo.items = nil
            itemList = response.items
        }
    }
    
    func requestSearch() {
        guard !isEnd, let query else {
            return
        }
        
//        model.requestSearch(query, sort: sort,
//        callback: {
//            self.setSearchedList(newWord: query)
//            self.rootView.itemList = self.model.responseItems
//            self.rootView.likedList = self.getLikedList()
//            if self.model.page == 1 {
//                self.rootView.totalLabel.text = Int(self.getTotal()).formatted(.number)
//                                          + Resource.Text.searchTotal
//            }
//        }, errorCallback: {
//            self.setErrorToast(messageEnum: StatusMessage.APIError.requestAPIFailed)
//        })
//        rootView.nowSort = sort
//        setStatusToast(messageEnum: StatusMessage.APIStatus.loading)
    }
    
    func scrollDown() {
//        if let query, model.pageNation() {
//            model.requestSearch(query, sort: sort,
//            callback: {() -> () in
//                self.rootView.itemList = self.model.responseItems
//            },
//            errorCallback: {
//                self.setErrorToast(messageEnum: StatusMessage.APIError.requestAPIFailed)
//            })
//        } else {
//            setStatusToast(messageEnum: StatusMessage.APIStatus.lastPage)
//        }
    }
}

extension SearchResultViewController: SearchResultViewDelegate {
    
    func configInteraction() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        rootView.collectionView.prefetchDataSource = self
        rootView.collectionView.register(SearchCollectionViewCell.self,
                                forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    func getNowSort() -> APIRouter.Sorting {
        return nowSort
    }
    
    func setNowSort(sort: APIRouter.Sorting) {
        nowSort = sort
    }
}

extension SearchResultViewController: SearchResultCollectionViewCellDelegate {
    func getQuery() -> String? {
        guard let query else {
            return nil
        }
        return query
    }
    
    func setIsLiked(productId: String) {
        userModel.setIsLiked(productId)
    }
    
}
