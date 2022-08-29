//
//  TestCase.swift
//  Reciplease-ocTests
//
//  Created by HONORE Adeline on 29/08/2022.
//

import Foundation

enum TestCase {
    case ingredients
    
    var resource: String {
        switch self {
        case .ingredients:
            return "Ingredients"
        }
    }
}
