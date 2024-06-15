//
//  SignUpViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

import SnapKit
import Then


class SignUpViewController: UIViewController {

    var delegate: AuthViewController?
        
    let profileView = UIView()
    
    let profileImageView = UIImageView(image: Resource.NamedImage.profile).then {
        $0.contentMode = .scaleToFill
        $0.layer.borderWidth = Resource.Border.width3
        $0.layer.borderColor = Resource.MyColor.orange.cgColor
//        $0.layer.cornerRadius
        $0.layer.masksToBounds = true
        
    }
    
    let cameraIcon = UIImageView(image: Resource.SystemImage.cameraFill).then {
        $0.backgroundColor = Resource.MyColor.orange
//        $0.layer.cornerRadius
        $0.layer.masksToBounds = true
    }
    
    let nickNameTextfield = UITextField().then {
        $0.placeholder = Resource.Text.nickNamePlaceholder
        
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = Resource.MyColor.lightGray
    }
    
    let messageLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = Resource.MyColor.orange
    }
    
    let completeButton = UIButton().then {
        $0.layer.masksToBounds = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarUI()
        view.backgroundColor = .red
    }
    
    func configHierarchy() {
        
    }
    
    func configLayout() {
        
    }
    
    func configView() {
        
    }
}
