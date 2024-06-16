//
//  SignUpViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

import SnapKit
import Then


class SignUpViewController: UIViewController {

    var delegate: AuthViewController?
        
    var selectedPhoto: UIImage?
    
    let profileView = UIView()
    
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = Resource.Border.width3
        $0.layer.borderColor = Resource.MyColor.orange.cgColor
        $0.layer.cornerRadius = Resource.CornerRadious.profileImageView
        $0.layer.masksToBounds = true
    }
    
    let cameraIconView = UIView().then {
        $0.backgroundColor = Resource.MyColor.orange
        $0.layer.cornerRadius = Resource.CornerRadious.cameraIcon
        $0.layer.masksToBounds = true
    }
    
    let cameraIcon = UIImageView(image: Resource.SystemImage.cameraFill).then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Resource.MyColor.white
    }
    
    let nickNameTextfield = UITextField().then {
        $0.placeholder = Resource.Text.nickNamePlaceholder
        $0.addTarget(self, action: #selector(checkNickName), for: .editingChanged)
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = Resource.MyColor.lightGray
    }
    
    let messageLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = Resource.MyColor.orange
    }
    
    let completeButton = UIButton().then {
        $0.backgroundColor = Resource.MyColor.orange
        $0.layer.cornerRadius = Resource.CornerRadious.startButton
        $0.layer.masksToBounds = true
        $0.setTitle(Resource.Text.startButton, for: .normal)
        $0.setTitleColor(Resource.MyColor.white, for: .normal)
        $0.addTarget(self, action: #selector(signUpAndGoMain), for: .touchUpInside)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarUI()
        configHierarchy()
        configLayout()
        configView()
    }
    
    func configBaseSetting() {
       
    }
    
    func configHierarchy() {
        view.addSubview(profileView)
        profileView.addSubview(profileImageView)
        profileView.addSubview(cameraIconView)
        cameraIconView.addSubview(cameraIcon)
        view.addSubview(nickNameTextfield)
        view.addSubview(lineView)
        view.addSubview(messageLabel)
        view.addSubview(completeButton)
    }
    
    func configLayout() {
        profileView.snp.makeConstraints {
            $0.size.equalTo(120)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cameraIconView.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.bottom.trailing.equalToSuperview()
        }
        
        cameraIcon.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        
        nickNameTextfield.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(profileView.snp.bottom).offset(50)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(nickNameTextfield.snp.bottom)
        }
        
        messageLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(lineView.snp.bottom).offset(20)
        }
        
        completeButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(messageLabel.snp.bottom).offset(40)
        }
    }
    
    func configView() {
        view.backgroundColor = .white
        navigationItem.title = Resource.Text.profileSetting
        
        if let selectedPhoto {
            profileImageView.image = selectedPhoto
        } else {
            profileImageView.image = Resource.NamedImage.randomProfile
            selectedPhoto = profileImageView.image
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goSelectPhotoView))
        profileView.addGestureRecognizer(tapGesture)
    }

    @objc func checkNickName(_ sender: UITextField) {
        guard let inputText = sender.text else {return}
        let filter = NickNameFilter.filter
        
        if let countMessage = filter.filterCount(inputText) {
            messageLabel.text = countMessage
            return
        }
        
        if let specialMessage = filter.filterSpecial(inputText) {
            messageLabel.text = specialMessage
            return
        }
        
        if let numberMessage = filter.filterNumber(inputText) {
            messageLabel.text = numberMessage
            return
        }
        
        messageLabel.text = Resource.Text.nickNameSuccess.message
    }
    
    @objc func goSelectPhotoView() {
        let vc = SelectPhotoCollectionViewController()
        vc.delegate = self
        vc.selectedPhoto = profileImageView.image
        pushAfterView(view: vc, backButton: true, animated: true)
    }
    
    @objc func signUpAndGoMain() {
        print(#function, messageLabel.text, Resource.Text.nickNameSuccess.message)
        if let message = messageLabel.text, message != Resource.Text.nickNameSuccess.message {
            return
        }
        print(#function)
        guard let nickName = nickNameTextfield.text, let image = selectedPhoto else {return}
        print(#function, nickName, image)
        delegate?.signUpNewUser(nickName: nickName, profileImage: image)
        
        let nextView = AuthViewController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVCWithNavi(nextView, animated: false)
    }
}

extension SignUpViewController: DataReceiveDelegate {
    func receiveData<T>(data: T) {
        selectedPhoto = data as? UIImage
        profileImageView.image = selectedPhoto
    }
}


extension SignUpViewController: UITextFieldDelegate {
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        print(#function)
//        if textField == nickNameTextfield {
//            view.endEditing(true)
//            textField.resignFirstResponder()
//        }
//        return true
//    }
}
