//
//  NetworkController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit


class APIController {
    
    internal let model = NaverSearchShopModel.model
    
    func getResponsItems() -> [ShopItem]{
        return model.responseItems
    }
    
    func getStart() -> Int {
        return model.start
    }
}

class TableViewAPIController: APIController {
        
    let delegate: UITableView?
    
    init(delegate: UITableView?) {
        self.delegate = delegate
    }
    
    func requestSearch(_ query: String, sort: APIRouter.Sorting, page: Int) {
        APIClient.request(SearchResponse<ShopItem>.self,
                          router: APIRouter.searchShoppings(query, sort: sort, page: page),
                          success: {(response: SearchResponse<ShopItem>) -> () in
                              super.model.lastBuildDate = response.lastBuildDate
                              super.model.start = response.start
                              super.model.responseItems = response.items
                              self.delegate?.reloadData()
                          },
                          failure: {(error: Error) -> () in
                               print(error)
                          }
        )
    }
}

class CollectionViewAPIController: APIController {
    let delegate: UICollectionView?
    
    init(delegate: UICollectionView?) {
        self.delegate = delegate
    }
    
    func requestSearch(_ query: String, sort: APIRouter.Sorting, page: Int) {
        APIClient.request(SearchResponse<ShopItem>.self,
                          router: APIRouter.searchShoppings(query, sort: sort, page: page),
                          success: {(response: SearchResponse<ShopItem>) -> () in
                              super.model.lastBuildDate = response.lastBuildDate
                              super.model.start = response.start
                              super.model.responseItems = response.items
                              self.delegate?.reloadData()
                          },
                          failure: {(error: Error) -> () in
                               print(error)
                          }
        )
    }
}
