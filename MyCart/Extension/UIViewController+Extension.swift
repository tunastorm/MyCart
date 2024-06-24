//
//  UIViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit


extension UIViewController {
    
    func setOnboardingNavigationBarUI() {
        self.navigationController?.navigationBar.tintColor = Resource.MyColor.black
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        self.navigationItem.backButtonTitle = ""
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Resource.MyColor.white
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setNavigationBarUI() {
        self.navigationController?.navigationBar.tintColor = Resource.MyColor.black
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        self.navigationItem.backButtonTitle = ""
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: Resource.MyColor.black]
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Resource.MyColor.white
        appearance.shadowImage = nil
        appearance.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
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
