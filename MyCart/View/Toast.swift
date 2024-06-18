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
func makeToast(message: String, duration: CGFloat, position: ToastPosition) {
    
    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
        let keyWindow = scene.windows.first(where: { $0.isKeyWindow })
        
        keyWindow?.rootViewController?.view.makeToast(message, duration: duration, position: position)
    }
}

func makeLoadingToast(positon: ToastPosition) {
    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
        let keyWindow = scene.windows.first(where: { $0.isKeyWindow })
        keyWindow?.rootViewController?.view.makeToastActivity(.center)
    }
}

func hideAllToast() {
    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
        let keyWindow = scene.windows.first(where: { $0.isKeyWindow })
        keyWindow?.rootViewController?.view.hideToastActivity()
    }
}
