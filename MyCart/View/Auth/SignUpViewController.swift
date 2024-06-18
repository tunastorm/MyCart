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

    var isUpdateView = false
    
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
    
    let nickNameTextField = UITextField().then {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.signIn()
        configUpdateViewToggle()
    }
    
    func configHierarchy() {
        view.addSubview(profileView)
        profileView.addSubview(profileImageView)
        profileView.addSubview(cameraIconView)
        cameraIconView.addSubview(cameraIcon)
        view.addSubview(nickNameTextField)
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
        
        nickNameTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(profileView.snp.bottom).offset(50)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(nickNameTextField.snp.bottom)
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
        
        if let selectedPhoto {
            profileImageView.image = selectedPhoto
        } else {
            profileImageView.image = Resource.NamedImage.randomProfile
            selectedPhoto = profileImageView.image
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goSelectPhotoView))
        profileView.addGestureRecognizer(tapGesture)
    }
    
    func configUpdateViewToggle() {
        if isUpdateView {
            navigationItem.title =  Resource.Text.editProfileTitle
            let barButtonItem = UIBarButtonItem(title: Resource.Text.saveNewProfile,
                                                style: .plain, target: self, action: #selector(updateAndGoSetting))
            navigationItem.rightBarButtonItem = barButtonItem
            completeButton.isHidden = true
            guard let userName = delegate?.getNowUserName() else {return}
            nickNameTextField.placeholder = nil
            nickNameTextField.text = userName
        } else {
            navigationItem.title = Resource.Text.profileSetting
            completeButton.isHidden = false
            nickNameTextField.placeholder = Resource.Text.nickNamePlaceholder
        }
    }

    @objc func checkNickName(_ sender: UITextField) {
        guard let inputText = sender.text else {return}
        let filter = NickNameFilter.filter
        
        if let spaceMessage = filter.filterSpace(inputText) {
            messageLabel.text = spaceMessage
            return
        }
        
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
        
        messageLabel.text = Resource.Text.nickNameSuccess
    }
    
    @objc func goSelectPhotoView() {
        let vc = SelectPhotoCollectionViewController()
        vc.delegate = self
        vc.selectedPhoto = profileImageView.image
        pushAfterView(view: vc, backButton: true, animated: true)
    }
    
    @objc func signUpAndGoMain() {
        guard let message = messageLabel.text, message == Resource.Text.nickNameSuccess else {
            return
        }
        guard let nickName = nickNameTextField.text, let image = selectedPhoto else {return}
        delegate?.signUpNewUser(nickName: nickName, profileImage: image)
        
        let nextView = AuthViewController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVCWithNavi(nextView, animated: false)
    }
    
    @objc func updateAndGoSetting() {
        guard let message = messageLabel.text, message == Resource.Text.nickNameSuccess  else {
            return
        }
        guard let nickName = nickNameTextField.text, let image = selectedPhoto else {return}
        
        delegate?.updateUserProfile(nickName: nickName, profileImage: image)
        
        popBeforeView(animated: true)
    }
}

extension SignUpViewController: DataReceiveDelegate {
    func receiveData<T>(data: T) {
        selectedPhoto = data as? UIImage
        profileImageView.image = selectedPhoto
    }
}
