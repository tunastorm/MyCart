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
        NotificationCenter.default.addObserver(self, selector: #selector(getUser), name: NSNotification.Name("searchedWordListChanged"), object: nil)
    }
    
    @objc private func getUser() {
        print(#function, "getUser 실행")
        self.user = repository.fetchAll(obejct: object, sortKey: User.Column.signUpDate).first
        guard let user else { return }
        outputUser.value = user
        if let nickname = outputUser.value?.nickname, outputTitle.value != nickname {
            outputTitle.value = nickname + Resource.Text.mainViewTitle
        }
        if let searchedList = outputUser.value?.searchedList.reversed(), outputSearchedList.value.first != searchedList.first {
            outputSearchedList.value = Array(searchedList)
        }
    }

    private func deleteSearchedWord() {
        guard let index = inputDeleteSearchedWord.value else {
            return
        }
        let searchedword = outputSearchedList.value[index]
        repository.deleteItem(searchedword) { [weak self] status, error in
            guard error == nil, let status else {
                self?.outputDeleteSearchedWordResult.value = error!
                return
            }
            self?.outputDeleteSearchedWordResult.value = status
            self?.getUser()
        }
    }
    
    private func truncateSearchedList() {
        repository.queryProperty { [weak self] in
            self?.outputUser.value?.searchedList.removeAll()
        } completionHandler: { [weak self] status, error in
            guard error == nil, let status else {
                self?.outputTruncateSearchedListResult.value = error!
                return
            }
            self?.outputTruncateSearchedListResult.value = status
            self?.getUser()
        }
    }
}
