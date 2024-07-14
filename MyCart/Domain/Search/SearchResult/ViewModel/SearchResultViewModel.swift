//
//  SearchResultViewModel.swift
//  MyCart
//
//  Created by 유철원 on 7/10/24.
//

import Foundation
import RealmSwift


class SearchResultViewModel: BaseViewModel {
    
    var inputQuery: Observable<String?> = Observable(nil)
    var inputRequestSearchTrigger: Observable<APIRouter.Sorting?> = Observable(nil)
    var inputLikeListButtonTrigger: Observable<(Int,String)?> = Observable(nil)
    var inputSortFilterTrigger: Observable<APIRouter.Sorting?> = Observable(nil)
    var inputViewWillDisappear: Observable<Void?> = Observable(nil)
    
    var outputQuery: Observable<String?> = Observable(nil)
    var outputSort: Observable<APIRouter.Sorting?> = Observable(nil)
    var outputTotal: Observable<String?> = Observable(nil)
    var outputLikedList: Observable<[LikedItem]> = Observable([])
    var outputLikedItemIndex: Observable<IndexPath?> = Observable(nil)
    var outputLikedProductIdDict: Observable<[String:IndexPath]> = Observable([:])
    var outputLikedListResult: Observable<RepositoryResult?> = Observable(nil)
    var outputItemList: Observable<[ShopItem]> = Observable([])

    private var responseInfo = SearchResponse<ShopItem>(total: 0, start: 1, display: 30)
    
    override func transform() {
        inputQuery.bind { query in
            self.outputQuery.value = query
        }
        inputRequestSearchTrigger.bind { _ in
            self.requestSearch()
        }
        inputLikeListButtonTrigger.bind { _ in
            self.likeListButtonToggle()
        }
        inputSortFilterTrigger.bind { _ in
            self.clearSearchRecord()
            self.requestSearch()
        }
        inputViewWillDisappear.bind { _ in
            self.closeURLSession()
        }
    }
    
    func clearSearchRecord() {
        outputItemList.value.removeAll()
        responseInfo.total = 0
        responseInfo.start = 1
        inputRequestSearchTrigger.value = inputSortFilterTrigger.value
    }
    
    func pageNation() -> Int? {
        print(#function, responseInfo)
        if responseInfo.start == 1, responseInfo.total == 0 {
            return responseInfo.start
        }
        let start = responseInfo.start + responseInfo.display
        if start > responseInfo.total || start > 1000 {
            print(#function, "마지막 페이지")
            return nil
        }
        responseInfo.start = start
        return start
    }
    
    func setNewResponse(_ response: SearchResponse<ShopItem>) {
        if responseInfo.start > 1, outputItemList.value != nil, let items = response.items {
            var newList = outputItemList.value
            newList.append(contentsOf: items)
            outputItemList.value = newList
        } else if responseInfo.start == 1, let itemList = response.items {
            responseInfo = response
            responseInfo.items = nil
            outputItemList.value = itemList
        }
    }
    
    func requestSearch() {
        guard let start = pageNation() else { return }
        guard let query = outputQuery.value else { return }
        guard let sort = inputRequestSearchTrigger.value == nil ? outputSort.value : inputRequestSearchTrigger.value else {
            return
        }
        outputSort.value = sort
        URLSessionManager.shared.callRequest(query: query, sort: sort, start: start) { [weak self] search, error in
            guard error == nil, let search else {
                return
            }
            self?.setNewResponse(search)
            if self?.responseInfo.start == 1, let total = self?.responseInfo.total{
                self?.outputTotal.value = Int(total).formatted(.number) + Resource.Text.searchTotal
            }
            self?.fetchLikedList()
            self?.addSearchedWord()
        }
    }
    
    private func fetchLikedList() {
        self.user = repository.fetchAll(obejct: object, sortKey: User.Column.signUpDate).first
        
        guard let user else { return }
        
        let oldCount = outputLikedList.value.count
        let newCount = user.likedList.count

        print(#function, "oldCount: ", oldCount, "newCount: ", newCount)
        if oldCount == newCount { return }
        
        var dict = outputLikedProductIdDict.value
        if oldCount > newCount {
            outputLikedList.value = Array(user.likedList)
            dict.keys.forEach { productId in
                self.outputLikedList.value.forEach{ likedItem in
                    if likedItem.productId == productId {
                        return
                    }
                    dict.removeValue(forKey: productId)
                }
            }
        }
        
        if oldCount < newCount {
            let newList = user.likedList.map { likedItem in
                if self.outputLikedList.value.contains(likedItem) {
                    return likedItem
                }
                self.outputItemList.value.enumerated().forEach { index, item in
                    if item.productId == likedItem.productId {
                        dict[likedItem.productId] = IndexPath(row: index, section: 0)
                        return
                    }
                }
                return likedItem
            }
            outputLikedList.value = Array(newList)
        }
        
        outputLikedProductIdDict.value = dict
    }

    private func addSearchedWord() {
        guard let word = outputQuery.value else {
            return
        }
        let searchedWord = SearchedWord(word: word, regDate: Date())
        repository.queryProperty { [weak self] in
            if let count = self?.user?.searchedList.where({$0.word == word}).count, count < 1 {
                self?.user?.searchedList.append(searchedWord)
            }
        } completionHandler: { [weak self] status, error in
            guard error == nil, let status else {
                return
            }
        }
    }
    
    private func likeListButtonToggle(){
        guard let user, let itemInfo = inputLikeListButtonTrigger.value else {
            return
        }
        let row = itemInfo.0
        let productId = itemInfo.1
        print(#function, productId, row)
        print(#function, outputLikedProductIdDict.value)
        if outputLikedProductIdDict.value.keys.contains(productId) {
            deleteLikedItem(productId)
        } else {
            addLikedItem(row)
        }
    }
    
    private func deleteLikedItem(_ productId: String) {
        print(#function, productId)
//        var dict = outputLikedProductIdDict.value
        repository.queryProperty { [weak self] in
            if let item = self?.user?.likedList.where({ $0.productId == productId }) {
//                dict.removeValue(forKey: productId)
                self?.user?.likedList.realm?.delete(item)
            }
        } completionHandler: { [weak self] status, error in
            guard error == nil, let status else {
                self?.outputLikedListResult.value = error!
                return
            }
//            self?.outputLikedProductIdDict.value = dict
            self?.fetchLikedList()
            self?.outputLikedListResult.value = status
        }
    }
    
    private func addLikedItem(_ row: Int) {
        print(#function, row)
        let item = outputItemList.value[row]
        let likedItem = LikedItem(productId: item.productId, link: item.link, image: item.image,mallName: item.mallName, title: item.title, lprice: item.lprice, category1: item.category1, category2: item.category2, category3: item.category3, category4: item.category4, regDate: Date())
        
        repository.queryProperty { [weak self] in
            self?.user?.likedList.append(likedItem)
        } completionHandler: { [weak self] status, error in
            guard error == nil, let status else {
                self?.outputLikedListResult.value = error!
                return
            }
            self?.fetchLikedList()
            self?.outputLikedItemIndex.value = IndexPath(row: row, section: 0)
            self?.outputLikedListResult.value = status
        }
    }
    
    private func closeURLSession() {
        print(#function, "URLSession 종료")
        URLSessionManager.shared.closeSession()
    }
}
