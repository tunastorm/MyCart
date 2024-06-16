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
        print(#function, sort)
        model.requestSearch(query, sort: sort,
                            callback: {() -> () in
            self.setSearchedList(newWord: query)
            
            self.vc.itemList = self.model.responseItems
            self.vc.likedList = self.model.getLikedList(userId: self.user.userId)
            
            if self.model.page == 1 {
                self.vc.totalLabel.text = Int(self.getTotal()).formatted(.number)
                                          + Resource.Text.searchTotal
            }
        })
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
        print(#function, "likedList: \(likedList)")
        if likedList.contains(productId),
           let index = likedList.firstIndex(of: productId) {
            print(#function, productId, index)
            likedList.remove(at: index)
            print(#function, likedList)
        } else {
            likedList.append(productId)
            print(#function, likedList)
        }
        model.setLikedList(userId: user.userId, list: likedList)
        vc.likedList = model.getLikedList(userId: user.userId)
        print(#function, "vc: \(vc.likedList)")
    }
    
    func searchedWordScrollDown() {
        // 최근 검색어 페이징 구현
    }
    
    func searchScrollDown(_ sort: APIRouter.Sorting) {
        if let query, model.pageNation() {
            model.requestSearch(query, sort: sort,
                                callback: {() -> () in
                print(#function, self.model.responseItems.count)
                self.vc.itemList = self.model.responseItems
            })
        }
    }
}
