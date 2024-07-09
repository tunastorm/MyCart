//
//  UserViewModel.swift
//  MyCart
//
//  Created by 유철원 on 7/9/24.
//

import Foundation
import RealmSwift


class UserViewModel {
    var inputAddUser: Observable<User?> = Observable(nil)
    var inputGetUser: Observable<Void?> = Observable(nil)
    var inputDeleteUser: Observable<Void?> = Observable(nil)
    var inputUpdateUser: Observable<User?> = Observable(nil)
    
    init () {
        inputAddUser.bind { _ in
            
        }
        
        inputGetUser.bind { _ in
            
        }
        
        inputDeleteUser.bind { _ in
            
        }
        
        inputUpdateUser.bind { _ in
            
        }
    }
    
    func addUser() {
        
    }
    
    func getUser() {
        
    }
    
    func deleteUser() {
        
    }
    
    func updateUser() {
        
    }
    
    
}
