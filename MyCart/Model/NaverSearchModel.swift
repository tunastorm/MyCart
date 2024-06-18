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
 
    func requestSearch(_ query: String, sort: APIRouter.Sorting, callback: @escaping () -> (), errorCallback: @escaping () -> ()) {
        APIClient.request(SearchResponse<ShopItem>.self,
                          router: APIRouter.searchShoppings(query, sort: sort),
                          success: {(response: SearchResponse<ShopItem>) -> () in
                              print(#function, response)
                              self.setNewResponse(response)
                              callback()
                          },
                          failure: {(error: Error) -> () in
                              print(error)
                              // 에러 타입을 받아서 메시지를 리턴해주면 좋을 듯
                              errorCallback()
                          }
        )
    }
    
    func pageNation() -> Bool {
        page += 1
        start = ((page - 1) * 30) + 1
        if start > total || start > maxStart {
            isEnd = true
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
        print(#function, "SearchResponse 초기화")
        isEnd = false
        page = 1
        searchResponse.start = 1
        searchResponse.items = []
        print(#function, searchResponse)
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
    
    func getSearchedList(userId: String) -> [String] {
        return UserDefaultsHelper.getSearchedList(userId) ?? []
    }
    
    func setSearchedList(userId: String, list: [String]) {
        UserDefaultsHelper.setSearchedList(userId, list)
    }
    
    func deleteSearchedWord(userId: String, deleteWord: String) {
        guard let oldList = UserDefaultsHelper.getSearchedList(userId),
              let index = oldList.firstIndex(of: deleteWord) else {return}
        var newList = oldList
        newList.remove(at: index)
        UserDefaultsHelper.setSearchedList(userId, newList)
    }
    
    func getLikedList(userId: String) -> [String] {
        return UserDefaultsHelper.getLikedList(userId) ?? []
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




