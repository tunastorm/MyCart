//
//  LikedItemViewModel.swift
//  MyCart
//
//  Created by 유철원 on 7/11/24.
//

import Foundation
import RealmSwift


final class LikedItemViewModel: BaseViewModel {
    
    typealias CategoryDict = [String:Int]
    
    var inputFetchLikedItemList: Observable<Void?> = Observable(nil)
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
    
    private var categoryQuery = { (searchText: String, condition: QueryCondition) in
        let categoryList: [LikedItem.Column] = [.category1, .category2, .category3, .category4]
        var filterArray: [NSPredicate] = []
        for item in categoryList {
            let predicate = "\(item.rawValue) \(condition.value) '\(searchText)'"
            filterArray.append(NSPredicate(format:predicate))
//            if categoryList.contains(item) {
//                let predicate = "\(item.rawValue) CONTAINS[c] '\(searchText)'"
//                filterArray.append(NSPredicate(format:predicate))
//            }
        }
        return NSCompoundPredicate(type: .or, subpredicates: filterArray)
    }
    
    private var categoryVector: [CategoryDict]?
    
    override func transform() {
        inputFetchLikedItemList.bind { [weak self] _ in
            self?.fetchLikedList()
        }
        inputCategoryButtonTrigger.bind { [weak self] _ in
            self?.filterLikedList()
        }
        inputConvertShopItem.bind { [weak self] _ in
            self?.convertShopItem()
        }
        inputDeleteLikedItem.bind { [weak self] _ in
            self?.deleteLikedItem()
        }
        inputDeleteLikedItemInDetail.bind { [weak self] _ in
            self?.deleteLikedItem(inDetailView: true)
        }
    }
    
    private func fetchLikedList(isDelete: Bool = false) {
        guard let user = repository.fetchAll(obejct: object, sortKey: User.Column.signUpDate).first else {
            return
        }
        self.user = user
        if outputLikedList.value.count != user.likedList.count {
            outputLikedList.value = Array(user.likedList)
            outputTotal.value = outputLikedList.value.count.formatted(.number) + Resource.Text.myCartTotal
        }
        fetchCategoryFilter(isDelete)
    }
    
    private func fetchCategoryFilter(_ isDelete: Bool) {
        if var categoryVector, isDelete {
            deleteCategory(outputClickedCategory.value)
        } else {
            setCatetgoryVector()
        }
    }
    
    private func setCatetgoryVector() {
        self.categoryVector = [[:], [:], [:], [:]]
        let categoryProperties = LikedItem.Column.allCases[8...11].reversed()
        outputLikedList.value.forEach() { item in
            var isStored = false // item.category4 ~ 1까지 중 최하단의 카테고리 1개만 저장 후 나머지는 캔슬
            categoryProperties.enumerated().forEach { [weak self] index, property in
                let dictIndex = (categoryProperties.count - 1) - index
                if !isStored, let category = item.value(forKey: property.name) as? String, !category.isEmpty {
                    guard var categoryDict = self?.categoryVector?[dictIndex] else { return }
                    self?.categoryVector?[dictIndex] = self?.setCategoryDict(categoryDict, category) ?? [:]
                    isStored = true
                }
            }
        }
        setOutputCategorList()
        outputClickedCategory.value = 0
    }
    
    private func setCategoryDict(_ categoryDict: CategoryDict?, _ category: String) -> CategoryDict {
        guard var newDict = categoryDict else {
            return [:]
        }
        if let oldCount = newDict[category]{
            let newCount = oldCount + 1
            newDict.updateValue(newCount, forKey: category)
        } else {
            newDict[category] = 1
        }
        return newDict
    }
    
    private func setOutputCategorList() {
        var flatten = ["전체"]
        categoryVector?.enumerated().forEach { index, dict in
            dict.keys.forEach{flatten.append($0) }
        }
        outputCategoryList.value = flatten
    }
    
    private func deleteCategory(_ clickedIndex: Int?) {
        guard let clickedIndex, let vectorCount = categoryVector?.count else {
            return
        }
        let category = outputCategoryList.value[clickedIndex]
        (0 ..< vectorCount).forEach { [weak self] index in
            guard let oldCount = (self?.categoryVector?[index][category]) else {
                return
            }
            let newCount = oldCount - 1
            if newCount > 0 {
                self?.categoryVector?[index].updateValue(newCount, forKey:category)
            } else {
                self?.categoryVector?[index].removeValue(forKey: category)
                self?.setOutputCategorList()
                self?.outputClickedCategory.value = 0
            }
        }
    }
    
    private func filterLikedList() {
        guard let index = inputCategoryButtonTrigger.value else {
            return
        }
        if outputCategoryList.value[index] == "전체" {
            fetchLikedList()
            return
        }
        filterByCategory(index)
    }
    
    private func filterByCategory( _ index: Int, isDelete: Bool = false) {
        let compundedFilter = categoryQuery(outputCategoryList.value[index], QueryCondition.equals)
        var list: [LikedItem]?
        repository.queryProperty { [weak self] in
            guard let result = self?.user?.likedList.filter(compundedFilter) else {
                return
            }
            list = Array(result)
        } completionHandler: { [weak self] result in
            switch result {
            case .success(let status):
                self?.filetByCategoryComplition(list, index, isDelete)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func filetByCategoryComplition(_ list: [LikedItem]?, _ index: Int, _ isDelete: Bool) {
        guard let list else { return }
        outputLikedList.value = list
        outputTotal.value = list.count.formatted(.number) + Resource.Text.myCartTotal
        if isDelete {
            fetchCategoryFilter(isDelete)
        } else {
            let category = outputCategoryList.value.remove(at: index)
            outputCategoryList.value.insert(category, at: 1)
        }
        outputClickedCategory.value = 1
    }
    
    private func deleteLikedItem(inDetailView: Bool = false) {
        guard let productId = inDetailView ? inputDeleteLikedItemInDetail.value : inputDeleteLikedItem.value else {
            return
        }
        repository.queryProperty {
            if let item = user?.likedList.where({ $0.productId == productId }) {
                user?.likedList.realm?.delete(item)
            }
        } completionHandler: { [weak self] result in
            switch result{
            case .success(let status):
                self?.deleteComplition(inDetailView, status, productId)
            case .failure(let error):
                self?.outputLikedListResult.value = error
            }
        }
    }
    
    private func deleteComplition(_ inDetailView: Bool, _ status: RepositoryStatus, _ productId: String) {
        guard let clickedIndex = outputClickedCategory.value else {
            return
        }
        if inDetailView {
            outputPopDetaileView.value = ()
        }
        let category = outputCategoryList.value[clickedIndex]
        var itemCount = 1
        categoryVector?.forEach{ categoryDict in
            if categoryDict.keys.contains(category) {
                itemCount = categoryDict[category] ?? 0
            }
        }
        if category == "전체" || itemCount <= 1 {
            fetchLikedList()
        } else {
            filterByCategory(clickedIndex, isDelete: true)
            
        }
        outputLikedListResult.value = status
        NotificationCenter.default.post(name: NSNotification.Name("removeLikedItemInMyCart"), object: nil, userInfo: ["productId": productId])
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
