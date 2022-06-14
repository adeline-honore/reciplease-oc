//
//  ErrorType.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 14/06/2022.
//

import Foundation

enum ErrorType: Error {
    case decodingError
    case empty
    case network
    case noRecipe
    // TODO : create error " device no connected"
    
    
    var message: String {
        switch self {
        case .decodingError:
            return "Oups!, error of decode"
        case .empty:
            return "Text field is empty, please enter ingredient"
        case .network:
            return "Oups!, no return from API ."
        case .noRecipe:
            return "Oups!, there is no recipe with this (thoose) ingredient(s)"
        }
    }
}
