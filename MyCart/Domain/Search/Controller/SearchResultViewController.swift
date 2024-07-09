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
    func requestURLSessionSearch()
}

protocol SearchResultCollectionViewCellDelegate {
    func getQuery() -> String?
    func setIsLiked(row: Int, productId: String)
    func updateLikedList()
}


class SearchResultViewController: BaseViewController<SearchResultView> {
    
    var responseInfo = SearchResponse<ShopItem>(total: 0, start: 1, display: 30)
    var query: String?
    var nowSort: APIRouter.Sorting = .sim
    var itemList: [ShopItem]? {
        didSet {
            guard itemList?.count ?? 0 > 0 else {
                return
            }
            rootView.updateSortingView()
            rootView.collectionView.reloadData()
            hideToastActivity()
        }
    }
    
    var likedList: [String]? {
        didSet {
            guard let indexPaths = likedIndexPaths(), indexPaths.count > 0 else {
                return
            }
            print(#function, likedList)
            print(#function, indexPaths)
            rootView.collectionView.reloadItems(at: indexPaths)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
        configInteraction()
    }
    
    func configInteraction() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        rootView.collectionView.prefetchDataSource = self
        rootView.collectionView.register(SearchCollectionViewCell.self,
                                forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }

    func clearSearchRecord() {
        itemList = []
        responseInfo.total = 0
        responseInfo.start = 1
    }
    
    func pageNation() -> Int? {
        print(#function, responseInfo)
        guard responseInfo.start > 1 else {
            print(#function, "최초 검색")
            return responseInfo.start
        }
        let start = responseInfo.start
        if start > responseInfo.total || start > 1000 {
            return nil
        }
        return start
    }
    
    func setNewResponse(_ response: SearchResponse<ShopItem>) {
        if responseInfo.start > 1, itemList != nil, let items = response.items {
            responseInfo.start = response.start + response.display
            itemList?.append(contentsOf: items)
        } else if responseInfo.start == 1 {
            responseInfo = response
            responseInfo.items = nil
            itemList = response.items
        }
    }
    
    func likedIndexPaths() -> [IndexPath]? {
        guard let itemList, let likedList, itemList.count > 0, likedList.count > 0 else {
            return nil
        }
        var indexPaths: [IndexPath] = []
        itemList.enumerated().forEach {idx, item in
            if likedList.contains(item.productId) {
                indexPaths.append(IndexPath(row: idx, section: 0))
            }
        }
        return indexPaths
    }
    
    func requestSearch() {
        rootView.popUpStatusToast(StatusMessage.APIStatus.loading)
    }
    
    func requestURLSessionSearch() {
        rootView.popUpStatusToast(StatusMessage.APIStatus.loading)
        guard let start = pageNation(), let query else {
            print(#function, "start: \(responseInfo.start) | query: \(query)")
            hideToastActivity()
            return
        }
        URLSessionManager.shared.callRequest(query: query, sort: nowSort, start: start) { search, error in
            guard error == nil, let search else {
                hideToastActivity()
                self.rootView.popUpErrorToast(error)
                return
            }
//            self.userModel.setSearchedList(newWord: query)
            self.setNewResponse(search)
//            self.likedList = self.userModel.getLikedList()
            if self.responseInfo.start == 1 {
                self.rootView.totalLabel.text = Int(self.responseInfo.total).formatted(.number) + Resource.Text.searchTotal
            }
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
        guard let query else {
            return
        }
        requestURLSessionSearch()
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
    
    func setIsLiked(row: Int, productId: String) {
//        userModel.setIsLiked(productId)
        updateLikedList()
        if let likedList, !likedList.contains(productId) {
            print(#function, "삭제후 리로드", row)
            rootView.collectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
        }
    }
    
    func updateLikedList() {
//        likedList = userModel.getLikedList()
    }
}
