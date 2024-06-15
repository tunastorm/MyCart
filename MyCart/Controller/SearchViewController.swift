//
//  NetworkController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit


class SearchViewController: UIViewController {
    
    private let model = NaverSearchShopModel.model
    
    let vc = SearchCollectionViewController()
    
    var query: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
//        UserDefaultHelper.standard.userDefaults.removeObject(forKey: "likedList")
        vc.delegate = self
        requestSearch(.sim)
        setNavigationBarUI()
        self.pushAfterView(view: self.vc, backButton: true, animated: true)
    }
    
    func requestSearch(_ sort: APIRouter.Sorting) {
        guard let query else {return}
        print(#function, sort)
        model.requestSearch(query, sort: sort,
                            callback: {() -> () in
            self.vc.itemList = self.model.responseItems
            self.vc.likedList = self.model.likedList
            if self.model.page == 1 {
                self.vc.totalLabel.text = Int(self.getTotal()).formatted(.number) 
                                          + Resource.Text.searchTotal
            }
        })
    }
    
    func clearSearchResponse() {
        model.clearSearchResponse()
    }
    
    func getIsEnd() -> Bool {
        return model.isEnd
    }
    
    func getSearchedList() -> [String] {
       return model.searchedList
    }
    
    func setSearchedList(newList: [String]) {
        model.searchedList = newList
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
        let likedList = model.likedList
        return likedList.contains(productId)
    }
    
    func setIsLiked(_ productId: String) {
        var likedList = model.likedList
        if likedList.contains(productId),
           let index = likedList.firstIndex(of: productId) {
            print(#function, productId, index)
            likedList.remove(at: index)
            print(#function, likedList)
        } else {
            likedList.append(productId)
        }
        model.likedList = likedList
        vc.likedList = model.likedList
        print(#function, "vc: \(vc.likedList)")
        print(#function, "model: \(model.likedList)")
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
