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
    case noInstruction
    case noRecipe
    case notAWord
    case notSaved
    case coredataError
    // TODO : create error " device no connected"
    
    
    var message: String {
        switch self {
        case .decodingError:
            return "Oups!, error of decode"
        case .empty:
            return "Text field is empty, please enter ingredient"
        case .network:
            return "Oups!, error happens ."
        case .noInstruction:
            return "Oups!, there isn't not instruction for this recipe"
        case .noRecipe:
            return "Oups!, there is no recipe with this (thoose) ingredient(s)"
        case .notAWord:
            return "Oups!, word not accepted"
        case .notSaved:
            return "Oups! this recipe is unabled to be saved"
        case .coredataError:
            return "Oups!, an error occured from database"
        }
    }
}
