//
//  SearchedWord.swift
//  MyCart
//
//  Created by 유철원 on 7/9/24.
//

import Foundation
import RealmSwift


class SearchedWord: Object {
    @Persisted var word: String
    @Persisted var regDate: Date
    
    @Persisted(originProperty: User.Column.searchedList.name) var main: LinkingObjects<User>
    
    convenience init(word: String, regDate: Date) {
        self.init()
        self.word = word
        self.regDate = regDate
    }
}
