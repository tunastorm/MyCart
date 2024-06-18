//
//  APIClient.swift
//  MyCart
//
//  Created by 유철원 on 6/13/24.
//

import Foundation
import Alamofire


class APIClient {
    typealias onSuccess<T> = ((T) -> Void)
    typealias onFailure = ((_ error: Error) -> Void)
    
    static func request<T>(_ object: T.Type,
                           router: APIRouter,
                           success: @escaping onSuccess<T>,
                           failure: @escaping onFailure) where T:
    Decodable {
        AF.request(router)
            .responseDecodable(of: object) { response in
                switch response.result {
                case .success:
                    guard let decodedData = response.value else {return}
                    success(decodedData)
                case .failure(let err):
                    failure(err)
                }
            }
    }
}
