//
//  Resource.swift
//  MyCart
//
//  Created by 유철원 on 6/14/24.
//

import UIKit


enum Resource {
    enum Font {
        static let system13 = UIFont.systemFont(ofSize: 13)
        static let system14 = UIFont.systemFont(ofSize: 14)
        static let system15 = UIFont.systemFont(ofSize: 15)
        static let system16 = UIFont.systemFont(ofSize: 16)
        static let boldSystem13 = UIFont.boldSystemFont(ofSize: 13)
        static let boldSystem14 = UIFont.boldSystemFont(ofSize: 14)
        static let boldSystem15 = UIFont.boldSystemFont(ofSize: 15)
        static let boldSystem16 = UIFont.boldSystemFont(ofSize: 16)
    }
    
    enum MyColor {
        static let orange = UIColor(hexCode: "EF8947", alpha: Alpha.full)
        static let white = UIColor(hexCode: "FFFFFF", alpha: Alpha.full)
        static let lightGray = UIColor(hexCode: "CDCDCD", alpha: Alpha.full)
        static let gray = UIColor(hexCode: "828282", alpha: Alpha.full)
        static let darkGray = UIColor(hexCode: "4C4C4C", alpha: Alpha.full)
        static let black = UIColor(hexCode: "000000", alpha: Alpha.full)
    }
    
    enum Alpha {
        static let full = CGFloat(1.0)
        static let half = CGFloat(0.5)
    }
    
    enum Border {
        static let widthZero = CGFloat(0)
        static let width1 = CGFloat(1)
        static let width3 = CGFloat(3)
    }
    
    enum CornerRadious {
        static let startButton = CGFloat(30)
        
        static let profileImageView = CGFloat(60)
        static let cameraIcon = CGFloat(15)
        
        static let searchImage = CGFloat(16)
        static let likeButton = CGFloat(6)
        static let sortingButton = CGFloat(17)
    }
    
    enum SystemImage {
        static let cameraFill = UIImage(systemName: "camera.fill")
        static let cart = UIImage(systemName: "cart")
        static let cartFill = UIImage(systemName: "cart.fill")
        static let chevronRight = UIImage(systemName: "chevron.right")
        static let clock = UIImage(systemName: "clock")
        static let magnifyingGlass = UIImage(systemName: "magnifyingglass")
        static let xmark = UIImage(systemName: "xmark")
        static let person = UIImage(systemName: "person")
    }
    
    enum NamedImage {
        static let empty = UIImage(named: "empty")
        static let launch = UIImage(named: "launch")
        static let likeSelected = UIImage(named: "like_selected")
        static let likeUnselected = UIImage(named: "like_unselected")
        
        static var profile: UIImage {
            return UIImage(named: "profile_\(Int.random(in: 0...11))")!
        }
    }
    
    enum Text {
        case nickNameNoSpecial
        case nickNameNoNumber
        case nickNameCountOver
        case nickNameSuccess
       
        static let appTitle = "MyCart"
        static let applicantName = "유철원"
        static let startButton = "시작하기"
        static let guestUser = "guest"
        static let searchTabBar = "검색"
        static let settingTabBar = "설정"
        
        static let nickNamePlaceholder = "닉네임을 입력해주세요 :)"
        static let specialFilter = "@#$%"
        
        static let searchTotal = "개의 검색결과"
       
        var message: String {
            switch self {
            case .nickNameNoSpecial:
                return "닉네임에 @, #, $, %는 포함할 수 없어요"
            case .nickNameNoNumber:
                return "닉네임에 숫자는 포함할 수 없어요"
            case .nickNameCountOver:
                return "2글자 이상 10글자 미만으로 설정해주세요"
            case .nickNameSuccess:
                return "사용할 수 있는 닉네임이에요"
            }
        }
    }
}
