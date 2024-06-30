//
//  Toast.swift
//  MyCart
//
//  Created by 유철원 on 6/18/24.
//

import UIKit

import Toast


// MARK: - Normal Toast, Message 내용 / duration 지속시간 / position Toast위치
/// Normal Toast  2, Message 내용 / duration 지속시간 / position Toast위치
func makeBasicToast(message: String, duration: CGFloat, position: ToastPosition, title: String? = nil) {
    
    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
        let keyWindow = scene.windows.first(where: { $0.isKeyWindow })
        keyWindow?.rootViewController?.view.makeToast(message, duration: duration, position: position, title: title)
    }
}

// MARK: - Image, Title Toast, Message 내용 / duration 지속시간 / position Toast위치 / title 타이틀 / image 이미지
///Image, Title Toast, Message 내용 / duration 지속시간 / position Toast위치 / title 타이틀 / image 이미지
func makeToastWithImage(message: String, duration: CGFloat, position: ToastPosition, title: String, image: UIImage) {
    
    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
        let keyWindow = scene.windows.first(where: { $0.isKeyWindow })

        keyWindow?.rootViewController?.view.makeToast(message, duration: duration, position: position, title: title, image: image)
    }
}


func makeLoadingToast(positon: ToastPosition) {
    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
        let keyWindow = scene.windows.first(where: { $0.isKeyWindow })
        keyWindow?.rootViewController?.view.makeToastActivity(.center)
    }
}

func hideToastActivity() {
    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
        let keyWindow = scene.windows.first(where: { $0.isKeyWindow })
        keyWindow?.rootViewController?.view.hideToastActivity()
    }
}
