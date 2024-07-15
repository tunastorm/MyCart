//
//  LikedItemViewModel.swift
//  MyCart
//
//  Created by 유철원 on 7/11/24.
//

import Foundation
import RealmSwift


final class LikedItemViewModel: BaseViewModel {
    
    var inputFatchLikedItemList: Observable<Void?> = Observable(nil)
    var inputConvertShopItem: Observable<Int?> = Observable(nil)
    var inputDeleteLikedItem: Observable<String?> = Observable(nil)
    var inputDeleteLikedItemInDetail: Observable<String?> = Observable(nil)
    var inputCategoryButtonTrigger: Observable<Int?> = Observable(nil)
    
    var outputTotal: Observable<String?> = Observable(nil)
    var outputLikedList: Observable<[LikedItem]> = Observable([])
    var outputCategoryList: Observable<[String]> = Observable([])
    var outputClickedCategory: Observable<Int?> = Observable(nil)
    var outputShopItem: Observable<(Int,ShopItem)?> = Observable(nil)
    var outputLikedListResult: Observable<RepositoryResult?> = Observable(nil)
    var outputPopDetaileView: Observable<Void?> = Observable(nil)
    
    private var categoryQuery = { (searchText: String) in
        let categoryList: [LikedItem.Column] = [.category1, .category2, .category3, .category4]
        var filterArray: [NSPredicate] = []
        for item in categoryList {
            if categoryList.contains(item) {
                let predicate = "\(item.rawValue) CONTAINS[c] '\(searchText)'"
                print(#function, "predicate: ", predicate)
                filterArray.append(NSPredicate(format:predicate))
            }
        }
        return NSCompoundPredicate(type: .or, subpredicates: filterArray)
    }
    
    override func transform() {
        inputFatchLikedItemList.bind { _ in
            self.fetchLikedList()
        }
        inputCategoryButtonTrigger.bind { _ in
            self.filterLikedList()
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
            outputTotal.value = outputLikedList.value.count.formatted(.number) + Resource.Text.myCartTotal
        }
        print(#function, "카테고리 리스트", outputCategoryList.value)
        fetchCategoryFilter()
    }
    
    private func fetchCategoryFilter() {
        var categoryVector = [Set<String>(),Set<String>(), Set<String>(), Set<String>()]
        outputLikedList.value.forEach() { item in
            categoryVector[0].insert(item.category1)
            categoryVector[1].insert(item.category2)
            categoryVector[2].insert(item.category3)
            categoryVector[3].insert(item.category4)
        }
        var flatten: [String] = []
        categoryVector.forEach { set in
            set.forEach { $0.isEmpty ? print("") : flatten.append($0) }
        }
        outputCategoryList.value = flatten
    }
    
    private func filterLikedList() {
        guard let user, let index = inputCategoryButtonTrigger.value else {
            return
        }
        let compundedFilter = categoryQuery(outputCategoryList.value[index])
        repository.queryProperty {
            outputLikedList.value = Array(user.likedList.filter(compundedFilter))
        } completionHandler: { status, error in
            guard error == nil, let status else {
                // 검색결과 없다 등 에러처리
                return
            }
            let category = outputCategoryList.value.remove(at: index)
            outputCategoryList.value.insert(category, at: 0)
            outputClickedCategory.value = 0
        }
    }
    
    private func deleteLikedItem(inDetailView: Bool = false) {
        guard let productId = inDetailView ? inputDeleteLikedItemInDetail.value : inputDeleteLikedItem.value else {
            return
        }
        repository.queryProperty {
            if let item = user?.likedList.where({ $0.productId == productId }) {
                user?.likedList.realm?.delete(item)
            }
        } completionHandler: { [weak self] status, error in
            guard error == nil, let status else {
                self?.outputLikedListResult.value = error!
                return
            }
            if inDetailView {
                print(#function, "펑!!!!")
                self?.outputPopDetaileView.value = ()
            }
            self?.fetchLikedList()
            self?.outputLikedListResult.value = status
            NotificationCenter.default.post(name: NSNotification.Name("removeLikedItemInMyCart"), object: nil, userInfo: ["productId": productId])
        }
    }
    
    private func convertShopItem() {
        guard let row = inputConvertShopItem.value else {
            return
        }
        let item = outputLikedList.value[row]
        let shopItem = ShopItem(productId: item.productId, link: item.link, image: item.image, mallName: item.mallName, title: item.title, lprice: item.lprice, category1: item.category1, category2: item.category2, category3: item.category3, category4: item.category4)
        outputShopItem.value = (row, shopItem)
    }
}
