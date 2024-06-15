//
//  OnBoadingViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

class AuthViewController: UIViewController {

    let model = UserModel.model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        authonticateUser()
    }
    
    func authonticateUser() {
        let vc = SplashViewController()
        vc.delegate = self
        
        let nowUser = model.nowUser
        if nowUser.userId == Resource.Text.guestUser {
            vc.nextViewType = OnboadingViewController.self
        } else {
            vc.nextViewType = TabBarController.self
        }
        pushAfterView(view: vc, backButton: false, animated: false)
    }
}
