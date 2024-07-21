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
        inputUpdateUserTrigger.bind { [weak self] _ in
            self?.getUser()
        }
        inputDeleteSearchedWord.bind { [weak self] _ in
            self?.deleteSearchedWord()
        }
        inputTruncateSearchedListTrigger.bind { [weak self] _ in
            self?.truncateSearchedList()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(getUser), name: NSNotification.Name("searchedWordListChanged"), object: nil)
    }
    
    @objc private func getUser() {
        self.user = repository.fetchAll(obejct: object, sortKey: User.Column.signUpDate).first
        guard let user else { return }
        outputUser.value = user
        if let nickname = outputUser.value?.nickname, outputTitle.value != nickname {
            outputTitle.value = nickname + Resource.Text.mainViewTitle
        }
        if let searchedList = outputUser.value?.searchedList.reversed(),
           outputSearchedList.value.count == 0 || outputSearchedList.value.first != searchedList.first || outputSearchedList.value.count != searchedList.count {
            outputSearchedList.value = Array(searchedList)
        }
    }

    private func deleteSearchedWord() {
        guard let index = inputDeleteSearchedWord.value else {
            return
        }
        let searchedword = outputSearchedList.value[index]
        repository.deleteItem(searchedword) { [weak self] result in
            switch result {
            case .success(let status):
                self?.outputDeleteSearchedWordResult.value = status
                self?.getUser()
            case .failure(let error):
                self?.outputDeleteSearchedWordResult.value = error
            }
        }
    }
    
    private func truncateSearchedList() {
        repository.queryProperty { [weak self] in
            self?.outputUser.value?.searchedList.removeAll()
        } completionHandler: { [weak self] result in
            switch result {
            case .success(let status):
                self?.outputTruncateSearchedListResult.value = status
                self?.getUser()
            case .failure(let error):
                self?.outputTruncateSearchedListResult.value = error
            }
        }
    }
}
