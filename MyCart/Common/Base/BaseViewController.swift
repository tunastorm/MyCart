//
//  BaseViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/30/24.
//

import UIKit


class BaseViewController: UIViewController {
    
    var userModel: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUserModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationbar(navigationColor: Resource.MyColor.white, shadowImage: true)
    }
    
    func configUserModel() {
        userModel = UserModel.shared
    }
    
    func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        let textAttributes = [NSAttributedString.Key.foregroundColor: Resource.MyColor.black]
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = navigationColor
        appearance.shadowImage = shadowImage ? nil : UIImage()
        appearance.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonTitle = ""
    }
}
