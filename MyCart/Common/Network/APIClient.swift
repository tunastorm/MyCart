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
    
    private static func convertAFError(error: AFError) -> APIError {
        var apiError: APIError
        switch error {
        case .sessionDeinitialized:
            apiError = APIError.networkError
        case .sessionInvalidated(let error):
            apiError = APIError.networkError
        case .sessionTaskFailed(let error):
            apiError = APIError.networkError
        case .responseSerializationFailed:
            apiError = APIError.noResultError
        default: apiError = APIError.unExpectedError
        }
        return apiError
    }
    
    private static func convertResponseStatus(errorCode: Int) -> APIError {
        var apiError = APIError.noResultError
        switch errorCode {
        case 300 ..< 400:
            apiError = APIError.redirectError
        case 400 ..< 500:
            apiError = APIError.clientError
        case 500 ..< 600:
            apiError = APIError.serverError
        default: APIError.networkError
        }
        return apiError
    }
}
