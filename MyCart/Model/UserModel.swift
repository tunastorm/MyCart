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
    
    private var nowUser = User(userId: "-", signInid: "guest", password: "-")
        
    func signUp() {
        
    }
    
    func signIn() {
        
    }
}


struct User: Codable {
    let userId: String
    let signInid : String
    var password: String
}





