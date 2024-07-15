//
//  URLSessionClient.swift
//  MyCart
//
//  Created by 유철원 on 6/30/24.
//

import Foundation



final class URLSessionManager{
    typealias completionHandler = (SearchResponse<ShopItem>?, APIError?) -> Void
    
    static let shared = URLSessionManager()
    
    private init() {}
    
    func callRequest(query: String, sort: APIRouter.Sorting, start: Int, completionHandler: @escaping (SearchResponse<ShopItem>?, APIError?) -> Void) {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "openapi.naver.com"
        component.path = "/v1/search/shop.json"
        let headers =  [
            "X-Naver-Client-Id" : NaverSearchAPI.MyAuth.clientID,
            "X-Naver-Client-Secret" : NaverSearchAPI.MyAuth.clientSecret
        ]
        component.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "sort", value: sort.rawValue),
            URLQueryItem(name: "display", value: String(30)),
            URLQueryItem(name: "start", value: String(start))
        ]
        guard let url = component.url else {
            return
        }
        var request = URLRequest(url: url, timeoutInterval: 5)
        request.httpMethod = "GET"
        _ = headers.map { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completionHandler(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    completionHandler(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    switch response.statusCode {
                    case 300..<400: completionHandler(nil, .redirectError)
                    case 400..<500: completionHandler(nil, .clientError)
                    case 500..<600: completionHandler(nil, .serverError)
                    default: completionHandler(nil, .unExpectedError)
                    }
                    return
                }
                do {
                    let result = try JSONDecoder().decode(SearchResponse<ShopItem>.self, from: data)
//                    print(result)
                    completionHandler(result, nil)
                } catch {
                    completionHandler(nil, .invalidData)
                }
            }
        }.resume()
//        URLSession.shared.finishTasksAndInvalidate()
    }
    
    func closeSession() {
        URLSession.shared.finishTasksAndInvalidate()
        print(#function, "Session Finished")
    }
}
