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
    
    private var spaceFilter = {(text: String) -> Bool in text.contains(" ")}
    private var countFilter = {(text: String) -> Bool in text.count < 2 || text.count >= 10}
    private var specialFilter = Resource.Text.specialFilter
    
    
    func filterSpace(_ inputText: String ) -> String? {
        guard spaceFilter(inputText) else {
            return nil
        }
        return Resource.Text.nickNameHaveSpace.message
    }
    
    
    func filterCount(_ inputText: String) -> String? {
        guard countFilter(inputText) else {
            return nil
        }
        return Resource.Text.nickNameCountOver.message
    }
    
    func filterSpecial(_ inputText: String) -> String? {
        let specialStr = inputText.filter({ specialFilter.contains($0) })
        guard specialStr.count > 0 else {
            return nil
        }
        return Resource.Text.nickNameNoSpecial.message
    }
    
    func filterNumber(_ inputText: String) -> String? {
        let numberStr = inputText.filter({ $0.isNumber })
        guard numberStr.count > 0 else {
            return nil
        }
        return Resource.Text.nickNameNoNumber.message
    }
}
