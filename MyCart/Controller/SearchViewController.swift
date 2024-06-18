//
//  NetworkController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var user: User?
    private let model = NaverSearchShopModel.model
    
    var vc = SearchCollectionViewController()
    
    var query: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setUser()
        setNavigationBarUI()
        vc.delegate = self
    }
    
    func requestSearch(_ sort: APIRouter.Sorting) {
        guard let query else {return}
        model.requestSearch(query, sort: sort,
        callback: {
            self.setSearchedList(newWord: query)
            self.vc.itemList = self.model.responseItems
            self.vc.likedList = self.getLikedList()
            if self.model.page == 1 {
                self.vc.totalLabel.text = Int(self.getTotal()).formatted(.number)
                                          + Resource.Text.searchTotal
            }
        }, errorCallback: {
            self.setErrorToast(messageEnum: StatusMessage.APIError.requestAPIFailed)
        })
        vc.nowSort = sort
        setStatusToast(messageEnum: StatusMessage.APIStatus.loading)
    }
    
    func clearSearchResponse() {
        model.clearSearchResponse()
    }
    
    func setUser() {
        user = UserModel.model.nowUser
        print(#function, user)
    }
    
    func getUserNickName() -> String {
        guard let user else {
            return Resource.Text.guestUser
        }
        return user.nickName
    }
    
    func getIsEnd() -> Bool {
        return model.isEnd
    }
    
    func getSearchedList() -> [String] {
        guard let user else {return []}
        return model.getSearchedList(userId: user.userId)
    }
    
    func setSearchedList(newWord: String) {
        guard let query, let user else {return}
        var searchedList = model.getSearchedList(userId: user.userId)
        if searchedList.contains(query) {
            return
        }
        searchedList.insert(newWord, at: 0)
        model.setSearchedList(userId: user.userId, list: searchedList)
    }
    
    func deleteSearchedWord(deleteWord: String) {
        guard let user else {return}
        model.deleteSearchedWord(userId: user.userId, deleteWord: deleteWord)
    }
    
    func deleteSearchedList() {
        guard let user else {return}
        model.setSearchedList(userId: user.userId, list: [])
    }
    
    func getLikedList() -> [String] {
        guard let user else {return []}
        return model.getLikedList(userId: user.userId)
    }
    
    func getLikedListCount() -> Int {
        guard let user else {return 0}
        let list = model.getLikedList(userId: user.userId)
        return list.count
    }
    
    func getLastBuildDate() -> String {
        return model.lastBuildDate
    }
    
    func getTotal() -> Int {
        return model.total
    }
    
    func getStart() -> Int {
        return model.start
    }
    
    func getDisplay() -> Int {
        return model.display
    }
    
    func getResponsItems() -> [ShopItem]{
        return model.responseItems
    }
    
    func getIsLiked(productId: String) -> Bool {
        guard let user else {return false}
        var likedList = model.getLikedList(userId: user.userId)
        return likedList.contains(productId)
    }
    
    func setIsLiked(_ productId: String) {
        guard let user else {return}
        var likedList = model.getLikedList(userId: user.userId)
        if likedList.contains(productId),
           let index = likedList.firstIndex(of: productId) {
            likedList.remove(at: index)
        } else {
            likedList.append(productId)
        }
        model.setLikedList(userId: user.userId, list: likedList)
        vc.likedList = model.getLikedList(userId: user.userId)
    }
    
    func searchScrollDown(_ sort: APIRouter.Sorting) {
        print(#function, "스크롤 시도")
        if let query, model.pageNation() {
            model.requestSearch(query, sort: sort,
            callback: {() -> () in
                self.vc.itemList = self.model.responseItems
            },
            errorCallback: {
                self.setErrorToast(messageEnum: StatusMessage.APIError.requestAPIFailed)
            })
        } else {
            print(#function, "마지막 페이지")
            setStatusToast(messageEnum: StatusMessage.APIStatus.lastPage)
        }
    }
    
    func setErrorToast(messageEnum: StatusMessage.APIError) {
        vc.popUpErrorToast(messageEnum)
    }
    
    func setStatusToast(messageEnum: StatusMessage.APIStatus) {
        vc.popUpStatusToast(messageEnum)
    }
}
