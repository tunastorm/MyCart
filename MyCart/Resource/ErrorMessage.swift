//
//  ErrorMessage.swift
//  MyCart
//
//  Created by 유철원 on 6/18/24.
//

import Foundation


enum ErrorMessage: Error {
    
    enum API: Error {
        case NetworkFailed
        
        var message: String {
            switch self {
            case .NetworkFailed:
                return "[서버 연결 실패]\n네트워크 상태를 확인하세요"
            }
        }
    }
    
    enum NickNameFilter: Error {
        
    }
}
