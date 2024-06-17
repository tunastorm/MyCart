//
//  UpdateProfileViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/17/24.
//

import UIKit

class UpdateProfileViewController: UIViewController {
     
    var delegate: AuthViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configHierarchy()
        configLayout()
        configView()
        setNavigationBarUI()
    }
    
    func configHierarchy() {
        
    }
    
    func configLayout() {
        
    }
    
    func configView() {
        view.backgroundColor = .white
        navigationItem.title = Resource.Text.editProfileTitle
    }
}
