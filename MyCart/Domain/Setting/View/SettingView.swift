//
//  SettingView.swift
//  MyCart
//
//  Created by 유철원 on 7/1/24.
//

import UIKit

import SnapKit
import Then


class SettingView: BaseView {
    
    var delegate: SettingViewDelegate?
    
    let profileView = UIView()
    
    let photoView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = Resource.Border.width3
        $0.layer.borderColor = Resource.MyColor.orange.cgColor
        $0.layer.cornerRadius = Resource.CornerRadious.settingProfileImage
        $0.layer.masksToBounds = true
        $0.alpha = Resource.Alpha.full
    }
    
    let nickNamLabel = UILabel().then {
        $0.font = Resource.Font.boldSystem16
        $0.textAlignment = .left
    }
    
    let signUpDateLabel = UILabel().then {
        $0.font = Resource.Font.system14
        $0.textColor = Resource.MyColor.lightGray
    }
    
    let goUpdateProfileIcon = UIImageView(image: Resource.SystemImage.chevronRight).then {
        $0.tintColor = Resource.MyColor.gray
    }
    
    let myCartView = UIView().then {
        $0.isUserInteractionEnabled = false
    }
    
    let myCartLabel = UILabel().then {
        $0.font = Resource.Font.system15
        $0.textAlignment = .left
        $0.text = Resource.Text.myCartLabel
    }
    
    let myCartIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    let myCartCountLabel = UILabel().then {
        $0.font = Resource.Font.system16
        $0.textAlignment = .right
        $0.text = Resource.Text.myCartCountLabel
    }
    
    let QnAView = UIView().then {
        $0.isUserInteractionEnabled = false
    }
    
    let QnALabel = UILabel().then {
        $0.font = Resource.Font.system15
        $0.textAlignment = .left
        $0.text = Resource.Text.QnALabel
    }
    
    let customerVoiceView = UIView().then {
        $0.isUserInteractionEnabled = false
    }
    
    let customerVoiceLabel = UILabel().then {
        $0.font = Resource.Font.system15
        $0.text = Resource.Text.customerVoiceLabel
    }
    
    let notificationView = UIView().then {
        $0.isUserInteractionEnabled = false
    }
    
    let notificationLabel = UILabel().then {
        $0.font = Resource.Font.system15
        $0.text = Resource.Text.notificationLabel
    }
    
    let secessionView = UIView()
    
    let secessionLabel = UILabel().then {
        $0.font = Resource.Font.system15
        $0.text = Resource.Text.secessionLabel
    }
   
    override func configHierarchy() {
        self.addSubview(profileView)
        profileView.addSubview(photoView)
        profileView.addSubview(nickNamLabel)
        profileView.addSubview(signUpDateLabel)
        profileView.addSubview(goUpdateProfileIcon)
        self.addSubview(myCartView)
        myCartView.addSubview(myCartLabel)
        myCartView.addSubview(myCartIcon)
        myCartView.addSubview(myCartCountLabel)
        self.addSubview(QnAView)
        QnAView.addSubview(QnALabel)
        self.addSubview(customerVoiceView)
        customerVoiceView.addSubview(customerVoiceLabel)
        self.addSubview(notificationView)
        notificationView.addSubview(notificationLabel)
        self.addSubview(secessionView)
        secessionView.addSubview(secessionLabel)
    }
    
    override func configLayout() {
        profileView.snp.makeConstraints {
            $0.height.equalTo(120)
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        myCartView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(profileView.snp.bottom).offset(1)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        QnAView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(myCartView.snp.bottom).offset(1)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        customerVoiceView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(QnAView.snp.bottom).offset(1)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        notificationView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(customerVoiceView.snp.bottom).offset(1)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        secessionView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(notificationView.snp.bottom).offset(1)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        photoView.snp.makeConstraints {
            $0.size.equalTo(80)
            $0.leading.verticalEdges.equalToSuperview().inset(20)
        }
        
        nickNamLabel.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.size.equalTo(120)
            $0.top.equalToSuperview().inset(40)
            $0.leading.equalTo(photoView.snp.trailing).offset(20)
        }
        
        signUpDateLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.equalTo(nickNamLabel)
            $0.top.equalTo(nickNamLabel.snp.bottom).offset(2)
            $0.leading.equalTo(photoView.snp.trailing).offset(20)
            $0.bottom.equalToSuperview().inset(40)
        }
        
        goUpdateProfileIcon.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        myCartLabel.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.leading.equalToSuperview()
        }
        
        myCartCountLabel.snp.makeConstraints {
            $0.width.lessThanOrEqualTo(200)
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview()
        }
        
        myCartIcon.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.trailing.equalTo(myCartCountLabel.snp.leading).offset(-4)
        }
        
        QnALabel.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.leading.equalToSuperview()
        }
        
        customerVoiceLabel.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.leading.equalToSuperview()
        }
        
        notificationLabel.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.leading.equalToSuperview()
        }
        
        secessionLabel.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.leading.equalToSuperview()
        }
    }
    
    override func configView() {
        super.configView()
        guard let delegate else {
            return
        }
        delegate.configProfile()
        delegate.configCartCount()
    }
    
    override func configInteraction() {
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(goUpdateProfile))
        profileView.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(showAlertSecession))
        secessionView.addGestureRecognizer(tapGesture2)
    }
    
    func configUnderline() {
        for view in [myCartView, QnAView, customerVoiceView, notificationView, secessionView] {
            if view == secessionView {
                view.layer.addBorder([.top, .bottom], color: Resource.MyColor.gray,
                                        width: Resource.Border.width1)
            } else {
                view.layer.addBorder([.top], color: Resource.MyColor.gray,
                                      width: Resource.Border.width1)
            }
        }
    }
    
    @objc func goUpdateProfile() {
        guard let delegate else {
            print(#function, delegate)
            return
        }
        delegate.pushUpdateProfile()
    }
    
    @objc func showAlertSecession() {
        guard let delegate else {
            print(#function, delegate)
            return
        }
        delegate.alertSecession()
    }
}
