//
//  Array+Extension.swift
//  MyCart
//
//  Created by 유철원 on 7/11/24.
//

import Foundation


extension Array {
    
    func countVector() -> Int? {
        var count = 0
        guard let vector = self as? Array<any Sequence> else {
            return nil
        }
        self.forEach { element in
            var sequence = element as! (any Sequence)
            sequence.forEach { _ in count += 1}
        }
        return count
    }
}
