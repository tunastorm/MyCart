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
    
    init() {
        repository.detectRealmURL()
        transform()
    }
    
    func transform() {
        
    }
}
