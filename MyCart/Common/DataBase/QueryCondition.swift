//
//  QueryConditions.swift
//  MyCart
//
//  Created by 유철원 on 7/22/24.
//

import Foundation


enum QueryCondition: String {
    case contains
    case equals
    
    var value: String {
        return switch self {
        case .contains:
            "CONTAINS[c]"
        case .equals:
            "=="
        }
    }
}
