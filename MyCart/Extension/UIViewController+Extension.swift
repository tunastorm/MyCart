//
//  UIViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit


extension UIViewController {
    
    func setNavigationBarUI() {
        self.navigationController?.navigationBar.tintColor = Resource.MyColor.black
        
        navigationItem.backButtonTitle = ""
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: Resource.MyColor.black]
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Resource.MyColor.white
        appearance.shadowImage = nil
        appearance.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
