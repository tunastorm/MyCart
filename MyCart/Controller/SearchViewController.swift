//
//  NetworkController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit


class SearchViewController {
    
    internal let model = NaverSearchShopModel.model
    
    func requestSearch(_ query: String, sort: APIRouter.Sorting, page: Int) {
        model.requestSearch(query, sort: sort, page: page)
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
}
