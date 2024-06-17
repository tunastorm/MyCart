//
//  OnBoadingViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

class AuthViewController: UIViewController {

    private var model: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configModel()
        print(#function, model?.nowUser)
        guard let model else {return}
        print(#function, model)
        signIn()
//        model.deleteUser()
//        print(#function, model)
        authonticateUser()
    }
    
    func configModel() {
        model = UserModel.model
    }
    
    func signIn() {
        model?.signIn()
    }
    
    func getNowUser() -> User {
        var nowUser = User(userId: "guest", nickName: "-", profileImage: "-", signUpDate: Date())
        if let user = model?.nowUser {
            nowUser = user
        }
        return nowUser
    }
    
    func authonticateUser() {
        let vc = SplashViewController()
        vc.delegate = self
        
        guard let nowUser = model?.nowUser else {return}
        print(#function, "nowUser: \(nowUser)")
        if nowUser.userId == Resource.Text.guestUser {
            vc.nextViewType = OnboadingViewController.self
        } else {
            vc.nextViewType = TabBarController.self
        }
        pushAfterView(view: vc, backButton: false, animated: false)
    }
    
    func signUpNewUser(nickName: String, profileImage: UIImage) -> Bool {
        var thisName = String(profileImage.description).split(separator: " ")[2].replacingOccurrences(of: ")", with: "")
        print(#function, thisName)
        model?.signUp(nickName, profileImage: thisName)
        guard let newUserId = model?.nowUser.userId else {return false}
        if newUserId != Resource.Text.guestUser {
            print(#function, "newUserId: \(newUserId)")
            return true
        }
        return false
    }
    
    func updateUserProfile(nickName: String, profileImage: UIImage) {
        let thisName = String(profileImage.description).split(separator: " ")[2].replacingOccurrences(of: ")", with: "")
        let newMappingKey = nickName + thisName
        guard let oldMappingKey = model?.mappingKey else {return}
        
        if oldMappingKey == newMappingKey {
            return
        }
        model?.updateUser(newMappingKey, nickName, thisName)
    }
    
    func deleteUser() {
        model?.deleteUser()
    }
}
