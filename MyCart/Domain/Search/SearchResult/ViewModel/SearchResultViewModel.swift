//
//  SearchResultViewModel.swift
//  MyCart
//
//  Created by 유철원 on 7/10/24.
//

import Foundation
import RealmSwift


final class SearchResultViewModel: BaseViewModel {
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDictItemFromMyCart), name: NSNotification.Name("removeLikedItemInMyCart"), object: nil)
    }
    
    private func clearSearchRecord() {
        outputItemList.value.removeAll()
        responseInfo.total = 0
        responseInfo.start = 1
        inputRequestSearchTrigger.value = inputSortFilterTrigger.value
    }
    
    private func pageNation() -> Int? {
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
    
    private func setNewResponse(_ response: SearchResponse<ShopItem>) {
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
    
    private func requestSearch() {
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
    
    private func fetchLikedList(isAdd: Bool? = nil) {
        self.user = repository.fetchAll(obejct: object, sortKey: User.Column.signUpDate).first
        
        guard let user else { return }

        print(#function, "user.likedList: ", user.likedList)
        
        switch isAdd {
        case true:
            addDictItem(user, dict: outputLikedProductIdDict.value)
        case false:
            deleteDictItem(user, dict: outputLikedProductIdDict.value)
        default: addDictItem(user, dict: [:])
        }
    }
    
    private func addDictItem(_ user: User, dict: [String:IndexPath]) {
        var newDict = dict
        let newList = user.likedList.map { likedItem in
            if self.outputLikedList.value.contains(likedItem) {
                return likedItem
            }
            self.outputItemList.value.enumerated().forEach { index, item in
                if item.productId == likedItem.productId {
                    newDict [likedItem.productId] = IndexPath(row: index, section: 0)
                    return
                }
            }
            return likedItem
        }
        outputLikedList.value = Array(newList)
        outputLikedProductIdDict.value = newDict
    }

    private func deleteDictItem(_ user: User, dict: [String:IndexPath]) {
        var newDict = dict
        outputLikedList.value = Array(user.likedList)
        let likedIds = self.outputLikedList.value.map { $0.productId }
        newDict.keys.forEach { productId in
            if likedIds.contains(productId) {
                return
            }
            newDict.removeValue(forKey: productId)
        }
        print(#function, "삭제된 dict: ",newDict)
        outputLikedProductIdDict.value = newDict
    }
    
    @objc private func deleteDictItemFromMyCart(_ notification: Notification) {
        guard let productId = notification.userInfo?["productId"] as? String else {
            return
        }
        var row: Int?
        outputItemList.value.enumerated().forEach { index, item in
            if item.productId == productId { row = index }
        }
        guard let row else { return }
        fetchLikedList(isAdd: false)
        outputLikedItemIndex.value = IndexPath(row: row, section: 0)
       
    }
    
    private func addSearchedWord() {
        guard let word = outputQuery.value else {
            return
        }
        let searchedWord = SearchedWord(word: word, regDate: Date())
        repository.queryProperty { [weak self] in
            guard let oldWords = self?.user?.searchedList.where({$0.word == word}) else {
                return
            }
            if oldWords.count == 1, let oldWord = oldWords.first {
                self?.user?.searchedList.realm?.delete(oldWord)
            }
            if oldWords.count <= 1 {
                self?.user?.searchedList.append(searchedWord)
            }
        } completionHandler: { [weak self] status, error in
            guard error == nil, let status else {
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name("searchedWordListChanged"), object: nil, userInfo: nil)
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
            deleteLikedItem(row, productId)
        } else {
            addLikedItem(row)
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
            self?.fetchLikedList(isAdd: true)
            self?.outputLikedItemIndex.value = IndexPath(row: row, section: 0)
            self?.outputLikedListResult.value = status
        }
    }
    
    private func deleteLikedItem(_ row: Int, _ productId: String) {
        print(#function, productId)
        repository.queryProperty { [weak self] in
            if let item = self?.user?.likedList.where({ $0.productId == productId }) {
                self?.user?.likedList.realm?.delete(item)
            }
        } completionHandler: { [weak self] status, error in
            guard error == nil, let status else {
                self?.outputLikedListResult.value = error!
                return
            }
            self?.fetchLikedList(isAdd: false)
            self?.outputLikedItemIndex.value = IndexPath(row: row, section: 0)
            self?.outputLikedListResult.value = status
        }
    }
    
    private func closeURLSession() {
        print(#function, "URLSession 종료")
        URLSessionManager.shared.closeSession()
    }
}
