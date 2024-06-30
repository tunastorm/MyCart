//
//  APIRouter.swift
//  MyCart
//
//  Created by 유철원 on 6/13/24.
//

import Foundation
import Alamofire


enum APIRouter: URLRequestConvertible {
    
    case searchShoppings(_ query: String, sort: Sorting)
    
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
        case .searchShoppings(let query, let sort):
            return .get
        }
    }
    
    static let headers: HTTPHeaders = [
        "X-Naver-Client-Id" : NaverSearchAPI.MyAuth.clientID,
        "X-Naver-Client-Secret" : NaverSearchAPI.MyAuth.clientSecret
    ]
    
    private var path: String {
        switch self {
        case .searchShoppings(let query, let sort):
            return "/shop.json"
        }
    }
    
    static var defaultParameters: Parameters = [
        "query" : "",
        "display" : 30,
    ]
    
    private var parameters: Parameters? {
        switch self {
        case .searchShoppings(let query, let sort):
            APIRouter.defaultParameters["query"] = query
            APIRouter.defaultParameters["sort"] = sort.rawValue
            return  APIRouter.defaultParameters
        }
    }
    
    enum Sorting: String, CaseIterable {
        case sim
        case date
        case dsc
        case asc
        
        var buttonTitle: String {
            switch self {
            case .sim:
                return "정확도"
            case .date:
                return "날짜순"
            case .dsc:
                return "가격높은순"
            case .asc:
                return "가격낮은순"
            }
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .searchShoppings(let query, let sort):
            return URLEncoding.default
        }
    }
}
