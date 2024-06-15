//
//  OnboadingViewController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

import SnapKit
import Then

class OnboadingViewController: UIViewController {

    var delegate: AuthViewController?
    
    let appTitle = UILabel().then {
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 40)
        $0.textColor = Resource.MyColor.orange
        $0.text = Resource.Text.appTitle
    }
    
    let imageView = UIImageView(image: Resource.NamedImage.launch).then {
        $0.contentMode = .scaleToFill
    }
    
    let startButton = UIButton().then {
        $0.titleLabel?.font = Resource.Font.boldSystem16
        $0.setTitleColor(Resource.MyColor.white, for: .normal)
        $0.backgroundColor = Resource.MyColor.orange
        $0.layer.cornerRadius = Resource.CornerRadious.startButton
        $0.layer.masksToBounds = true
        $0.setTitle(Resource.Text.startButton, for: .normal)
        $0.addTarget(self, action: #selector(goSignUpView), for: .touchUpInside)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configHierarchy()
        configLayout()
        configView()
    }
    
    func configHierarchy() {
        view.addSubview(appTitle)
        view.addSubview(imageView)
        view.addSubview(startButton)
    }
    
    func configLayout() {
        
        imageView.snp.makeConstraints {
            $0.width.equalTo(400)
            $0.height.equalTo(300)
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        appTitle.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalTo(imageView)
            $0.bottom.equalTo(imageView.snp.top).offset(-60)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        startButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func configView() {
        view.backgroundColor = Resource.MyColor.white
    }
    
    @objc func goSignUpView() {
        let vc = SignUpViewController()
        vc.delegate = self.delegate
        pushAfterView(view: vc, backButton: true, animated: true)
    }
}
