//
//  BaseViewModel.swift
//  MyCart
//
//  Created by 유철원 on 7/10/24.
//

import Foundation


class BaseViewModel {
    
    let repository = Repository()
    let object = User.self
    
    var user: User?
    
    init() {
        repository.detectRealmURL()
        if user == nil {
            user = repository.fetchAll(obejct: object, sortKey: User.Column.signUpDate).first
        }
        transform()
    }
    
    func transform() {
        
    }
}
