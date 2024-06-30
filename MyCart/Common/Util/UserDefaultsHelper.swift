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
    
    // 모든 유저들의 최근 검색 기록 리스트 키(userId)를 담는 딕셔너리
    var searchedListKeys: [String:String] {
        get {
            return userDefaults.dictionary(forKey: Key.searchedList.rawValue) as? [String:String] ?? [:]
        }
        set {
            userDefaults.set(newValue, forKey: Key.searchedList.rawValue)
        }
    }
    
    // 모든 유저들의 좋아요 리스트 키(userId)를 담는 딕셔너리
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
        // 로그인한 유저의 매핑 키를 최근 사용자로 저장
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
        // userId 초기화 및 최근 검색기록 및 좋아요 키 딕셔너리 초기화
        let userId = newUser.userId
        var searchedListKeys = UserDefaultsHelper.standard.searchedListKeys
        var likedListKeys = UserDefaultsHelper.standard.likedListKeys
        // 가입하는 유저의 기본 "키값 + userId"로 새로운 최근검색/좋아요 리스트 키 생성 후 딕셔너리에 저장
        searchedListKeys[userId] = Key.searchedList.rawValue + " | " + userId
        likedListKeys[userId] = Key.likedList.rawValue + " | " + userId
        // 기존 최근검색/좋아요 키 딕셔너리 삭제
        UserDefaults.standard.removeObject(forKey: Key.searchedList.rawValue)
        UserDefaults.standard.removeObject(forKey: Key.likedList.rawValue)
        // 새로운 최근검색 / 좋아요 키 딕셔너리 저장
        UserDefaultsHelper.standard.searchedListKeys = searchedListKeys
        UserDefaultsHelper.standard.likedListKeys = likedListKeys
        // 새로 생성된 키 : 빈 리스트 쌍 UserDefaults에 저장
        setSearchedList(userId, [])
        setLikedList(userId, [])
    }
    
    static func updateUser(_ oldKey: String, _ newKey: String, _ newUser: User) {
        let userIdKey = newUser.userId
        // 1. 기존 유저 구조체 삭제
        UserDefaults.standard.removeObject(forKey: userIdKey)
        // 2. 기존 매핑키 : userId 쌍 삭제
        var userIdKeyMapper = UserDefaults.standard.dictionary(forKey: Key.userIdKeyMapper.rawValue) ?? [:]
        userIdKeyMapper.removeValue(forKey: oldKey)
        // 3. 새 매핑키 : userId 쌍 저장
        userIdKeyMapper[newKey] = userIdKey
        UserDefaults.standard.removeObject(forKey: Key.userIdKeyMapper.rawValue)
        UserDefaults.standard.setValue(userIdKeyMapper, forKey: Key.userIdKeyMapper.rawValue)
        // 4. 새 유저 구조체 저장
        guard let userId = userIdKeyMapper[newKey] else {return}
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(newUser) {
            UserDefaults.standard.setValue(encoded, forKey: userId as! String)
        }
    }
    
    static func deleteUser(userId: String)  {
      
        var searchedListKeys = UserDefaultsHelper.standard.searchedListKeys
        var likedListKeys = UserDefaultsHelper.standard.likedListKeys
        
        guard let mySearchKey = getSearchedListkey(userId) else {return}
        guard let myLikeKey = getLikedListKey(userId) else {return}
        
        UserDefaults.standard.removeObject(forKey: mySearchKey)
        UserDefaults.standard.removeObject(forKey: myLikeKey)
        
        searchedListKeys.removeValue(forKey: userId)
        likedListKeys.removeValue(forKey: userId)
        
        UserDefaults.standard.removeObject(forKey: Key.searchedList.rawValue)
        UserDefaults.standard.removeObject(forKey: Key.likedList.rawValue)
        UserDefaultsHelper.standard.searchedListKeys = searchedListKeys
        UserDefaultsHelper.standard.likedListKeys = likedListKeys
        
        UserDefaults.standard.removeObject(forKey: Key.currentUser.rawValue)
        UserDefaults.standard.removeObject(forKey: userId)
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
        return searchedListKeys[userId]
    }
    
    static func getLikedListKey(_ userId: String) -> String? {
        let likedListKeys = UserDefaultsHelper.standard.likedListKeys
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
    }
        
    static func getLikedList(_ userId: String) -> [String]? {
        guard let myKey = getLikedListKey(userId) else {return []}
        return UserDefaults.standard.stringArray(forKey: myKey) ?? [] as [String]
    }
    
    static func setLikedList(_ userId: String, _ list: [String]) {
        guard let myKey = getLikedListKey(userId)  else {return}
        UserDefaults.standard.removeObject(forKey: myKey)
        UserDefaults.standard.setValue(list, forKey: myKey)
    }
}
