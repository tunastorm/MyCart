//
//  LikedItemViewModel.swift
//  MyCart
//
//  Created by 유철원 on 7/11/24.
//

import Foundation
import RealmSwift


class LikedItemViewModel: BaseViewModel {
    
    var inputFatchLikedItemList: Observable<Void?> = Observable(nil)
    
    var outputTotal: Observable<String?> = Observable(nil)
    var outputLikedList: Observable<[LikedItem]> = Observable([])
    var outputLikedListResult: Observable<RepositoryResult?> = Observable(nil)
    
    var user: User?
    
    override func transform() {
        inputFatchLikedItemList.bind { _ in
            self.fetchLikedList()
        }
    }
    
    private func fetchLikedList() {
        guard let user = repository.fetchAll(obejct: object, sortKey: User.Column.signUpDate).first else {
            return
        }
        self.user = user
        print(#function, "아웃풋", outputLikedList.value.count, "현재", user.likedList.count)
        if outputLikedList.value.count != user.likedList.count {
            outputLikedList.value = Array(user.likedList)
            outputTotal.value = outputLikedList.value.count.formatted(.number) + Resource.Text.myCartTotal
        }
    }
    
    private func deleteLikedItem(_ id: ObjectId) {
        repository.updateProperty {
            if let item = user?.likedList.where({ $0.id == id }) {
                user?.likedList.realm?.delete(item)
            }
        } completionHandler: { status, error in
            guard error == nil, let status else {
                outputLikedListResult.value = error!
                return
            }
            self.fetchLikedList()
            outputLikedListResult.value = status
        }
    }
}
