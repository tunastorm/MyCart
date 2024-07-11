//
//  MainViewModel.swift
//  MyCart
//
//  Created by 유철원 on 7/10/24.
//

import Foundation


class MainViewModel: BaseViewModel {
        
    var inputUpdateUserTrigger: Observable<Void?> = Observable(nil)
    var inputDeleteSearchedWord: Observable<Int?> = Observable(nil)
    var inputTruncateSearchedListTrigger: Observable<Void?> = Observable(nil)
    
    var outputUser: Observable<User?> = Observable(nil)
    var outputTitle: Observable<String> = Observable("춤추는 고래밥\(Resource.Text.mainViewTitle)")
    var outputSearchedList: Observable<[SearchedWord]> = Observable([])
//    var outputLikedList: Observable<[LikedItem]> = Observable([])
    var outputDeleteSearchedWordResult: Observable<RepositoryResult> = Observable(RepositoryError.deleteFailed)
    var outputTruncateSearchedListResult: Observable<RepositoryResult> = Observable(RepositoryError.deleteFailed)
    
    override func transform() {
        inputUpdateUserTrigger.bind { _ in
            self.getUser()
        }
        inputDeleteSearchedWord.bind { _ in
            self.deleteSearchedWord()
        }
        inputTruncateSearchedListTrigger.bind { _ in
            self.truncateSearchedList()
        }
    }
    
    private func getUser() {
        outputUser.value = repository.fetchAll(obejct: object, sortKey: User.Column.signUpDate).first
        print(#function, "user: ", outputUser.value)
        if let nickname = outputUser.value?.nickname, outputTitle.value != nickname {
            print(#function, "nickname: \(nickname)")
            outputTitle.value = nickname + Resource.Text.mainViewTitle
        }
        if let searchedList = outputUser.value?.searchedList, outputSearchedList.value.count != searchedList.count {
            print(#function, "searchedList: \(searchedList.count)")
            outputSearchedList.value = Array(searchedList)
        }
    }

    private func deleteSearchedWord() {
        guard let index = inputDeleteSearchedWord.value else {
            return
        }
        let searchedword = outputSearchedList.value[index]
        repository.deleteItem(searchedword) { status, error in
            guard error == nil, let status else {
                outputDeleteSearchedWordResult.value = error!
                return
            }
            outputDeleteSearchedWordResult.value = status
            self.getUser()
        }
    }
    
    private func truncateSearchedList() {
        repository.queryProperty {
            outputUser.value?.searchedList.removeAll()
        } completionHandler: { status, error in
            guard error == nil, let status else {
                outputTruncateSearchedListResult.value = error!
                return
            }
            outputTruncateSearchedListResult.value = status
            self.getUser()
        }
    }
}
