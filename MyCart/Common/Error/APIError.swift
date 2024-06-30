//
//  APIError.swift
//  MyCart
//
//  Created by 유철원 on 6/30/24.
//

import Foundation


enum APIError {
    case unExpectedError
    case noResultError
    case networkError
    case redirectError
    case clientError
    case serverError
    
    var title: String {
        switch self {
        case .unExpectedError:
            return "[ 비정상적인 에러 ]"
        case .noResultError:
            return "[ 검색 결과 없음 ]"
        case .networkError:
            return "[ 네트워크 에러 ]"
        case .redirectError:
            return "[ 리소스 경로 변경 ]"
        case .clientError:
            return "[ 잘못된 요청 ]"
        case .serverError:
            return "[ 서비스 상태 불량 ]"
        }
    }
    
    var message: String {
        switch self {
        case .unExpectedError:
            return "알 수 없는 에러가 발생하였습니다. 고객센터로 문의하세요."
        case .noResultError:
            return "검색어에 해당하는 결과가 없습니다."
        case .networkError:
            return "네트워크 연결상태를 확인하세요."
        case .redirectError:
            return "요청한 리소스의 주소가 변경되었습니다. 올바른 주소로 다시 요청해주세요."
        case .clientError:
            return "잘못된 요청이거나 접근권한이 없습니다."
        case .serverError:
            return "문제상황을 확인하고 조치중입니다. 잠시 기다려주세요."
        }
    }
    
    func showToast() {
        switch self {
        case .networkError:
            let image = Resource.SystemImage.wifiExclamationmark
            makeToastWithImage(message: self.message, duration: 3.0, position: .bottom, title: self.title, image: image)
        default: makeBasicToast(message: self.message, duration: 3.0, position: .bottom, title: self.title)
        }
    }
}
