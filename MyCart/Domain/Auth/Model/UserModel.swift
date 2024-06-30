//
//  UserModel.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import Foundation


class UserModel {
    
    private init() {}
    
    static let shared = UserModel()
    
    private var user = User(userId: Resource.Text.guestUser, nickName: "-", profileImage: "-", signUpDate:  Date())
    
    private var currentUser = UserDefaultsHelper.standard.currentUser
    
    var nowUser: User {
        get {
            return user
        }
        set {
            user = newValue
        }
    }
    
    var mappingKey: String? {
        return currentUser
    }
    
    func signUp(_ nickName: String, profileImage: String) {
        let mappingKey = nickName + profileImage
        if let oldUser = UserDefaultsHelper.signIn(mappingKey) {
            return
        } else {
            guard let userId = UserDefaultsHelper.makeUserIdKey(mappingKey: mappingKey) else {return}
            let newUser = User(userId: userId, nickName: nickName, profileImage: profileImage, signUpDate: Date())
            UserDefaultsHelper.signUp(newUser)
            currentUser = mappingKey
            signIn()
        }
    }
        
    func signIn() {
        if let currentUser, let user = UserDefaultsHelper.signIn(currentUser) {
            self.nowUser = user
        }
    }
    
    func updateUser(_ newMappingKey: String, _ nickName: String, _ profile: String) {
        var newUser = nowUser
        newUser.nickName = nickName
        newUser.profileImage = profile
        
        guard let oldKey = mappingKey else {return}
        UserDefaultsHelper.updateUser(oldKey, newMappingKey, newUser)
        currentUser = newMappingKey
    }
    
    func deleteUser() {
        UserDefaultsHelper.deleteUser(userId: user.userId)
        self.currentUser = "-"
        self.nowUser = User(userId: Resource.Text.guestUser, nickName: "-", profileImage: "-", signUpDate: Date())
    }
    
    func getSearchedList() -> [String] {
        return UserDefaultsHelper.getSearchedList(user.userId) ?? []
    }
    
    func setSearchedList(newWord: String?) {
        var searchedList: [String]
        if newWord == nil {
            searchedList = []
        } else if let newWord {
            searchedList = getSearchedList()
            searchedList.insert(newWord, at: 0)
        }
        UserDefaultsHelper.setSearchedList(user.userId, searchedList)
    }
    
    func deleteSearchedWord(deleteWord: String) {
        guard let oldList = UserDefaultsHelper.getSearchedList(user.userId),
              let index = oldList.firstIndex(of: deleteWord) else {return}
        var newList = oldList
        newList.remove(at: index)
        UserDefaultsHelper.setSearchedList(user.userId, newList)
    }
    
    func getLikedList() -> [String] {
        return UserDefaultsHelper.getLikedList(user.userId) ?? []
    }
    
    func setLikedList(list: [String]) {
        UserDefaultsHelper.setLikedList(user.userId, list)
    }
}


struct User: Codable {
    let userId: String
    var nickName : String
    var profileImage: String
    let signUpDate: Date
}





