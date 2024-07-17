//
//  URLSessionClient.swift
//  MyCart
//
//  Created by 유철원 on 6/30/24.
//

import Foundation



final class URLSessionManager{
    typealias CompletionHandler = (Result<SearchResponse<ShopItem>, APIError>) -> Void
    
    static let shared = URLSessionManager()
    
    private init() {}
    
    func callRequest(query: String, sort: APIRouter.Sorting, start: Int, completionHandler: @escaping CompletionHandler) {
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
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completionHandler(.failure(.failedRequest))
                    return
                }
                
                guard let data = data else {
                    completionHandler(.failure(.noData))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(.failure(.invalidResponse))
                    return
                }
                
                guard response.statusCode == 200 else {
                    switch response.statusCode {
                    case 300..<400: completionHandler(.failure(.redirectError))
                    case 400..<500: completionHandler(.failure(.clientError))
                    case 500..<600: completionHandler(.failure(.serverError))
                    default: completionHandler(.failure(.serverError))
                    }
                    return
                }
                do {
                    let result = try JSONDecoder().decode(SearchResponse<ShopItem>.self, from: data)
//                    print(result)
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(.invalidData))
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
