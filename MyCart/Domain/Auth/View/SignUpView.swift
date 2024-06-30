//
//  SignUpView.swift
//  MyCart
//
//  Created by 유철원 on 6/30/24.
//

import UIKit


class SignUpView: BaseView {
    
    var delegate: SignUpViewDelegate?
     
    var selectPhotoVC: SelectPhotoViewController?
    
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
    
    override func configHierarchy() {
        self.addSubview(profileView)
        profileView.addSubview(profileImageView)
        profileView.addSubview(cameraIconView)
        cameraIconView.addSubview(cameraIcon)
        self.addSubview(nickNameTextField)
        self.addSubview(lineView)
        self.addSubview(messageLabel)
        self.addSubview(completeButton)
    }
    
    override func configLayout() {
        profileView.snp.makeConstraints {
            $0.size.equalTo(120)
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
            $0.centerX.equalTo(safeAreaLayoutGuide)
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
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(profileView.snp.bottom).offset(50)
        }
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(nickNameTextField.snp.bottom)
        }
        messageLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(lineView.snp.bottom).offset(20)
        }
        completeButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(messageLabel.snp.bottom).offset(40)
        }
    }
    
    override func configView() {
        super.configView()
    }
    
    override func configInteraction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goSelectPhotoView))
        profileView.addGestureRecognizer(tapGesture)
    }
    
    func configUpdateViewToggle() {
        if let isUpdateView = delegate?.getIsUpdateView(), let userName = delegate?.getUserName() {
            completeButton.isHidden = true
            nickNameTextField.placeholder = nil
            nickNameTextField.text = userName
        } else {
            completeButton.isHidden = false
            nickNameTextField.placeholder = Resource.Text.nickNamePlaceholder
        }
    }
    
    
    @objc func checkNickName(_ sender: UITextField) {
        guard let inputText = sender.text else {return}
        let filter = TextInputFilter.filter
        
        if let error = filter.filterSpace(inputText) {
            messageLabel.text = error.nickNameMessage
            return
        }
        if let error = filter.filterCount(inputText) {
            messageLabel.text = error.nickNameMessage
            return
        }
        if let error = filter.filterSpecial(inputText) {
            messageLabel.text = error.nickNameMessage
            return
        }
        if let error = filter.filterNumber(inputText) {
            messageLabel.text = error.nickNameMessage
            return
        }
        messageLabel.text = Resource.Text.nickNameSuccess
    }
    
    @objc func signUpAndGoMain() {
        guard let message = messageLabel.text, message == Resource.Text.nickNameSuccess else {
            return
        }
        guard let delegate, let nickName = nickNameTextField.text else {
            return
        }
        delegate.signUpAndpushMain(message: message, nickName: nickName)
    }
    
    @objc func goSelectPhotoView() {
        guard let delegate else {
            return
        }
        delegate.pushSelectPhotoView()
    }
}
