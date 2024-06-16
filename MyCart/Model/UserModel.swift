//
//  UserModel.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import Foundation


class UserModel {
    
    private init() {}
    
    static let model = UserModel()
    
    private var user = User(userId: Resource.Text.guestUser, nickName: "-", profileImage: "-")
    
    private var currentUser = UserDefaultsHelper.standard.currentUser
    
    var nowUser: User {
        get {
            return user
        }
        set {
            user = newValue
        }
    }
    
    func signUp(_ nickName: String, profileImage: String) {
        let mappingKey = nickName + profileImage
        if let oldUser = UserDefaultsHelper.signIn(mappingKey) {
            return
        } else {
            guard let userId = UserDefaultsHelper.makeUserIdKey(mappingKey: mappingKey) else {return}
            let newUser = User(userId: userId, nickName: nickName, profileImage: profileImage)
            UserDefaultsHelper.signUp(newUser)
            currentUser = mappingKey
            signIn()
        }
    }
        
    func signIn() {
        print(#function, self.currentUser)
        if let currentUser, let nowUser = UserDefaultsHelper.signIn(currentUser) {
            self.nowUser = nowUser
        }
    }
}


struct User: Codable {
    let userId: String
    let nickName : String
    var profileImage: String
}





