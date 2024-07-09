//
//  User.swift
//  MyCart
//
//  Created by 유철원 on 7/1/24.
//

import Foundation
import RealmSwift


//struct User: Codable {
//    let userId: String
//    var nickName : String
//    var profileImage: String
//    let signUpDate: Date
//}


class User: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var nickname: String
    @Persisted var profilImage: String
    @Persisted var signUpdate: Date
    @Persisted var searchedList: List<SearchedWord>
    @Persisted var likedList: List<LikedItem>
    
    convenience init(nickname: String, profilImage: String) {
        self.init()
        self.nickname = nickname
        self.profilImage = profilImage
        self.signUpdate = Date()
    }
    
    enum Column: String, ColumnManager {
        case nickname
        case profiileImage
        case signUpdate
        case searchedList
        case likedList
        
        var name: String {
            return self.rawValue
        }
        
        var krName: String {
            switch self {
            case .nickname:
                return "닉네임"
            case .profiileImage:
                return "프로필 이미지"
            case .signUpdate:
                return "가입일"
            case .searchedList:
                return "최근 검색어 목록"
            case .likedList:
                return "좋아요 목록"
            }
        }
        
        var inputErrorMessage: String {
            return "\(self.krName) 값이 없거나 유효하지 않습니다."
        }
        
        var updatePropertySuccessMessage: String {
            return "\(self.krName) 의 수정이 완료되었습니다."
        }
        
        var updatePropertyErrorMessage: String {
            return "\(self.krName) 의 수정에 실패하였습니다."
        }
    }
}


