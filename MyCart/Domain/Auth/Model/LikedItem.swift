//
//  LikedItem.swift
//  MyCart
//
//  Created by 유철원 on 7/9/24.
//

import Foundation
import RealmSwift


class LikedItem: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var productId: String
    @Persisted var link: String
    @Persisted var image: String
    @Persisted var mallName: String
    @Persisted var title: String
    @Persisted var lprice: String
    @Persisted var regDate: Date

    @Persisted(originProperty: User.Column.likedList.name) var main: LinkingObjects<User>
    
    convenience init(productId: String, link: String, image: String, mallName: String, title: String, lprice: String, regDate: Date, main: LinkingObjects<User>) {
        self.init()
        self.productId = productId
        self.link = link
        self.image = image
        self.mallName = mallName
        self.title = title
        self.lprice = lprice
        self.regDate = regDate
    }
    
    enum Column: String, ColumnManager {
        case id
        case productId
        case link
        case image
        case mallName
        case title
        case lprice
        case main
        case regDate
        
        var name: String {
            return self.rawValue
        }
        
        var krName: String  {
            return switch self {
            case .id:
                "아이디"
            case .productId:
                "상품 아이디"
            case .link:
                "상품 링크"
            case .image:
                "상품 사진"
            case .mallName:
                "쇼핑몰 이름"
            case .title:
                "상품 이름"
            case .lprice:
                "상품 가격"
            case .main:
                "부모 객체"
            case .regDate:
                "등록일"
            }
        }
        var inputErrorMessage: String {
            return "\(self.krName) 값이 없거나 유효하지 않습니다."
        }
        
        var updatePropertySuccessMessage: String {
            return "\(self.krName) 의 수정이 완료되었습니다."
        }
        
        var updatePropertyErrorMessage: String {
            return "\(self.krName) 의 수정에 실패하였습니다."
        }
    }
}
