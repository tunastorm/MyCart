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
//    var outputLikedList: Observable<Results<LikedItem>?> = Observable(nil)
    var outputLikedList: Observable<[LikedItem]> = Observable([])
    var outputLikedItemIndex: Observable<IndexPath?> = Observable(nil)
    var outputLikedProductIdDict: Observable<[String:IndexPath]> = Observable([:])
    var outputLikedListResult: Observable<RepositoryResult?> = Observable(nil)
    var outputItemList: Observable<[ShopItem]> = Observable([])

    private var responseInfo = SearchResponse<ShopItem>(total: 0, start: 1, display: 30)
    
    override func transform() {
        inputQuery.bind { [weak self] query in
            guard let query else { return }
            self?.setQuery(query)
        }
        inputRequestSearchTrigger.bind { [weak self] _ in
            self?.requestSearch()
        }
        inputLikeListButtonTrigger.bind { [weak self] _ in
            self?.likeListButtonToggle()
        }
        inputSortFilterTrigger.bind { [weak self] _ in
            self?.clearSearchRecord()
            self?.requestSearch()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDictItemFromMyCart), name: NSNotification.Name("removeLikedItemInMyCart"), object: nil)
    }
    
    private func setQuery(_ query: String) {
        outputQuery.value = query
    }
    
    private func clearSearchRecord() {
        outputItemList.value.removeAll()
        responseInfo.total = 0
        responseInfo.start = 1
        let sort = inputSortFilterTrigger.value
        inputRequestSearchTrigger.value = sort
    }
    
    private func pageNation() -> Int? {
        if responseInfo.start == 1, responseInfo.total == 0 {
            return responseInfo.start
        }
        let start = responseInfo.start + responseInfo.display
        if start > responseInfo.total || start > 1000 {
            makeBasicToast(message: "마지막 페이지 입니다", duration: 3.0, position: .bottom)
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
        makeLoadingToast(positon: .center)
        URLSessionManager.shared.callRequest(query: query, sort: sort, start: start) { [weak self] result in
            switch result {
            case .success(let response):
                self?.setNewResponse(response)
                if self?.responseInfo.start == 1, let total = self?.responseInfo.total{
                    self?.outputTotal.value = Int(total).formatted(.number) + Resource.Text.searchTotal
                }
                self?.fetchLikedList()
                self?.addSearchedWord()
                URLSessionManager.shared.closeSession()
//                self?.deinitAllObservables()
                hideToastActivity()
            case .failure(let error):
                hideToastActivity()
                makeBasicToast(message: error.message, duration: 3.0, position: .bottom)
            }
        }
    }
    
    private func fetchLikedList(isAdd: Bool? = nil) {
        self.user = repository.fetchAll(obejct: object, sortKey: User.Column.signUpDate).first
        
        guard let user else { return }
        
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
        let newList = user.likedList.map { [weak self] likedItem in
            if let likedList = self?.outputLikedList.value, likedList.contains(likedItem) {
                return likedItem
            }
            guard let itemList = self?.outputItemList.value else { return likedItem }
            for (index, item) in itemList.enumerated() {
                if item.productId == likedItem.productId {
                    newDict[likedItem.productId] = IndexPath(row: index, section: 0)
                    break
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
        outputLikedProductIdDict.value = newDict
    }
    
    @objc private func deleteDictItemFromMyCart(_ notification: Notification) {
        guard let productId = notification.userInfo?["productId"] as? String else {
            return
        }
        var row: Int?
        outputItemList.value.enumerated().forEach { [weak self] index, item in
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
        } completionHandler: { result in
            switch result {
            case .success(let status):
                NotificationCenter.default.post(name: NSNotification.Name("searchedWordListChanged"), object: nil, userInfo: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func likeListButtonToggle(){
        guard let user, let itemInfo = inputLikeListButtonTrigger.value else {
            return
        }
        let row = itemInfo.0
        let productId = itemInfo.1
        if outputLikedProductIdDict.value.keys.contains(productId) {
            deleteLikedItem(row, productId)
        } else {
            addLikedItem(row)
        }
    }
    
    private func addLikedItem(_ row: Int) {
        let item = outputItemList.value[row]
        let likedItem = LikedItem(productId: item.productId, link: item.link, image: item.image,mallName: item.mallName, title: item.title, lprice: item.lprice, category1: item.category1, category2: item.category2, category3: item.category3, category4: item.category4, regDate: Date())
        
        repository.queryProperty { [weak self] in
            self?.user?.likedList.append(likedItem)
        } completionHandler: { [weak self] result in
            switch result {
            case .success(let status):
                self?.fetchLikedList(isAdd: true)
                self?.outputLikedItemIndex.value = IndexPath(row: row, section: 0)
                self?.outputLikedListResult.value = status
            case .failure(let error):
                self?.outputLikedListResult.value = error
            }
        }
    }
    
    private func deleteLikedItem(_ row: Int, _ productId: String) {
        print(#function, productId)
        repository.queryProperty { [weak self] in
            if let item = self?.user?.likedList.where({ $0.productId == productId }) {
                self?.user?.likedList.realm?.delete(item)
            }
        } completionHandler: { [weak self] result in
            switch result {
            case .success(let status):
                self?.fetchLikedList(isAdd: false)
                self?.outputLikedItemIndex.value = IndexPath(row: row, section: 0)
                self?.outputLikedListResult.value = status
            case .failure(let error):
                self?.outputLikedListResult.value = error
            }
        }
    }
    
    // SearchResultViewController deinit 테스트
    private func deinitAllObservables() {
        print(#function)
//        inputQuery = Observable(nil)
//        inputRequestSearchTrigger = Observable(nil)
//        inputLikeListButtonTrigger = Observable(nil)
//        inputSortFilterTrigger = Observable(nil)
//        inputViewWillDisappear = Observable(nil)
//        
//        outputQuery = Observable(nil)
//        outputSort = Observable(nil)
//        outputTotal = Observable(nil)
//        outputLikedList = Observable([])
//        outputLikedItemIndex = Observable([])
//        outputLikedProductIdDict = Observable([:])
//        outputLikedListResult = Observable(nil)
        outputItemList = Observable([])
    }
}
