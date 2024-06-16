//
//  OnBoadingViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

class AuthViewController: UIViewController {

    var model: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        print("model: ", model)
        print("UserModel.model: ", UserModel.model)
        
        self.model = UserModel.model
        guard let model else {return}
        authonticateUser()
    }
    
    func authonticateUser() {
        let vc = SplashViewController()
        vc.delegate = self
        
        model?.signIn()
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
}
