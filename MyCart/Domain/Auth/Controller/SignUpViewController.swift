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
    
    func pushSelectPhotoView()
    
    func signUpAndpushMain(message: String, nickName: String)
    
    func updateAndGoSetting(message: String, nickName: String)
}


class SignUpViewController: BaseViewController<SignUpView> {
   
    var isUpdateView = false
    
    var selectPhotoVC: SelectPhotoViewController?
    
    var selectedPhoto: UIImage?
    
    override func loadView() {
        super.loadView()
        rootView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userModel.signIn()
        configProfile()
        rootView.configUpdateViewToggle() 
    }

    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
        configUpdateViewToggle()
    }
    
    func configUpdateViewToggle() {
        if isUpdateView {
            navigationItem.title =  Resource.Text.editProfileTitle
            let barButtonItem = UIBarButtonItem(title: Resource.Text.saveNewProfile,
                                                style: .plain, target: self, action: #selector(updateAndGoSetting))
            navigationItem.rightBarButtonItem = barButtonItem
        } else {
            navigationItem.title = Resource.Text.profileSetting
        }
    }
    
    func signUpNewUser(nickName: String, profileImage: UIImage) -> Bool {
        var thisName = String(profileImage.description).split(separator: " ")[2].replacingOccurrences(of: ")", with: "")
        userModel.signUp(nickName, profileImage: thisName)
        
        guard userModel.nowUser.userId != Resource.Text.guestUser else {
            return false
        }
        return true
    }
    
    func updateUserProfile(nickName: String, profileImage: UIImage) -> Bool {
        let thisName = String(profileImage.description).split(separator: " ")[2].replacingOccurrences(of: ")", with: "")
        let newMappingKey = nickName + thisName
        guard let oldMappingKey = userModel.mappingKey else {
            return false
        }
        guard oldMappingKey != newMappingKey else {
            return false
        }
        userModel.updateUser(newMappingKey, nickName, thisName)
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
        return userModel.nowUser.nickName
    }
    
    func configProfile() {
        if let selectedPhoto {
            rootView.profileImageView.image = selectedPhoto
        } else {
            selectedPhoto = Resource.NamedImage.randomProfile
            rootView.profileImageView.image = selectedPhoto
        }
    }
    
    func pushSelectPhotoView() {
        if selectPhotoVC == nil {
            selectPhotoVC = SelectPhotoViewController()
        }
        guard let selectPhotoVC else {
            return
        }
        selectPhotoVC.delegate = self
        selectPhotoVC.selectedPhoto = rootView.profileImageView.image
        pushAfterView(view: selectPhotoVC, backButton: true, animated: true)
    }
    
    func signUpAndpushMain(message: String, nickName: String) {
        guard message == Resource.Text.nickNameSuccess else {
            return
        }
        guard let selectedPhoto, signUpNewUser(nickName: nickName, profileImage: selectedPhoto) else {
            return
        }
        let nextVC = SplashViewController()
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.changeRootVCWithNavi(nextVC, animated: false)
    }
    
    @objc func updateAndGoSetting(message: String, nickName: String) {
        guard message == Resource.Text.nickNameSuccess else {
            return
        }
        guard let selectedPhoto, updateUserProfile(nickName: nickName, profileImage: selectedPhoto) else {
            return
        }
        popBeforeView(animated: true)
    }
    
}
