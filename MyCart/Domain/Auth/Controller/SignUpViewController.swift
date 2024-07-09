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
    
    func signUpAndpushMain(nickName: String)
}


class SignUpViewController: BaseViewController<SignUpView> {
   
    var isUpdateView = false
    
    var selectPhotoVC: SelectPhotoViewController?
    
    var selectedPhoto: UIImage? {
        didSet {
            rootView.profileImageView.image = selectedPhoto
        }
    }
    
    var viewModel = UserViewModel()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
        print(#function, isUpdateView)
        configProfile()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.configUpdateViewToggle() 
    }

    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
        configUpdateViewToggle()
    }
    
    func bindData() {
        viewModel.outputUser.bind { user in
            guard let user else {
                return
            }
            self.selectedPhoto = UIImage(named: user.profilImage)
            self.rootView.nickNameTextField.text = user.nickname
            
        }
        viewModel.outputResult.bind { result in
            print(#function, "유저가입 결과")
            guard let result, let status = result as? RepositoryStatus else {
                if let errorMessage = result?.message {
                    makeBasicToast(message: errorMessage, duration: 3.0, position: .bottom)
                }
                return
            }
            makeBasicToast(message: status.message, duration: 3.0, position: .bottom)
            self.goMainViewController()
        }
    }
    
    func configProfile() {
        viewModel.inputGetUser.value = ()
        if let selectedPhoto {
            rootView.profileImageView.image = selectedPhoto
        } else {
            selectedPhoto = Resource.NamedImage.randomProfile
            rootView.profileImageView.image = selectedPhoto
        }
    }
    
    func configUpdateViewToggle() {
        if isUpdateView {
            navigationItem.title = Resource.Text.editProfileTitle
            let barButtonItem = UIBarButtonItem(title: Resource.Text.saveNewProfile,
                                                style: .plain, target: self, action: #selector(updateAndGoSetting))
            navigationItem.rightBarButtonItem = barButtonItem
        } else {
            navigationItem.title = Resource.Text.profileSetting
        }
    }
    
    func signUpNewUser(nickName: String, profileImage: UIImage) {
        var imageName = String(profileImage.description).split(separator: " ")[2].replacingOccurrences(of: ")", with: "")
        viewModel.inputAddUser.value = User(nickname: nickName, profilImage: imageName)
    }
    
    func goMainViewController() {
        let nextVC = SplashViewController()
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.changeRootVCWithNavi(nextVC, animated: false)
    }
    
    @objc func updateAndGoSetting() {
        print(#function, "hihihihi")
        guard let message = rootView.messageLabel.text, message == Resource.Text.nickNameSuccess else {
            return
        }
//        guard let selectedPhoto, let nickName = rootView.nickNameTextField.text, updateUserProfile(nickName: nickName, profileImage: selectedPhoto) else {
//            return
//        }
        popBeforeView(animated: true)
    }
    
//    func updateUserProfile(nickName: String, profileImage: UIImage) -> Bool {
//        let thisName = String(profileImage.description).split(separator: " ")[2].replacingOccurrences(of: ")", with: "")
//        let newMappingKey = nickName + thisName
//        guard let oldMappingKey = userModel.mappingKey else {
//            return false
//        }
//        guard oldMappingKey != newMappingKey else {
//            return false
//        }
//        userModel.updateUser(newMappingKey, nickName, thisName)
//        return true
//    }
}


extension SignUpViewController: SignUpViewDelegate {
    
    func getIsUpdateView() -> Bool {
        return isUpdateView
    }
    
    func getUserName() -> String? {
        return nil
//        return userModel.nowUser.nickName
    }
    
    func pushSelectPhotoView() {
        if selectPhotoVC == nil {
            selectPhotoVC = SelectPhotoViewController()
        }
        guard let selectPhotoVC else {
            return
        }
        selectPhotoVC.delegate = self
        selectPhotoVC.isUpdateView = self.isUpdateView
        selectPhotoVC.selectedPhoto = rootView.profileImageView.image
        pushAfterView(view: selectPhotoVC, backButton: true, animated: true)
    }
    
    func signUpAndpushMain(nickName: String) {
        guard let selectedPhoto else {
            return
        }
        signUpNewUser(nickName: nickName, profileImage: selectedPhoto)
    }
}

extension SignUpViewController: DataReceiveDelegate  {
    
    func receiveData<T>(data: T) {
        print(#function, "프로필 이미지 변경됨")
        selectedPhoto = data as? UIImage
    }
    
}
