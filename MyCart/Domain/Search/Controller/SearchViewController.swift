//
//  NetworkController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit

protocol SearResultViewDelegate {
    
}


class SearchViewController: UIViewController {

    var rootView = SearchResultView()
    let detailVC = ProductDetailViewController()
    
    private var user: User?
    private let model = NaverSearchShopModel.shared

    var query: String?
    
    override func loadView() {
        view = rootView
        rootView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setUser()
        setNavigationBarUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = query
        rootView.totalLabel.text = Int(getTotal()).formatted() + Resource.Text.searchTotal
    }
    
    func requestSearch(_ sort: APIRouter.Sorting) {
        guard let query else {return}
        model.requestSearch(query, sort: sort,
        callback: {
            self.setSearchedList(newWord: query)
            self.rootView.itemList = self.model.responseItems
            self.rootView.likedList = self.getLikedList()
            if self.model.page == 1 {
                self.rootView.totalLabel.text = Int(self.getTotal()).formatted(.number)
                                          + Resource.Text.searchTotal
            }
        }, errorCallback: {
            self.setErrorToast(messageEnum: StatusMessage.APIError.requestAPIFailed)
        })
        rootView.nowSort = sort
        setStatusToast(messageEnum: StatusMessage.APIStatus.loading)
    }
    
    func clearSearchResponse() {
        model.clearSearchResponse()
    }
    
    func setUser() {
        user = UserModel.shared.nowUser
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
    
    func getLikedList() -> [String] {
        return userModel?.getLikedList()
    }
    
    func getLikedListCount() -> Int {
        guard let user else {return 0}
        let list = userModel?.getLikedList()
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
        rootView.likedList = model.getLikedList(userId: user.userId)
    }
    
    func searchScrollDown(_ sort: APIRouter.Sorting) {
        if let query, model.pageNation() {
            model.requestSearch(query, sort: sort,
            callback: {() -> () in
                self.rootView.itemList = self.model.responseItems
            },
            errorCallback: {
                self.setErrorToast(messageEnum: StatusMessage.APIError.requestAPIFailed)
            })
        } else {
            setStatusToast(messageEnum: StatusMessage.APIStatus.lastPage)
        }
    }
    
    func setErrorToast(messageEnum: StatusMessage.APIError) {
//        vc.popUpErrorToast(messageEnum)
    }
    
    func setStatusToast(messageEnum: StatusMessage.APIStatus) {
//        vc.popUpStatusToast(messageEnum)
    }
}

