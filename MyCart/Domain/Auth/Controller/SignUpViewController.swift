//
//  SignUpViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

import SnapKit
import Then


protocol SignUpViewDelegate {
    func getIsUpdateView() -> Bool
    
    func getUserName() -> String?
    
    func goSelectPhotoView()
    
    func signUpAndGoMain(message: String, nickName: String, selectedPhoto: UIImage)
    
    func updateAndGoSetting(message: String, nickName: String, selectedPhoto: UIImage)
}


class SignUpViewController: BaseViewController {
   
    var isUpdateView = false
    
    let rootView = SignUpView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userModel?.signIn()
        configUpdateViewToggle()
        setNavigationBarUI()
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
        navigationItem.title = Resource.Text.profileSetting
    }
    
    func configUpdateViewToggle() {
        if isUpdateView {
            navigationItem.title =  Resource.Text.editProfileTitle
            let barButtonItem = UIBarButtonItem(title: Resource.Text.saveNewProfile,
                                                style: .plain, target: self, action: #selector(updateAndGoSetting))
            navigationItem.rightBarButtonItem = barButtonItem
            rootView.completeButton.isHidden = true
            guard let userName = userModel?.nowUser.nickName else {return}
            rootView.nickNameTextField.placeholder = nil
            rootView.nickNameTextField.text = userName
        } else {
            navigationItem.title = Resource.Text.profileSetting
            rootView.completeButton.isHidden = false
            rootView.nickNameTextField.placeholder = Resource.Text.nickNamePlaceholder
        }
    }
    
    func signUpNewUser(nickName: String, profileImage: UIImage) -> Bool {
        var thisName = String(profileImage.description).split(separator: " ")[2].replacingOccurrences(of: ")", with: "")
        userModel?.signUp(nickName, profileImage: thisName)
        guard let newUserId = userModel?.nowUser.userId else {
            return false
        }
        if newUserId == Resource.Text.guestUser {
            return false
        }
        return true
    }
    
    func updateUserProfile(nickName: String, profileImage: UIImage) -> Bool {
        let thisName = String(profileImage.description).split(separator: " ")[2].replacingOccurrences(of: ")", with: "")
        let newMappingKey = nickName + thisName
        guard let oldMappingKey = userModel?.mappingKey else {
            return false
        }
        guard oldMappingKey != newMappingKey else {
            return false
        }
        userModel?.updateUser(newMappingKey, nickName, thisName)
        return true
    }
    
}

extension SignUpViewController: DataReceiveDelegate {
    func receiveData<T>(data: T) {
        rootView.profileImageView.image = data as? UIImage
    }
}

extension SignUpViewController: SignUpViewDelegate {
   
    func getIsUpdateView() -> Bool {
        return isUpdateView
    }
    
    func getUserName() -> String? {
        return userModel?.nowUser.nickName
    }
    
    func goSelectPhotoView() {
        let vc = SelectPhotoViewController()
        vc.delegate = self
        vc.selectedPhoto = rootView.profileImageView.image
        pushAfterView(view: vc, backButton: true, animated: true)
    }
    
    func signUpAndGoMain(message: String, nickName: String, selectedPhoto: UIImage) {
        guard message == Resource.Text.nickNameSuccess else {
            return
        }
        guard signUpNewUser(nickName: nickName, profileImage: selectedPhoto) else {
            return
        }
        
        let nextView = BaseAuthViewController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVCWithNavi(nextView, animated: false)
    }
    
    @objc func updateAndGoSetting(message: String, nickName: String, selectedPhoto: UIImage) {
        guard message == Resource.Text.nickNameSuccess else {
            return
        }
        guard updateUserProfile(nickName: nickName, profileImage: selectedPhoto) else {
            return
        }
        popBeforeView(animated: true)
    }
    
}
