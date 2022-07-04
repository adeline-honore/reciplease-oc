//
//  InfoType.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 04/07/2022.
//

import Foundation

enum InfoType {
    case savedAsFavorite
    
    var message: String {
        switch self {
        case .savedAsFavorite:
            return "This recipe is saved as favorite"
        }
    }
}
