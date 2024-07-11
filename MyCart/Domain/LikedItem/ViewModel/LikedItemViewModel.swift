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
    var inputConvertShopItem: Observable<Int?> = Observable(nil)
    var inputDeleteLikedItem: Observable<String?> = Observable(nil)
    var inputDeleteLikedItemInDetail: Observable<String?> = Observable(nil)
    
    var outputTotal: Observable<String?> = Observable(nil)
    var outputLikedList: Observable<[LikedItem]> = Observable([])
    var outputShopItem: Observable<(Int,ShopItem)?> = Observable(nil)
    var outputLikedListResult: Observable<RepositoryResult?> = Observable(nil)
    var outputPopDetaileView: Observable<Void?> = Observable(nil)
    
    var user: User?
    
    override func transform() {
        inputFatchLikedItemList.bind { _ in
            self.fetchLikedList()
        }
        inputConvertShopItem.bind { _ in
            self.convertShopItem()
        }
        inputDeleteLikedItem.bind { _ in
            self.deleteLikedItem()
        }
        inputDeleteLikedItemInDetail.bind { _ in
            self.deleteLikedItem(inDetailView: true)
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
            print(#function, "수정된 아웃풋 ", outputLikedList.value.count)
//            outputTotal.value = outputLikedList.value.count.formatted(.number) + Resource.Text.myCartTotal
        }
    }
    
    private func deleteLikedItem(inDetailView: Bool = false) {
        guard let productId = inDetailView ? inputDeleteLikedItemInDetail.value : inputDeleteLikedItem.value else {
            return
        }
        repository.updateProperty {
            if let item = user?.likedList.where({ $0.productId == productId }) {
                user?.likedList.realm?.delete(item)
            }
        } completionHandler: { status, error in
            guard error == nil, let status else {
                outputLikedListResult.value = error!
                return
            }
            if inDetailView {
                print(#function, "펑!!!!")
                outputPopDetaileView.value = ()
            }
            self.fetchLikedList()
            outputLikedListResult.value = status
        }
    }
    
    private func convertShopItem() {
        guard let row = inputConvertShopItem.value else {
            return
        }
        let item = outputLikedList.value[row]
        let shopItem = ShopItem(productId: item.productId, link: item.link, image: item.image, mallName: item.mallName, title: item.title, lprice: item.lprice)
        outputShopItem.value = (row, shopItem)
    }
}
