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
        static let likeButton = CGFloat(10)
        static let sortingButton = CGFloat(17)
        static let settingProfileImage = CGFloat(40)
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
        static let networkSlash = UIImage(systemName: "network.slash")
        static let wifiExclamationmark = UIImage(systemName: "wifi.exclamationmark")!.withTintColor(Resource.MyColor.white, renderingMode: .alwaysOriginal)
    }
    
    enum NamedImage {
        static let empty = UIImage(named: "empty")
        static let launch = UIImage(named: "launch")
        static let likeSelected = UIImage(named: "like_selected")!.withRenderingMode(.alwaysOriginal)
        static let likeUnselected = UIImage(named: "like_unselected")!.withRenderingMode(.alwaysOriginal)
        static let loadingApple = UIImage (named: "loading_apple")
        
        
        static var randomProfile: UIImage {
            return UIImage(named: "profile_\(Int.random(in: 0...11))")!
        }
        
        static var allProfile: [UIImage] {
            var list: [UIImage] = []
            for i in 0...11 {
                list.append(UIImage(named: "profile_\(i)")!)
            }
            return list
        }
    }
    
    enum IsLike {
        case like
        case unLike
        
        var image: UIImage {
            switch self {
            case .like:
                return NamedImage.likeSelected
            case .unLike:
                return NamedImage.likeUnselected
            }
        }
    }
    
    enum Text {
        static let appTitle = "MyCart"
        static let applicantName = "유철원"
        static let startButton = "시작하기"
        static let guestUser = "guest"
        static let searchTabBar = "검색"
        static let settingTabBar = "설정"
        
        static let profileSetting = "PROFILE SETTING"
        static let nickNamePlaceholder = "닉네임을 입력해주세요 :)"
        static let nickNameSuccess = "사용할 수 있는 닉네임이에요"

        static let mainViewTitle = "님의 MEANING OUT"
        static let noListMessgae = "최근 검색어가 없어요"
        static let searchBarPlaceHolder = "브랜드, 상품 등을 입력하세요"
        static let currentSearched = "최근 검색"
        static let allDelete = "전체 삭제"
        static let searchTotal = "개의 검색결과"
        
        static let settingViewTitle = "SETTING"
        static let saveNewProfile = "저장"
        static let myCartLabel = "나의 장바구니 목록"
        static let myCartCountLabel = "개의 상품"
        static let QnALabel = "자주 묻는 질문"
        static let customerVoiceLabel = "1:1 문의"
        static let notificationLabel = "알림 설정"
        static let secessionLabel = "탈퇴하기"
        static let secessionAlertTitle = "탈퇴하기"
        static let secessionAlertMessage = "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴하시겠습니까?"
        
        static let editProfileTitle = "EDIT PROFILE"
    }
}
