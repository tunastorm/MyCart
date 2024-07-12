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


class SignUpViewController: BaseViewController {
   
    var isUpdateView = false
    var viewModel = SignUpViewModel()
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
        $0.addTarget(self, action: #selector(signUpAndPushMain), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function, isUpdateView)
        viewModel.inputViewDidLoadTrigger.value = ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configUpdateViewToggle()
    }

    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
        configUpdateViewToggle()
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
        viewModel.outputUpdatePresentation.bind { _ in
            self.updatePresentationToggle()
        }
        viewModel.outputViewDidLoadTrigger.bind { userInfo in
            self.configProfile(userInfo?.0, userInfo?.1)
        }
        viewModel.outputValidationResult.bind { result in
            self.messageLabel.text = result
        }
        viewModel.outputAddUserResult.bind { result in
            print(#function, "유저가입 결과")
            guard let status = result as? RepositoryStatus else {
                makeBasicToast(message: result.message, duration: 3.0, position: .bottom)
                return
            }
            makeBasicToast(message: status.message, duration: 3.0, position: .bottom)
            self.goMainViewController()
        }
        viewModel.outputUpdateUserResult.bind { result in
            guard let status = result as? RepositoryStatus else {
                makeBasicToast(message: result.message, duration: 3.0, position: .bottom)
                return
            }
            makeBasicToast(message: result.message, duration: 3.0, position: .bottom)
            self.popBeforeView(animated: true)
        }
    }
    
    override func configInteraction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushSelectPhotoView))
        profileView.addGestureRecognizer(tapGesture)
    }
    
    func setUpdateview() {
        viewModel.inputUpdatePresentation.value = ()
    }
    
    private func configProfile(_ nickname: String?, _ imageName: String?) {
        guard let nickname, let imageName else { // SignUp
            profileImageView.image = Resource.NamedImage.randomProfile
            return
        }
        // Update
        profileImageView.image = UIImage(named: imageName)
        nickNameTextField.text = nickname
    }
    
    private func updatePresentationToggle() {
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
        if selectPhotoVC == nil {
            selectPhotoVC = SelectPhotoViewController()
        }
        guard let selectPhotoVC else {
            return
        }
        selectPhotoVC.delegate = self
        selectPhotoVC.isUpdateView = self.isUpdateView
        print(#function, profileImageView.image)
        selectPhotoVC.selectedPhoto = profileImageView.image
        pushAfterView(view: selectPhotoVC, backButton: true, animated: true)
    }
    
    @objc func signUpAndPushMain() {
        print(#function, "시작하기 클릭됨")
        viewModel.inputCompleteButton.value = ()
    }
}

extension SignUpViewController: DataReceiveDelegate  {
    func receiveData<T>(data: T) {
        print(#function, "프로필 이미지 변경됨")
        viewModel. = data as? UIImage
    }
}
