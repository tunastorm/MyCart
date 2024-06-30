//
//  SplashView.swift
//  MyCart
//
//  Created by 유철원 on 6/30/24.
//

import UIKit


class SplashView: BaseView {
    
    let appTitle = UILabel().then {
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 40)
        $0.textColor = Resource.MyColor.orange
        $0.text = Resource.Text.appTitle
    }
    
    let imageView = UIImageView(image: Resource.NamedImage.launch).then {
        $0.contentMode = .scaleToFill
    }
    
    let applicantLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = Resource.Font.boldSystem16
        $0.textColor = Resource.MyColor.orange
        $0.text = Resource.Text.applicantName
    }
    
    override func configHierarchy() {
        self.addSubview(appTitle)
        self.addSubview(imageView)
        self.addSubview(applicantLabel)
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
        
        applicantLabel.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(40)
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        self.backgroundColor = Resource.MyColor.white
    }
}
