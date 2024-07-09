//
//  SearchedWord.swift
//  MyCart
//
//  Created by 유철원 on 7/9/24.
//

import Foundation
import RealmSwift


class SearchedWord: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var word: String
    @Persisted var regDate: Date
    
    @Persisted(originProperty: User.Column.searchedList.name) var main: LinkingObjects<User>
    
    convenience init(word: String, regDate: Date) {
        self.init()
        self.word = word
        self.regDate = regDate
    }
    
    enum Column: String, ColumnManager {
        case id
        case word
        case regDate
        
        
        var name: String {
            return self.rawValue
        }
        
        var krName: String {
            return switch self {
            case .id:
                "아이디"
            case .word:
                "최근 검색어"
            case .regDate:
                "등록일"
            }
        }
        
        var inputErrorMessage: String {
            return "\(self.krName) 값이 없거나 유효하지 않습니다."
        }
        
        var updatePropertySuccessMessage: String {
            return "\(self.krName) 값의 수정이 완료되었습니다."
        }
        
        var updatePropertyErrorMessage: String {
            return "\(self.krName) 값의 수정에 실패하였습니다."
        }
    }
}
