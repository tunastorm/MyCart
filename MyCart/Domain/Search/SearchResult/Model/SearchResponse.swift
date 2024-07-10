//
//  SearchResponse.swift
//  MyCart
//
//  Created by 유철원 on 7/1/24.
//

import Foundation


struct SearchResponse<T: Codable>: Codable {
    var total: Int
    var start: Int
    let display: Int
    var items: [T]?
}

struct ShopItem: Codable {
    let productId: String
    let link: String
    let image: String
    let mallName: String
    let title: String
    let lprice: String
}
