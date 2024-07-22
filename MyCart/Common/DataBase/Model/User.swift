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


final class User: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var nickname: String
    @Persisted var profileImage: String
    @Persisted var signUpDate: Date
    @Persisted var searchedList: List<SearchedWord>
    @Persisted var likedList: List<LikedItem>
    
    convenience init(nickname: String, profilImage: String) {
        self.init()
        self.nickname = nickname
        self.profileImage = profilImage
        self.signUpDate = Date()
    }
    
    enum Column: String, CaseIterable, ColumnManager {
        case id
        case nickname
        case profileImage
        case signUpDate
        case searchedList
        case likedList
        
        var name: String {
            return self.rawValue
        }
        
        var krName: String {
            return switch self {
            case .id:
               "아이디"
            case .nickname:
               "닉네임"
            case .profileImage:
               "프로필 이미지"
            case .signUpDate:
                "가입일"
            case .searchedList:
               "최근 검색어 목록"
            case .likedList:
                "좋아요 목록"
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


