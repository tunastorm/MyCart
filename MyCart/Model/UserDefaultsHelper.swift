//
//  UserDefaultHelper.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import Foundation





class UserDefaultsHelper {
    
    private init() { }
    
    static let standard = UserDefaultsHelper()
    
    let userDefaults = UserDefaults.standard
    
    enum Key: String {
        case userIdKeyMapper
        case searchedList, likedList // 기본 키값 + User_index로 키 지정
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
    
    static func signIn(_ mappingKey: String) -> User? {
        // mappingKey : userIdKey 쌍 조회, 없으면 return nil
        var userIdKeyMapper = UserDefaults.standard.dictionary(forKey: Key.userIdKeyMapper.rawValue) ?? [:]
        guard let userIdKey = userIdKeyMapper[mappingKey] else {return nil}
        
        // userIdKey 조회 성공 시 userIdKey : User 쌍 조회, 없으면 return nil
        if let savedData = UserDefaults.standard.object(forKey: userIdKey as! String) as? Data {
            let decoder = JSONDecoder()
            if let nowUser = try? decoder.decode(User.self, from: savedData) {
                return nowUser
            }
        }
        return nil
    }
    
    static func signUp(_ newUser: User, mappingKey: String) {
        // mappingKey : userIdKey 쌍 조회
        var userIdKeyMapper = UserDefaults.standard.dictionary(forKey: Key.userIdKeyMapper.rawValue) ?? [:]
        var userIdKey = ""
        
        while (userIdKey.count != 10) {
            let newUserIdKey = mappingKey.createRandomStr(length: 10)
            userIdKey = newUserIdKey
            for mappingKey in userIdKeyMapper.keys {
                if userIdKeyMapper[mappingKey] as! String == newUserIdKey {
                   userIdKey = ""
                   break
                }
            }
        }
        
        // mappingKey : userIdKey 쌍 딕셔너리 저장
        userIdKeyMapper[mappingKey] = userIdKey
        UserDefaults.standard.setValue(userIdKeyMapper , forKey: Key.userIdKeyMapper.rawValue)
        
        // userIdKey : User 구조체 쌍 저장
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
