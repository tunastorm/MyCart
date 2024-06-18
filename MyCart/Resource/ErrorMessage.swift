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
        case nickNameHaveSpace
        case nickNameNoSpecial
        case nickNameNoNumber
        case nickNameCountOver
        
        var message: String {
            switch self {
            case .nickNameHaveSpace:
                return "닉네임의 공백은 띄어쓰기 1회만 사용가능합니다"
            case .nickNameNoSpecial:
                return "닉네임에 @, #, $, %는 포함할 수 없어요"
            case .nickNameNoNumber:
                return "닉네임에 숫자는 포함할 수 없어요"
            case .nickNameCountOver:
                return "2글자 이상 10글자 미만으로 설정해주세요"
            }
        }
    }
}
