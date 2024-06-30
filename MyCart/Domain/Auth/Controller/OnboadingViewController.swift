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


class OnboadingViewController: BaseViewController {
    
    var model: UserModel?
    let rootView = OnboardingView()
    
    let signUpVC = SignUpViewController()
    
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func goSignUpView() {
        let vc = SignUpViewController()
        pushAfterView(view: vc, backButton: true, animated: true)
    }
}

extension OnboadingViewController: OnboardingViewDelegate {
    func pushToSignUpView() {
        pushAfterView(view: signUpVC, backButton: true, animated: true)
    }
    
    func
}
