//
//  SettingMainViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/17/24.
//

import UIKit

import SnapKit
import Then


protocol SettingViewDelegate {
    func configProfile()

    func configCartCount()
    
    func pushUpdateProfile()
    
    func alertSecession()
}


class SettingViewController: BaseViewController<SettingView> {
    
    var signUpVC: SignUpViewController?
    
    override func loadView() {
        super.loadView()
        rootView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.setNeedsLayout()
        configCartCount()
        configProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootView.configUnderline()
        view.layoutIfNeeded()
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
        navigationItem.title = Resource.Text.settingViewTitle
    }
    
    func deleteUser() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        userModel.deleteUser()
        let nextVC = SplashViewController()
        sceneDelegate.changeRootVCWithNavi(nextVC, animated: false)
    }
}

extension SettingViewController: SettingViewDelegate {

    func configProfile() {
        let user = userModel.nowUser
        rootView.photoView.image = UIImage(named: user.profileImage)
        rootView.nickNamLabel.text = user.nickName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd 가입"
        rootView.signUpDateLabel.text = dateFormatter.string(from: user.signUpDate)
    }
    
    func configCartCount() {
        let cartCount = userModel.getLikedListCount()
        if cartCount > 0 {
            rootView.myCartIcon.image = Resource.IsLike.like.image
        } else {
            rootView.myCartIcon.image = Resource.IsLike.unLike.image
        }
        var countText = String(cartCount) + Resource.Text.myCartCountLabel
        var attributedStr = NSMutableAttributedString(string: countText)
        attributedStr.addAttribute(.font, value: Resource.Font.boldSystem16,
                                   range: (countText as NSString).range(of: "\(cartCount)개"))
        rootView.myCartCountLabel.attributedText = attributedStr
    }
    
    func pushUpdateProfile() {
        if signUpVC == nil {
            signUpVC = SignUpViewController()
        }
        guard let signUpVC else {
            return
        }
        signUpVC.isUpdateView = true
        signUpVC.selectedPhoto = rootView.photoView.image
        print(#function, signUpVC.selectedPhoto)
        pushAfterView(view: signUpVC, backButton: true, animated: true)
    }
    
    func alertSecession() {
        showAlert(style: .alert, title: Resource.Text.secessionAlertTitle,
                  message: Resource.Text.secessionAlertMessage) { _ in
            self.deleteUser()
        }
    }
}
