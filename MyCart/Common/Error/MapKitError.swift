//
//  MapKitError.swift
//  MyCart
//
//  Created by 유철원 on 7/1/24.
//

import Foundation


enum MapKitError: Error {
    
    case productURLNotExist
    case productConnectionFailed
    
    var message: String {
        switch self {
        case .productURLNotExist:
            return "앗... 이 상품의 링크가 사라졌어요"
        case .productConnectionFailed:
            return "앗... 상품 페이지 연결에 실패했어요"
        }
    }
}
