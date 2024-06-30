//
//  OnBoardingView.swift
//  MyCart
//
//  Created by 유철원 on 6/30/24.
//

import UIKit


class OnboardingView: BaseView {
    
    var delegate: OnboardingViewDelegate?
    
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
    
    override func configHierarchy() {
        self.addSubview(appTitle)
        self.addSubview(imageView)
        self.addSubview(startButton)
    }
    
    override func configLayout() {
        imageView.snp.makeConstraints {
            $0.width.equalTo(400)
            $0.height.equalTo(300)
            $0.center.equalTo(safeAreaLayoutGuide)
        }
        
        appTitle.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalTo(imageView)
            $0.bottom.equalTo(imageView.snp.top).offset(-60)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        startButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configView() {
        self.backgroundColor = Resource.MyColor.white
    }
    
    @objc func goSignUpView() {
        delegate?.pushToSignUpView()
    }
}
