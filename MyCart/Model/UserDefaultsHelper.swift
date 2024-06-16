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
        case searchedList, likedList
    }
    
    var currentUser: String? {
        get {
            return userDefaults.string(forKey: Key.currentUser.rawValue) ?? "-"
        }
        set {
            userDefaults.setValue(newValue, forKey: Key.currentUser.rawValue)
        }
    }
    
    // 모든 유저들의 최근 검색 기록 리스트 키를 담는 딕셔너리
    var searchedListKeys: [String:String] {
        get {
            return userDefaults.dictionary(forKey: Key.searchedList.rawValue) as? [String:String] ?? [:]
        }
        set {
            userDefaults.set(newValue, forKey: Key.searchedList.rawValue)
        }
    }
    
    // 모든 유저들의 좋아요 리스트 키를 담는 딕셔너리
    var likedListKeys: [String:String] {
        get {
            return userDefaults.dictionary(forKey: Key.likedList.rawValue) as? [String:String] ?? [:]
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
        
        
        let userId = newUser.userId
        var searchedListKeys = UserDefaultsHelper.standard.searchedListKeys
        var likedListKeys = UserDefaultsHelper.standard.likedListKeys
        
        searchedListKeys[userId] = Key.searchedList.rawValue + " | " + userId
        likedListKeys[userId] = Key.likedList.rawValue + " | " + userId
        
        print(#function, searchedListKeys)
        print(#function, likedListKeys)
        
        UserDefaults.standard.removeObject(forKey: Key.searchedList.rawValue)
        UserDefaults.standard.removeObject(forKey: Key.likedList.rawValue)
        UserDefaultsHelper.standard.searchedListKeys = searchedListKeys
        UserDefaultsHelper.standard.likedListKeys = likedListKeys
        
        print(#function, UserDefaultsHelper.standard.searchedListKeys)
        print(#function, UserDefaultsHelper.standard.likedListKeys)
        
        setSearchedList(userId, [])
        setLikedList(userId, [])
    }
    
    static func deleteUser(userId: String)  {
        print(#function, userId)
        var searchedListKeys = UserDefaultsHelper.standard.searchedListKeys
        var likedListKeys = UserDefaultsHelper.standard.likedListKeys
        
        guard let mySearchKey = getSearchedListkey(userId) else {return}
        guard let myLikeKey = getLikedListKey(userId) else {return}
        
        print(#function, mySearchKey)
        print(#function, myLikeKey)
        
        UserDefaults.standard.removeObject(forKey: mySearchKey)
        UserDefaults.standard.removeObject(forKey: myLikeKey)
        
        searchedListKeys.removeValue(forKey: userId)
        likedListKeys.removeValue(forKey: userId)
        
        print(#function, searchedListKeys)
        print(#function, likedListKeys)
        
        UserDefaults.standard.removeObject(forKey: Key.searchedList.rawValue)
        UserDefaults.standard.removeObject(forKey: Key.likedList.rawValue)
        UserDefaultsHelper.standard.searchedListKeys = searchedListKeys
        UserDefaultsHelper.standard.likedListKeys = likedListKeys
        
        UserDefaults.standard.removeObject(forKey: Key.currentUser.rawValue)
        print(#function, UserDefaultsHelper.standard.currentUser)
        UserDefaults.standard.removeObject(forKey: userId)
        if let savedData = UserDefaults.standard.object(forKey: userId as! String) as? Data {
            let decoder = JSONDecoder()
            if let nowUser = try? decoder.decode(User.self, from: savedData) {
                print(#function, nowUser)
            }
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
    
    static func getSearchedListkey(_ userId: String) -> String? {
        let searchedListKeys = UserDefaultsHelper.standard.searchedListKeys
        print(#function, searchedListKeys)
        return searchedListKeys[userId]
    }
    
    static func getLikedListKey(_ userId: String) -> String? {
        let likedListKeys = UserDefaultsHelper.standard.likedListKeys
        print(#function, likedListKeys)
        return likedListKeys[userId]
    }
    
    static func getSearchedList(_ userId: String) -> [String]? {
        guard let myKey = getSearchedListkey(userId) else {return []}
        return UserDefaults.standard.stringArray(forKey: myKey) ?? [] as [String]
    }
    
    static func setSearchedList(_ userId: String, _ list: [String]) {
        guard let myKey = getSearchedListkey(userId) else {return}
        UserDefaults.standard.removeObject(forKey: myKey)
        UserDefaults.standard.setValue(list, forKey: myKey)
        print(#function, getSearchedList(userId))
    }
        
    static func getLikedList(_ userId: String) -> [String]? {
        guard let myKey = getLikedListKey(userId) else {return []}
        return UserDefaults.standard.stringArray(forKey: myKey) ?? [] as [String]
    }
    
    static func setLikedList(_ userId: String, _ list: [String]) {
        guard let myKey = getLikedListKey(userId)  else {return}
        UserDefaults.standard.removeObject(forKey: myKey)
        UserDefaults.standard.setValue(list, forKey: myKey)
        print(#function, getLikedList(userId))
        
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
