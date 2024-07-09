//
//  SignUpViewModel.swift
//  MyCart
//
//  Created by 유철원 on 7/9/24.
//

import Foundation


class SignUpViewModel {
    
    var inputNickName: Observable<String?> = Observable(nil)
    var inputValidate: Observable<Void?> = Observable(nil)
    var inputAddUser: Observable<User?> = Observable(nil)
    var inputGetUser: Observable<Void?> = Observable(nil)
    var inputUpdateUser: Observable<[String:Any]?> = Observable(nil)
    
    var outputValidateMessage: Observable<String?> = Observable(nil)
    var outputValidateResult: Observable<(Bool,String?)> = Observable((false,nil))
    var outputAddUserResult: Observable<RepositoryResult> = Observable(RepositoryError.createFailed)
    var outputUpdateUserResult: Observable<RepositoryResult> = Observable(RepositoryError.updatedFailed)
    var outputUser: Observable<User?> = Observable(nil)
    
    private let repository = Repository()
    private let object = User.self
    private var validateResult: (Bool,String)?
    
    init() {
        inputNickName.bind { _  in
            self.validation()
        }
        inputValidate.bind { _ in
            self.sendValidateResult()
        }
        inputAddUser.bind { _ in
            print(#function, "유저등록")
            self.addUser()
        }
        inputGetUser.bind { _ in
            self.getUser()
        }
    }
    
    private func validation(){
        guard let inputText = inputNickName.value else {
            outputValidateMessage.value = nil
            return
        }
        guard let nickname = Utils.textFilter.removeSerialSpace(inputText), inputText.count - nickname.count <= 1 else {
            outputValidateMessage.value = TextinputFilterError.haveSpace.nickNameMessage
            return
        }
        if let error = Utils.textFilter.filterCount(inputText) {
            outputValidateMessage.value = error.nickNameMessage
            return
        }
        if let error = Utils.textFilter.filterSpecial(inputText) {
            outputValidateMessage.value = error.nickNameMessage
            return
        }
        if let error = Utils.textFilter.filterNumber(inputText) {
            outputValidateMessage.value = error.nickNameMessage
            return
        }
        print(#function, "연속공백 제거 후: ", nickname)
        outputValidateMessage.value = Resource.Text.nickNameSuccess
        validateResult = (true, nickname)
    }
    
    private func sendValidateResult() {
        guard let validateResult else {
            return
        }
        print(#function, "유효성 검사 통과: ", validateResult)
        outputValidateResult.value = validateResult
    }
    
    private func addUser() {
        print(#function)
        guard let user = inputAddUser.value else {
            return
        }
        print(#function, user)
        repository.createItem(user) { status, error in
            guard error == nil, let status else {
                outputAddUserResult.value = error!
                return
            }
            outputAddUserResult.value = status
        }
    }
    
    private func getUser() {
        outputUser.value = repository.fetchAll(obejct: object, sortKey: User.Column.signUpdate).first
    }
    
    private func updateUser() {
        guard let updateValue = inputUpdateUser.value else {
            return
        }
        repository.updateItem(object: object, value: updateValue) { status, error in
            guard error == nil, let status else {
                outputUpdateUserResult.value = error!
                return
            }
            outputUpdateUserResult.value = status
        }
    }
}
