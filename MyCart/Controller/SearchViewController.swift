//
//  NetworkController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let user = UserModel.model.nowUser
    private let model = NaverSearchShopModel.model
    
    var vc = SearchCollectionViewController()
    
    var query: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        vc.delegate = self
        setNavigationBarUI()
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
            self.setErrorToast()
        })
        vc.nowSort = sort
        setStatusToast()
    }
    
    func clearSearchResponse() {
        model.clearSearchResponse()
    }
    
    func getUserNickName() -> String {
        return user.nickName
    }
    
    func getIsEnd() -> Bool {
        return model.isEnd
    }
    
    func getSearchedList() -> [String] {
        return model.getSearchedList(userId: user.userId)
    }
    
    func setSearchedList(newWord: String) {
        guard let query else {return}
        var searchedList = model.getSearchedList(userId: user.userId)
        if searchedList.contains(query) {
            return
        }
        searchedList.insert(newWord, at: 0)
        model.setSearchedList(userId: user.userId, list: searchedList)
    }
    
    func deleteSearchedWord(deleteWord: String) {
        model.deleteSearchedWord(userId: user.userId, deleteWord: deleteWord)
    }
    
    func deleteSearchedList() {
        model.setSearchedList(userId: user.userId, list: [])
    }
    
    func getLikedList() -> [String] {
        return model.getLikedList(userId: user.userId)
    }
    
    func getLikedListCount() -> Int {
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
        var likedList = model.getLikedList(userId: user.userId)
        return likedList.contains(productId)
    }
    
    func setIsLiked(_ productId: String) {
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
        if let query, model.pageNation() {
            model.requestSearch(query, sort: sort,
            callback: {() -> () in
                self.vc.itemList = self.model.responseItems
            },
            errorCallback: {
                self.setErrorToast()
            })
        }
    }
    
    func setErrorToast() {
        vc.popUpErrorToast(messageEnum: StatusMessage.APIError.requestAPIFailed)
    }
    
    func setStatusToast() {
        vc.popUpStatusToast(messageEnum: StatusMessage.APIStatus.loading)
    }
}
