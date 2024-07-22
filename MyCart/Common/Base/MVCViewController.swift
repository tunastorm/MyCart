//
//  BaseViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/30/24.
//

import UIKit


class MVCViewController<T:BaseView>: UIViewController {
    
    deinit {
        print("deinit: ", self.self)
    }
    
    var user: User?
    
    var rootView = T()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationbar(navigationColor: Resource.MyColor.white, shadowImage: true)
    }
    
//    func signIn() {
//        userModel.signIn()
//    }
    
    func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        let textAttributes = [NSAttributedString.Key.foregroundColor: Resource.MyColor.black]
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = navigationColor
        appearance.shadowImage = shadowImage ? nil : UIImage()
        appearance.shadowColor = shadowImage ? Resource.MyColor.lightGray : .clear
        appearance.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonTitle = ""
    }
}
