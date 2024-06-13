//
//  NaverSearchResponse.swift
//  MyCart
//
//  Created by 유철원 on 6/13/24.
//

import UIKit

//class NaverSearchModel<T:Codable> {
//    private init() {}
//    
//    static let newModel = NaverSearchModel()
//    
//    let model = NaverSearchModel.newModel
//    
//    private var searchResponse = SearchResponse<T>(lastBuildDate: "", total: 1, start: 1, display: 1, items: [])
//    
//    func getResponse() -> SearchResponse<T> {
//        return searchResponse
//    }
//    
//    func setResponse<T:Codable>(newResponse: SearchResponse<T>) {
//        searchResponse.items.append(contentsOf: newResponse.items)
//    }
//}

class NaverSearchShopModel {
    
    private init() {}
    
    static let model = NaverSearchShopModel()

    private var searchResponse = SearchResponse<ShopItem>(lastBuildDate: "", total: 1, start: 1, display: 30, items: [])
    
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
            searchResponse.items.append(contentsOf: newValue)
        }
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
    let link: String
    let image: String
    let mallName: String
    let title: String
    let lprice: String
}




