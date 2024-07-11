//
//  SearchResultViewModel.swift
//  MyCart
//
//  Created by 유철원 on 7/10/24.
//

import Foundation
import RealmSwift


class SearchResultViewModel: BaseViewModel {
   
    var inputRequestSearchTrigger: Observable<(String?, APIRouter.Sorting?)?> = Observable(nil)
    var inputLikeListButtonTrigger: Observable<(Int,String)?> = Observable(nil)
    var inputSortFilterTrigger: Observable<(String, APIRouter.Sorting)?> = Observable(nil)
    
    var outputSort: Observable<APIRouter.Sorting?> = Observable(nil)
    var outputTotal: Observable<String?> = Observable(nil)
    var outputLikedList: Observable<[LikedItem]> = Observable([])
    var outputLikedItemIndex: Observable<IndexPath?> = Observable(nil)
    var outputLikedProductIdDict: Observable<[String:IndexPath]> = Observable([:])
    var outputLikedListResult: Observable<RepositoryResult?> = Observable(nil)
    var outputItemList: Observable<[ShopItem]> = Observable([])
    
    private var responseInfo = SearchResponse<ShopItem>(total: 0, start: 1, display: 30)
    
    private var user: User?
    
    override func transform() {
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
        print(#function, responseInfo)
        return start
    }
    
    func setNewResponse(_ response: SearchResponse<ShopItem>) {
        if responseInfo.start > 1, outputItemList.value != nil, let items = response.items {
            print(#function, "야 임마!")
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
        guard let start = pageNation(), let searchInfo = inputRequestSearchTrigger.value  else {
            print(#function, "마지막 페이지 start: \(responseInfo.start)")
//            hideToastActivity()
            return
        }
        print(#function, searchInfo)
        guard let query = searchInfo.0, let sort = searchInfo.1 == nil ? outputSort.value : searchInfo.1 else {
            print(#function, "쿼리, 정렬 입력 안됨")
            return
        }
        print(#function, "정렬방식: ", sort)
        outputSort.value = sort
        URLSessionManager.shared.callRequest(query: query, sort: sort, start: start) { search, error in
            guard error == nil, let search else {
//                hideToastActivity()
//                self.rootView.popUpErrorToast(error)
                return
            }
            self.setNewResponse(search)
            print(#function, "\(self.outputSort.value) 검색결과 수: " , self.outputItemList.value.count)
            if self.responseInfo.start == 1 {
                self.outputTotal.value = Int(self.responseInfo.total).formatted(.number) + Resource.Text.searchTotal
            }
            self.fetchLikedList()
            self.addSearchedWord()
        }
    }
    
    private func fetchLikedList() {
        guard let user = repository.fetchAll(obejct: object, sortKey: User.Column.signUpDate).first else {
            return
        }
        self.user = user
        print(#function, "아웃풋", outputLikedList.value.count, "현재", user.likedList.count)
        if outputLikedList.value.count != user.likedList.count {
            var dict: [String:IndexPath] = [:]
            user.likedList.forEach { likedItem in
                if outputLikedList.value.contains(likedItem) {
                    return
                }
                outputItemList.value.enumerated().forEach { index, item in
                    if item.productId == likedItem.productId {
                        dict[likedItem.productId] = IndexPath(row: index, section: 0)
                        return
                    }
                }
            }
            outputLikedProductIdDict.value = dict
            outputLikedList.value = Array(user.likedList)
        }
    }
    
    private func addSearchedWord() {
        guard let word = inputRequestSearchTrigger.value?.0, let user else {
            return
        }
        let searchedWord = SearchedWord(word: word, regDate: Date())
        repository.queryProperty {
            if user.searchedList.where({$0.word == word}).count < 1 {
                user.searchedList.append(searchedWord)
            }
        } completionHandler: { status, error in
            guard error == nil, let status else {
                return
            }
        }
    }
    
    private func likeListButtonToggle(){
        guard let user, let itemInfo = inputLikeListButtonTrigger.value else {
            print(#function, "")
            return
        }
        let row = itemInfo.0
        let productId = itemInfo.1
        print(#function, "row: ", row, "productId: ", productId)
        if outputLikedProductIdDict.value.keys.contains(productId) {
            deleteLikedItem(productId)
        } else {
            addLikedItem(row)
        }
    }
    
    private func deleteLikedItem(_ productId: String) {
        repository.queryProperty {
            if let item = user?.likedList.where({ $0.productId == productId }) {
                user?.likedList.realm?.delete(item)
            }
        } completionHandler: { status, error in
            guard error == nil, let status else {
                outputLikedListResult.value = error!
                return
            }
            self.fetchLikedList()
            outputLikedListResult.value = status
        }
    }
    
    private func addLikedItem(_ row: Int) {
        guard let user  else {
            return
        }
        let item = outputItemList.value[row]
        let likedItem = LikedItem(productId: item.productId, link: item.link, image: item.image,mallName: item.mallName, title: item.title, lprice: item.lprice, category1: item.category1, category2: item.category2, category3: item.category3, category4: item.category4, regDate: Date())
        
        repository.queryProperty {
            user.likedList.append(likedItem)
        } completionHandler: { status, error in
            guard error == nil, let status else {
                outputLikedListResult.value = error!
                return
            }
            self.fetchLikedList()
            outputLikedItemIndex.value = IndexPath(row: row, section: 0)
            outputLikedListResult.value = status
        }
    }
}
