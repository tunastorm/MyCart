//
//  APIRouter.swift
//  MyCart
//
//  Created by 유철원 on 6/13/24.
//

import Foundation
import Alamofire


enum APIRouter: URLRequestConvertible {
    
    case searchShoppings(_ query: String, sort: Sorting, page: Int)
    
    func asURLRequest() throws -> URLRequest {
        let url = NaverSearchAPI.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        
        urlRequest.method = method
        urlRequest.headers = APIRouter.headers
        
        if let parameters = parameters {
            return try encoding.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchShoppings(let query, let sort, let page):
            return .get
        }
    }
    
    static let headers: HTTPHeaders = [
        "X-Naver-Client-Id" : NaverSearchAPI.MyAuth.clientID,
        "X-Naver-Client-Secret" : NaverSearchAPI.MyAuth.clientSecret
    ]
    
    private var path: String {
        switch self {
        case .searchShoppings(let query, let sort, let page):
            return "/shop.json"
        }
    }
    
    static var defaultParameters: Parameters = [
        "query" : "",
        "display" : 30,
    ]
    
    private var parameters: Parameters? {
        switch self {
        case .searchShoppings(let query, let sort, let page):
            APIRouter.defaultParameters["query"] = query
            APIRouter.defaultParameters["sort"] = sort.rawValue
            APIRouter.defaultParameters["start"] = pageNation(page)
            return  APIRouter.defaultParameters
        }
    }
    
    enum Sorting: String {
        case sim
        case date
        case desc
        case asc
    }
    
    func pageNation(_ page: Int) -> Int {
        return ((page - 1) * 30) + 1
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .searchShoppings(let query, let sort, let page):
            return URLEncoding.default
        }
    }
}
