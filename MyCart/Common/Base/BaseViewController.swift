//
//  BaseViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/30/24.
//

import UIKit


class BaseViewController<T:BaseView>: UIViewController {
    
    var userModel = UserModel.shared
    
    var rootView = T()
    
    override func loadView() {
        userModel = UserModel.shared
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationbar(navigationColor: Resource.MyColor.white, shadowImage: true)
    }
    
    func signIn() {
        userModel.signIn()
    }
    
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
    
    func showAlert(style: UIAlertController.Style, title: String, message: String,
                   completionHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: style)
        let delete = UIAlertAction(title: "확인",
                                   style: .destructive,
                                   handler: completionHandler)
        let cancle = UIAlertAction(title: "취소",
                                   style: .cancel)
        alert.addAction(cancle)
        alert.addAction(delete)
        present(alert, animated: false)
    }
}
