//
//  SettingViewModel.swift
//  MyCart
//
//  Created by 유철원 on 7/10/24.
//

import Foundation
import RealmSwift


class SettingViewModel {
    
    let repository = Repository()
    let object = User.self

    var inputGetUser: Observable<Void?> = Observable(nil)
    var inputGetLikedList: Observable<ObjectId?> = Observable(nil)
    var inputDeleteUser: Observable<User?> = Observable(nil)
    
    var outputUser: Observable<User?> = Observable(nil)
    var outputLikedList: Observable<List<LikedItem>?> = Observable(nil)
    var outputLikedListCount: Observable<Int?> = Observable(nil)
    var outputDeleteUserResult: Observable<RepositoryResult> = Observable(RepositoryError.deleteFailed)
    
    var likedList: List<LikedItem>?
    
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
        outputUser.value = repository.fetchAll(obejct: object, sortKey: User.Column.signUpdate).first
    }
    
    private func getLikedList() {
        guard let id = inputGetLikedList.value else {
            return
        }
        likedList = repository.fetchItem(object: object, primaryKey:id)?.likedList
        print(#function, "좋아요 목록 길이: ", likedList?.count, likedList)
        outputLikedListCount.value = likedList?.count ?? 0
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
