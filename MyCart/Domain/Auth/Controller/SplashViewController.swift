//
//  SplashViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

import SnapKit
import Then

class SplashViewController: UIViewController {

    var model: UserModel?
    
    private var nextView: UIViewController?
    private var withNavi: Bool?
    
    let appTitle = UILabel().then {
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 40)
        $0.textColor = Resource.MyColor.orange
        $0.text = Resource.Text.appTitle
    }
    
    let imageView = UIImageView(image: Resource.NamedImage.launch).then {
        $0.contentMode = .scaleToFill
    }
    
    let applicantLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = Resource.Font.boldSystem16
        $0.textColor = Resource.MyColor.orange
        $0.text = Resource.Text.applicantName
    }

    
    override func viewDidLoad(){
        super.viewDidLoad()
        configModel()
        signIn()
        configHierarchy()
        configLayout()
        configView()
        authonticateUser()
    }
    
    func configHierarchy() {
        view.addSubview(appTitle)
        view.addSubview(imageView)
        view.addSubview(applicantLabel)
    }
    
    func configLayout() {
        imageView.snp.makeConstraints {
            $0.width.equalTo(400)
            $0.height.equalTo(300)
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        appTitle.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalTo(imageView)
            $0.bottom.equalTo(imageView.snp.top).offset(-60)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        applicantLabel.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(40)
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configView() {
        view.backgroundColor = Resource.MyColor.white
    }
        
    func configModel() {
        model = UserModel.shared
    }
    
    func signIn() {
        model?.signIn()
    }
    
    func authonticateUser() {
        guard let nowUser = model?.nowUser else {return}
        if nowUser.userId == Resource.Text.guestUser {
            let nextVC = OnboadingViewController()
            nextView = nextVC
            withNavi = true
        } else {
            let tabBar = TabBarController()
            nextView = tabBar
            withNavi = false
        }
        // 2초 간 대기후 화면 전환
        let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(changeRootview), userInfo: nil, repeats: false)
        timer.tolerance = 0.2
    }
    
    @objc func changeRootview() {
        guard let nextView else {return}
        
        if let withNavi, withNavi {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVCWithNavi(nextView, animated: false)
        } else {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(nextView, animated: false)
        }
    }
}
