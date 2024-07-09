//
//  BaseViewController.swift
//  MyCart
//
//  Created by 유철원 on 7/9/24.
//

import UIKit


class BaseViewController: UIViewController {
    
    deinit {
        print("deinit: ", self.self)
    }
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configHierarchy()
        configLayout()
        configView()
        configInteraction()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationbar(navigationColor: Resource.MyColor.white, shadowImage: true)
    }
    
    func configHierarchy() {
    
    }
    
    func configLayout() {
        
    }
    
    func configView() {
        view.backgroundColor = Resource.MyColor.white
    }
    
    func bindData() {
        
    }
    
    func configInteraction() {
        
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


