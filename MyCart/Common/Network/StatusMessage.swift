//
//  ErrorMessage.swift
//  MyCart
//
//  Created by 유철원 on 6/18/24.
//

import Foundation


enum StatusMessage: Error {
    
    static let incorrectCase = "잘못된 케이스가 전달되었습니다"
    
    enum APIStatus {
        case loading
        case lastPage
        
        var message: String {
            switch self {
            case .loading:
                return "로딩중..."
            case .lastPage:
                return "마지막 페이지 입니다"
            }
        }
    }
}
