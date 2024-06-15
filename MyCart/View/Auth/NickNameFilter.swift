//
//  NickNameFilter.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import Foundation

class NickNameFilter {
    
    private init() {}
    
    static let filter = NickNameFilter()
    
    private var countFilter = {(text: String) -> Bool in text.count < 2 || text.count >= 10}
    private var specialFilter = Resource.Text.specialFilter
    
    func filterCount(_ inputText: String) -> String? {
        if countFilter(inputText) {
            return Resource.Text.nickNameCountOver.message
        }
        return nil
    }
    
    func filterSpecial(_ inputText: String) -> String? {
        let specialStr = inputText.filter({ specialFilter.contains($0) })
        if specialStr.count > 0 {
            return Resource.Text.nickNameNoSpecial.message
        }
        return nil
    }
    
    func filterNumber(_ inputText: String) -> String? {
        let numberStr = inputText.filter({ $0.isNumber })
        if numberStr.count > 0 {
            return Resource.Text.nickNameNoNumber.message
        }
        return nil
    }
    

}
