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
    
    var outputSort: Observable<APIRouter.Sorting?> = Observable(nil)
    var outputTotal: Observable<String?> = Observable(nil)
    var outputLikedList: Observable<[LikedItem]> = Observable([])
    var outputLikedItemIndex: Observable<IndexPath?> = Observable(nil)
    var outputLikedProductIdDict: Observable<[String:IndexPath]> = Observable([:])
    var outputLikedListResult: Observable<RepositoryResult?> = Observable(nil)
    var outputItemList: Observable<[ShopItem]?> = Observable([])
    
    private var responseInfo = SearchResponse<ShopItem>(total: 0, start: 1, display: 30)
    
    private var user: User?
    
    override func transform() {
        inputRequestSearchTrigger.bind { _ in
            self.requestSearch()
        }
        inputLikeListButtonTrigger.bind { _ in
            self.likeListButtonToggle()
        }
    }
    
    func clearSearchRecord() {
        outputItemList.value?.removeAll()
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
        if responseInfo.start > 1, outputItemList.value != nil, let items = response.items {
            responseInfo.start = response.start + response.display
            outputItemList.value?.append(contentsOf: items)
        } else if responseInfo.start == 1 {
            responseInfo = response
            responseInfo.items = nil
            outputItemList.value = response.items
        }
    }
    
    func requestSearch() {
        guard let start = pageNation(), let searchInfo = inputRequestSearchTrigger.value  else {
//            print(#function, "start: \(responseInfo.start) | query: \()")
//            hideToastActivity()
            return
        }
        guard let query = searchInfo.0, let sort = searchInfo.1 == nil ? outputSort.value : searchInfo.1 else {
            return
        }
        guard outputSort.value != sort else {
            return
        }
        outputSort.value = sort
        URLSessionManager.shared.callRequest(query: query, sort: sort, start: start) { search, error in
            guard error == nil, let search else {
//                hideToastActivity()
//                self.rootView.popUpErrorToast(error)
                return
            }
            self.setNewResponse(search)
            print(#function, "검색결과 수: " , self.outputItemList.value?.count)
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
                outputItemList.value?.enumerated().forEach { index, item in
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
        repository.updateProperty {
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
        } else if let item = outputItemList.value?[row] {
            addLikedItem(row)
        }
    }
    
    private func deleteLikedItem(_ productId: String) {
        repository.updateProperty {
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
        guard let user, let item = outputItemList.value?[row] else {
            return
        }
        let likedItem = LikedItem(productId: item.productId, link: item.link, image: item.image,mallName: item.mallName, title: item.title, lprice: item.lprice, regDate: Date())
        
        repository.updateProperty {
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
