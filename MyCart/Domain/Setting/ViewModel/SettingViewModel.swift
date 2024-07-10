//
//  SettingViewModel.swift
//  MyCart
//
//  Created by 유철원 on 7/10/24.
//

import Foundation

class SettingViewModel {
    
    let repository = Repository()
    let object = User.self

    var inputGetUser: Observable<Void?> = Observable(nil)
    var inputGetLikedList: Observable<Void?> = Observable(nil)
    var inputDeleteUser: Observable<User?> = Observable(nil)
    
    var outputUser: Observable<User?> = Observable(nil)
    var outputLikedList: Observable<[LikedItem]?> = Observable(nil)
    var outputLikedListCount: Observable<Int?> = Observable(nil)
    var outputDeleteUserResult: Observable<RepositoryResult> = Observable(RepositoryError.deleteFailed)
    
    init() {
        inputGetUser.bind { _ in
            self.getUser()
        }
        inputGetLikedList.bind { _ in
            self.getLikedList()
        }
        inputDeleteUser.bind { _ in
            self.deleteUser()
        }
    }

    private func getUser() {
        outputUser.value = repository.fetchAll(obejct: object, sortKey: User.Column.signUpDate).first
    }
    
    private func getLikedList() {
        guard let list = outputUser.value?.likedList else {
            return
        }
        outputLikedList.value = Array(list)
        outputLikedListCount.value = outputLikedList.value?.count ?? 0
    }
    
    private func deleteUser() {
        guard let user = inputDeleteUser.value else {
            return
        }
        repository.deleteItem(user) { status, error in
            guard error == nil, let status else {
                outputDeleteUserResult.value = error!
                return
            }
            outputDeleteUserResult.value = status
        }
    }
}
