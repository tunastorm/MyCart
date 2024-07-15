//
//  SignUpViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

import SnapKit
import Then


protocol SelectPhotoDelegate {
    func getIsUpdatePresentation() -> Bool
    func setSelectedPhoto(_ indexPath: IndexPath)
    func getSelectedPhoto() -> IndexPath? 
    func receiveSelectedPhoto<T>(data: T)
}


class SignUpViewController: BaseViewController {
   
    let viewModel = SignUpViewModel()
  
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
        $0.addTarget(self, action: #selector(signUpAndPushMain), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputViewDidLoadTrigger.value = ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.self, #function, "\n", self.navigationController?.viewControllers)
    }
    
    override func configHierarchy() {
        view.addSubview(profileView)
        profileView.addSubview(profileImageView)
        profileView.addSubview(cameraIconView)
        cameraIconView.addSubview(cameraIcon)
        view.addSubview(nickNameTextField)
        view.addSubview(lineView)
        view.addSubview(messageLabel)
        view.addSubview(completeButton)
    }
    
    override func configLayout() {
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
    
    override func bindData() {
        viewModel.outputViewDidLoadTrigger.bind { [weak self] userInfo in
            self?.configProfileToggle(userInfo?.0, userInfo?.1)
            self?.updatePresentationToggle()
        }
        viewModel.outputValidationResult.bind { [weak self] result in
            self?.messageLabel.text = result
        }
        viewModel.outputAddUserResult.bind { [weak self] result in
            guard let status = result as? RepositoryStatus else {
                makeBasicToast(message: result.message, duration: 3.0, position: .bottom)
                return
            }
            makeBasicToast(message: status.message, duration: 3.0, position: .bottom)
            self?.goMainViewController()
        }
        viewModel.outputUpdateUserResult.bind { [weak self] result in
            guard let status = result as? RepositoryStatus else {
                makeBasicToast(message: result.message, duration: 3.0, position: .bottom)
                return
            }
            makeBasicToast(message: result.message, duration: 3.0, position: .bottom)
            self?.popBeforeView(animated: true)
        }
    }
    
    override func configInteraction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushSelectPhotoView))
        profileView.addGestureRecognizer(tapGesture)
    }
    
    func setUpdatePresentation() {
        viewModel.inputUpdatePresentation.value = ()
    }
    
    private func configProfileToggle(_ nickname: String?, _ imageName: String?) {
        guard let nickname, let imageName else { // SignUp
            profileImageView.image = Resource.NamedImage.randomProfile
            nickNameTextField.text = nil
            return
        }
        // Update
        profileImageView.image = UIImage(named: imageName)
        nickNameTextField.text = nickname
    }
    
    private func updatePresentationToggle() {
        print(#function, viewModel.outputUpdatePresentation.value )
        if viewModel.outputUpdatePresentation.value {
            navigationItem.title = Resource.Text.editProfileTitle
            let barButtonItem = UIBarButtonItem(title: Resource.Text.saveNewProfile,
                                                style: .plain, target: self, action: #selector(updateAndGoSetting))
            navigationItem.rightBarButtonItem = barButtonItem
            completeButton.isHidden = true
            nickNameTextField.placeholder = nil
        } else {
            navigationItem.title = Resource.Text.profileSetting
            completeButton.isHidden = false
            nickNameTextField.placeholder = Resource.Text.nickNamePlaceholder
        }
    }
    
    func goMainViewController() {
        let nextVC = SplashViewController()
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.changeRootVCWithNavi(nextVC, animated: false)
    }
    
    private func addUser(_ nickname: String, _ imageName: String) {
        self.viewModel.inputAddUser.value = User(nickname: nickname, profilImage: imageName)
    }
    
    private func updateUser(_ nickname: String, _ imageName: String) {
        self.viewModel.inputUpdateUser.value = (nickname, imageName)
    }
    
    @objc func checkNickName(_ sender: UITextField) {
        viewModel.inputNickNameValidate.value = sender.text
    }
    
    @objc func updateAndGoSetting() {
        print(#function, "hihihihi")
        viewModel.inputCompleteButton.value = ()
    }
    
    @objc func pushSelectPhotoView() {
        let vc = SelectPhotoViewController()
        vc.delegate = self
        pushAfterView(view: vc, backButton: true, animated: true)
    }
    
    @objc func signUpAndPushMain() {
        viewModel.inputCompleteButton.value = ()
    }
}

extension SignUpViewController: SelectPhotoDelegate  {
    func getIsUpdatePresentation() -> Bool {
        return viewModel.outputUpdatePresentation.value
    }
    
    func setSelectedPhoto(_ indexPath: IndexPath) {
        viewModel.selectedPhoto = indexPath
    }
    
    func getSelectedPhoto() -> IndexPath? {
        return viewModel.selectedPhoto
    }
    
    func receiveSelectedPhoto<T>(data: T) {
        guard let image = data as? UIImage else { return }
        profileImageView.image = image
    }
}
