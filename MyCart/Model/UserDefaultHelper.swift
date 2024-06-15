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
        case userIdDB
        case searchedList, likedList // 기본 키값 + User_index로 키 지정
    }
    
    var userIdDB: [String:String] {
        get {
            return userDefaults.dictionary(forKey: Key.userIdDB.rawValue) as? [String:String] ?? [:]
        }
        set {
            userDefaults.set(newValue, forKey: Key.userIdDB.rawValue)
        }
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
    
    func signIn(userIdKey: String) -> User? {
        if let savedData = UserDefaults.standard.object(forKey: userIdKey) as? Data {
            let decoder = JSONDecoder()
            if let nowUser = try? decoder.decode(User.self, from: savedData) {
                return nowUser
            }
        }
        return nil
    }
    
    func signUp(newUser: User, userIdKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(newUser) {
            UserDefaults.standard.setValue(encoded, forKey: userIdKey)
        }
    }
   
}


//struct UserDefaultsManager {
//    
//    static var userDBKey = "userDB"
//    
//    @UserDefaultWrapper(key: userDBKey, defaultValue: nil)
//    static var userDB: [String:User]?
//
//    static func removeValue(_ key: String) {
//        UserDefaults.standard.removeObject(forKey: key)
//    }
//}
//
//
//@propertyWrapper
//struct UserDefaultWrapper<T: Codable> {
//    private let key: String
//    private let defaultValue: T?
//    
//    init(key: String, defaultValue: T?) {
//        self.key = key
//        self.defaultValue = defaultValue
//    }
//    
//    var wrappedValue: T? {
//        get {
//            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
//                let decoder = JSONDecoder()
//                if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
//                    return lodedObejct
//                }
//            }
//            return defaultValue
//        }
//        set {
//            let encoder = JSONEncoder()
//            if let encoded = try? encoder.encode(newValue) {
//                UserDefaults.standard.setValue(encoded, forKey: key)
//            }
//        }
//    }
//}
