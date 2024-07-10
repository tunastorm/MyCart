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
    var selectedPhoto: UIImage? {
        didSet {
            profileImageView.image = selectedPhoto
        }
    }
  
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
        configProfile()
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
        viewModel.outputValidateMessage.bind { result in
            self.messageLabel.text = result
        }
        viewModel.outputValidateResult.bind { isValidate, nickName in
            guard isValidate else {
               return
            }
            guard let image = self.selectedPhoto, let nickName else {
                return
            }
            
            let imageName = String(image.description).split(separator: " ")[2].replacingOccurrences(of: ")", with: "")
            
            print(#function, "값 준비 완료: ", nickName, imageName)
            if self.isUpdateView, let id = self.user?.id  {
                print(#function, "에딧 뷰")
                self.viewModel.inputUpdateUser.value = [
                    User.Column.id.name: id,
                    User.Column.nickname.name: nickName,
                    User.Column.profileImage.name: imageName
                ]
            } else {
                print(#function, "프로필 세팅 뷰")
                self.viewModel.inputAddUser.value = User(nickname: nickName, profilImage: imageName)
            }
        }
        viewModel.outputUser.bind { user in
            guard let user, self.isUpdateView else {
                return
            }
            self.user = user
            self.selectedPhoto = UIImage(named: user.profileImage)
            self.nickNameTextField.text = user.nickname
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
            makeBasicToast(message: status.message, duration: 3.0, position: .bottom)
            self.popBeforeView(animated: true)
        }
    }
    
    override func configInteraction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushSelectPhotoView))
        profileView.addGestureRecognizer(tapGesture)
    }
    
    func configProfile() {
        viewModel.inputGetUser.value = ()
        if let selectedPhoto {
            profileImageView.image = selectedPhoto
        } else {
            selectedPhoto = Resource.NamedImage.randomProfile
            profileImageView.image = selectedPhoto
        }
    }
    
    func configUpdateViewToggle() {
        if isUpdateView {
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
    
    @objc func checkNickName(_ sender: UITextField) {
        viewModel.inputNickName.value = sender.text
    }
    
    @objc func updateAndGoSetting() {
        print(#function, "hihihihi")
        viewModel.inputValidate.value = ()
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
        viewModel.inputValidate.value = ()
    }
}

extension SignUpViewController: DataReceiveDelegate  {
    func receiveData<T>(data: T) {
        print(#function, "프로필 이미지 변경됨")
        selectedPhoto = data as? UIImage
    }
    
}
