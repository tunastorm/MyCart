//
//  AppDelegate.swift
//  MyCart
//
//  Created by 유철원 on 6/13/24.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 라이브러리를 사용할 수 있도록 기본 설정
        IQKeyboardManager.shared.enable = true
        // 별도 코드 작성 없이 키보드 위에 Toolbar 삽입 (Done 버튼 추가)
        IQKeyboardManager.shared.enableAutoToolbar = false
        // 화면 아무 곳이나 터치하면 키보드가 자동으로 내려갈 수 있도록 설정
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

