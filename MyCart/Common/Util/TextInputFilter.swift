//
//  NickNameFilter.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import Foundation

class TextInputFilter {
    
    private init() {}
    
    static let filter = TextInputFilter()
    
    // 걸러내야 할 케이스를 클로저 내부에 조건으로 설정
    private var spaceFilter = {(text: String) -> Bool in text != (text.trimmingCharacters(in: .whitespacesAndNewlines))
                                                         || (text.filter{ $0.isWhitespace}.count > 1)}
    private var countFilter = {(text: String) -> Bool in text.count < 2 || text.count >= 10}
    private var specialFilter = Resource.Text.specialFilter
    
    
    func filterSpace(_ inputText: String ) -> String? {
        guard spaceFilter(inputText) else {
            return nil
        }
        return StatusMessage.NickNameFilterError.haveSpace.message
    }
    
    
    func filterCount(_ inputText: String) -> String? {
        guard countFilter(inputText) else {
            return nil
        }
        return StatusMessage.NickNameFilterError.countOver.message
    }
    
    func filterSpecial(_ inputText: String) -> String? {
        let specialStr = inputText.filter({ specialFilter.contains($0) })
        guard specialStr.count > 0 else {
            return nil
        }
        return StatusMessage.NickNameFilterError.haveSpecial.message
    }
    
    func filterNumber(_ inputText: String) -> String? {
        let numberStr = inputText.filter({ $0.isNumber })
        guard numberStr.count > 0 else {
            return nil
        }
        return StatusMessage.NickNameFilterError.haveNumber.message
    }
}
