//
//  UserViewModel.swift
//  MyCart
//
//  Created by 유철원 on 7/9/24.
//

import Foundation
import RealmSwift


final class SplashViewModel {
    
    var inputGetUser: Observable<Void?> = Observable(nil)
    var outputUser: Observable<User?> = Observable(nil)
    
    private let repository = Repository()
    private let object = User.self
    
    init () {
        repository.detectRealmURL()
        inputGetUser.bind { _ in
            self.getUser()
        }
    }

    private func getUser() {
        outputUser.value = repository.fetchAll(obejct: object, sortKey: User.Column.signUpdate).first
        print(#function, outputUser.value)
    }
}
