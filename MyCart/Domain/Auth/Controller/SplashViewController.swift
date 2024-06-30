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
    
    private var nextView: UIViewController?
    private var withNavi: Bool?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        signIn()
        authonticateUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configNavigationbar(navigationColor: Resource.MyColor.white, shadowImage: false)
    }
    
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
    }
            
    override func signIn() {
        super.signIn()
    }
    
    func authonticateUser() {
        if userModel.nowUser.userId == Resource.Text.guestUser {
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
