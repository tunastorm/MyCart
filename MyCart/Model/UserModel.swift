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
    
    private var user = User(userId: Resource.Text.guestUser, signInid: "-", password: "-")
        
    var nowUser: User {
        get {
            return user
        }
        set {
            user = newValue
        }
    }
    
    func signUp(_ newUser: User) {
        let mappingKey = newUser.userId + newUser.password
        if let oldUser = UserDefaultsHelper.signIn(mappingKey) {
            return
        } else {
            UserDefaultsHelper.signUp(newUser, mappingKey: mappingKey)
        }
    }
        
    func signIn(signInId: String, password: String) {
        let mappingKey = signInId + password
    }
}


struct User: Codable {
    let userId: String
    let signInid : String
    var password: String
}





