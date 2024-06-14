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
        guard let query else {return}
        
        vc.delegate = self
        model.requestSearch(query, sort: .sim,
                            callback: {() -> () in
            self.vc.itemList = self.model.responseItems
        })
        self.pushAfterView(view: self.vc, backButton: true, animated: true)
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
    
    func scrollDown() {
        if let query, model.pageNation() {
            
            model.requestSearch(query, sort: .sim,
                                callback: {() -> () in
                self.vc.itemList = self.model.responseItems
            })
        }
    }
}
