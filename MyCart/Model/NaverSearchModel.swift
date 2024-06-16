//
//  NaverSearchResponse.swift
//  MyCart
//
//  Created by 유철원 on 6/13/24.
//

import UIKit


class NaverSearchShopModel {
    
    private init() {}
    
    static let model = NaverSearchShopModel()

    private var searchResponse = SearchResponse<ShopItem>(lastBuildDate: "", total: 1, start: 1, display: 30, items: [])
    
    var isEnd = false
    
    var page = 1
    
    var maxStart = 1000
 
    func requestSearch(_ query: String, sort: APIRouter.Sorting, callback: @escaping () -> ()) {
        APIClient.request(SearchResponse<ShopItem>.self,
                          router: APIRouter.searchShoppings(query, sort: sort),
                          success: {(response: SearchResponse<ShopItem>) -> () in
                               print(#function, response.display, response.items.count)
                               self.setNewResponse(response)
                               callback()
                          },
                          failure: {(error: Error) -> () in
                               print(error)
                          }
        )
    }
    
    func pageNation() -> Bool {
        page += 1
        start = ((page - 1) * 30) + 1
        print(#function, page, start, total)
        if start > maxStart {
            isEnd.toggle()
            return false
        }
        APIRouter.defaultParameters["start"] = start
        return true
    }
    
    func setNewResponse(_ response: SearchResponse<ShopItem>) {
        if page == 1 {
            searchResponse = response
        } else if page > 1 {
            self.lastBuildDate = response.lastBuildDate
            self.start = response.start
            self.responseItems = response.items
        }
    }
    
    func clearSearchResponse() {
        isEnd = false
        page = 1
        searchResponse.start = 1
        searchResponse.items = []
    }
    
    var lastBuildDate: String {
        get {
            return searchResponse.lastBuildDate
        }
        
        set {
            searchResponse.lastBuildDate = newValue
        }
    }
    
    var total: Int {
        return searchResponse.total
    }
    
    var start: Int {
        get {
            return searchResponse.start
        }
        set {
            searchResponse.start = newValue
        }
    }
    
    var display: Int {
        return searchResponse.display
    }
    
    var responseItems: [ShopItem] {
        get {
            return searchResponse.items
        }
        set {
            var oldList = searchResponse.items
            oldList.append(contentsOf: newValue)
            searchResponse.items = oldList
        }
    }
    
    func getSearchedList(userId: String) -> [String]? {
        return UserDefaultsHelper.getSearchedList(userId)
    }
    
    func setSearchedList(userId: String, list: [String]) {
        UserDefaultsHelper.setSearchedList(userId, list)
    }
   
    func getLikedList(userId: String) -> [String]? {
        return UserDefaultsHelper.getLikedList(userId)
    }
    
    func setLikedList(userId: String, list: [String]) {
        UserDefaultsHelper.setLikedList(userId, list)
    }
}


struct SearchResponse<T: Codable>: Codable {
    var lastBuildDate: String
    let total: Int
    var start: Int
    let display: Int
    var items: [T]
}

struct ShopItem: Codable {
    let productId: String
    let link: String
    let image: String
    let mallName: String
    let title: String
    let lprice: String
}




