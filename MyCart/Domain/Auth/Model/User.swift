//
//  User.swift
//  MyCart
//
//  Created by 유철원 on 7/1/24.
//

import Foundation


struct User: Codable {
    let userId: String
    var nickName : String
    var profileImage: String
    let signUpDate: Date
}
