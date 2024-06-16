//
//  NetworkController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let user = UserModel.model
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
            print(#function, self.model.responseItems)
            print(#function, self.model.getLikedList(userId: self.user.nowUser.userId) ?? [])
            self.vc.itemList = self.model.responseItems
            self.vc.likedList = self.model.getLikedList(userId: self.user.nowUser.userId) ?? []
            print(#function, self.vc.itemList)
            print(#function, self.vc.likedList)
            
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
        return user.nowUser.nickName
    }
    
    func getIsEnd() -> Bool {
        return model.isEnd
    }
    
    func getSearchedList() -> [String] {
        return model.getSearchedList(userId: user.nowUser.userId) ?? []
    }
    
    func setSearchedList(newList: [String]) {
        model.setSearchedList(userId: user.nowUser.userId, list: newList)
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
        var likedList = model.getLikedList(userId: user.nowUser.userId) ?? []
        return likedList.contains(productId)
    }
    
    func setIsLiked(_ productId: String) {
        var likedList: [String] = model.getLikedList(userId: user.nowUser.userId) ?? []
        if likedList.contains(productId),
           let index = likedList.firstIndex(of: productId) {
            print(#function, productId, index)
            likedList.remove(at: index)
            print(#function, likedList)
        } else {
            likedList.append(productId)
        }
        model.setLikedList(userId: user.nowUser.userId, list: likedList)
        vc.likedList = model.getLikedList(userId: user.nowUser.userId)
        print(#function, "vc: \(vc.likedList)")
    }
    
    func scrollDown(_ sort: APIRouter.Sorting) {
        if let query, model.pageNation() {
            model.requestSearch(query, sort: sort,
                                callback: {() -> () in
                print(#function, self.model.responseItems.count)
                self.vc.itemList = self.model.responseItems
            })
        }
    }
}
