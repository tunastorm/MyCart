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
        case currentUser, userIdKeyMapper
        case searchedList, likedList // 기본 키값 + User_index로 키 지정
    }
    
    var currentUser: String? {
        get {
            return userDefaults.string(forKey: Key.currentUser.rawValue) ?? "-"
        }
        set {
            userDefaults.setValue(newValue, forKey: Key.currentUser.rawValue)
        }
    }
    
    // 모든 유저들의 최근 검색 기록 리스트 담는 리스트
    var allSearchedList: [String:[String]] {
        get {
            return userDefaults.dictionary(forKey: Key.searchedList.rawValue) as? [String:[String]] ?? [:]
        }
        set {
            userDefaults.set(newValue, forKey: Key.searchedList.rawValue)
        }
    }
    
    // 모든 유저들의 좋아요 리스트를 담는 리스트
    var allLikedList: [String:[String]] {
        get {
            return userDefaults.dictionary(forKey: Key.likedList.rawValue) as? [String:[String]] ?? [:]
        }
        set {
            userDefaults.set(newValue, forKey: Key.likedList.rawValue)
        }
    }
    
    static func signIn(_ mappingKey: String) -> User? {
        // mappingKey : userIdKey 쌍 조회, 없으면 return nil
        let userIdKeyMapper = UserDefaults.standard.dictionary(forKey: Key.userIdKeyMapper.rawValue) ?? [:]
        guard let userIdKey = userIdKeyMapper[mappingKey] else {return nil}
        
        // 최근 사용자로 저장
        UserDefaultsHelper.standard.currentUser = mappingKey
        
        // userIdKey 조회 성공 시 userIdKey : User 쌍 조회, 없으면 return nil
        if let savedData = UserDefaults.standard.object(forKey: userIdKey as! String) as? Data {
            let decoder = JSONDecoder()
            if let nowUser = try? decoder.decode(User.self, from: savedData) {
                return nowUser
            }
        }
        return nil
    }
    
    static func signUp(_ newUser: User) {
        // userIdKey : User 구조체 쌍 저장
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(newUser) {
            UserDefaults.standard.setValue(encoded, forKey: newUser.userId)
        }
    }
    
    static func makeUserIdKey(mappingKey: String)  -> String? {
        // mappingKey : userIdKey 쌍 조회
        var userIdKeyMapper = UserDefaults.standard.dictionary(forKey: Key.userIdKeyMapper.rawValue) ?? [:]
        var userIdKey = ""
        
        // 일치하는 것 없을 때까지 반복 생성
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
        
        // mappingKey : userIdKey 쌍 딕셔너리 저장 후 리턴
        userIdKeyMapper[mappingKey] = userIdKey
        UserDefaults.standard.setValue(userIdKeyMapper , forKey: Key.userIdKeyMapper.rawValue)
        let newKeyMapper = UserDefaults.standard.dictionary(forKey: Key.userIdKeyMapper.rawValue) as! [String:String]

        return newKeyMapper[mappingKey]
    }
    
    static func getSearchedList(_ userId: String) -> [String]? {
        let allSearchedList = UserDefaultsHelper.standard.allSearchedList
        return allSearchedList[userId]
    }
    
    static func setSearchedList(_ userId: String, _ list: [String]) {
        var allSearchedList = UserDefaultsHelper.standard.allSearchedList
        guard let myList = allSearchedList[userId] else {return}
        var myListCopy = myList
        myListCopy.append(contentsOf: list)
        allSearchedList[userId] = myListCopy
        UserDefaultsHelper.standard.allSearchedList = allSearchedList
    }
    
    static func getLikedList(_ userId: String) -> [String]? {
        let allLikedList = UserDefaultsHelper.standard.allLikedList
        return allLikedList[userId]
    }
    
    static func setLikedList(_ userId: String, _ list: [String]) {
        var allLikedList = UserDefaultsHelper.standard.allLikedList
        guard let myList = allLikedList[userId] else {return}
        var myListCopy = myList
        myListCopy.append(contentsOf: list)
        allLikedList[userId] = myListCopy
        UserDefaultsHelper.standard.allLikedList = allLikedList
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
