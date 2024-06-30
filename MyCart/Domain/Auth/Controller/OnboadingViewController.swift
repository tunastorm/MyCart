//
//  OnboadingViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

import SnapKit
import Then


protocol OnboardingViewDelegate {
    func pushToSignUpView()
}


class OnboadingViewController: BaseViewController<OnboardingView> {
    
    var model: UserModel?
    var signUpVC: SignUpViewController?
    
    override func loadView() {
        super.loadView()
        rootView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configNavigationbar(navigationColor: Resource.MyColor.white, shadowImage: false)
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
    }
}

extension OnboadingViewController: OnboardingViewDelegate {
    func pushToSignUpView() {
        if signUpVC == nil {
            signUpVC = SignUpViewController()
        }
        guard let signUpVC else {
            return
        }
        pushAfterView(view: signUpVC, backButton: true, animated: true)
    }
}
