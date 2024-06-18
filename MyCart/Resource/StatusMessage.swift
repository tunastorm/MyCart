//
//  ErrorMessage.swift
//  MyCart
//
//  Created by 유철원 on 6/18/24.
//

import Foundation


enum StatusMessage: Error {
    
    enum APIError: Error {
        
        case requestAPIFailed
        case productURLNotExist
        case productConnectionFailed
        
        var message: String {
            switch self {
            case .requestAPIFailed:
                return "[서버 연결 실패]\n네트워크 상태를 확인하세요"
            case .productURLNotExist:
                return "앗... 이 상품의 링크가 사라졌어요"
            case .productConnectionFailed:
                return "앗... 상품 페이지 연결에 실패했어요"
            }
        }
    }
    
    enum APIStatus {
        case loading
    }
    
    enum NickNameFilterError: Error {
        case haveSpace
        case haveSpecial
        case haveNumber
        case countOver
        
        var message: String {
            switch self {
            case .haveSpace:
                return "닉네임의 공백은 띄어쓰기 1회만 사용가능합니다"
            case .haveSpecial:
                return "닉네임에 @, #, $, %는 포함할 수 없어요"
            case .haveNumber:
                return "닉네임에 숫자는 포함할 수 없어요"
            case .countOver:
                return "2글자 이상 10글자 미만으로 설정해주세요"
            }
        }
    }
}
