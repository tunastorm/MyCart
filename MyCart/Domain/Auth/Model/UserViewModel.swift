//
//  UserViewModel.swift
//  MyCart
//
//  Created by 유철원 on 7/9/24.
//

import Foundation
import RealmSwift


final class UserViewModel {
    
    var outputUser: Observable<User?> = Observable(nil)
    
    var inputAddUser: Observable<User?> = Observable(nil)
    var inputGetUser: Observable<Void?> = Observable(nil)
    var inputDeleteUser: Observable<Void?> = Observable(nil)
    var inputUpdateUser: Observable<User?> = Observable(nil)
    
    private let repository = Repository()
    private let object = User.self
    
    init () {
        repository.detectRealmURL()
        inputAddUser.bind { _ in
            self.addUser()
        }
        
        inputGetUser.bind { _ in
            self.getUser()
        }
        
        inputDeleteUser.bind { _ in
            self.deleteUser()
        }
        
        inputUpdateUser.bind { _ in
            self.updateUser()
        }
    }
    
    private func addUser() {
        
    }
    
    private func getUser() {
        outputUser.value = repository.fetchAll(obejct: object, sortKey: User.Column.signUpdate).first
        print(#function, outputUser.value)
    }
    
    private func deleteUser() {
        
    }
    
    private func updateUser() {
        
    }
    
    
}
