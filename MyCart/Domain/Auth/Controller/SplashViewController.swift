//
//  SplashViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

import SnapKit
import Then

class SplashViewController: BaseViewController<SplashView> {
    
    let viewModel = UserViewModel()
    
    private var nextView: UIViewController?
    private var withNavi: Bool?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        bindData()
        viewModel.inputGetUser.value = ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configNavigationbar(navigationColor: Resource.MyColor.white, shadowImage: false)
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
    }
            
//    override func signIn() {
//        super.signIn()
//    }
    
    func bindData() {
        viewModel.outputUser.bind { user in
            guard let user else{
                return
            }
            self.user = user
            self.authonticateUser()
        }
    }
    
    func authonticateUser() {
        print(#function, "최근유저: ", user)
        if let user {
            let tabBar = TabBarController()
            nextView = tabBar
            withNavi = false
        } else {
            let nextVC = OnboadingViewController()
            nextView = nextVC
            withNavi = true
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
