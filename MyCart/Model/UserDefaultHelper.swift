//
//  UserDefaultHelper.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import Foundation


class UserDefaultHelper {
    
    private init() { }
    
    static let standard = UserDefaultHelper()
    
    let userDefaults = UserDefaults.standard
    
    enum Key: String {
        case searchedList, likedList
    }
    
    var searchedList: [String] {
        get {
            return userDefaults.array(forKey: Key.searchedList.rawValue) as? [String] ?? []
        }
        set {
            userDefaults.set(newValue, forKey: Key.searchedList.rawValue)
        }
    }
    
    var likedList: [String] {
        get {
            return userDefaults.array(forKey: Key.likedList.rawValue) as? [String] ?? []
        }
        set {
            userDefaults.set(newValue, forKey: Key.likedList.rawValue)
        }
    }
}
