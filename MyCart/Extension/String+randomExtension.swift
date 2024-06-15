//
//  String+randomExtension.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import Foundation


extension String {

    func createRandomStr(length: Int) -> String {
        let str = (0 ..< length).map{ _ in self.randomElement()! }
        return String(str)
    }
    
}
