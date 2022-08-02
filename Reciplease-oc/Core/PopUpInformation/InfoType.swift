//
//  InfoType.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 04/07/2022.
//

import Foundation

enum InfoType {
    case savedAsFavorite
    case deleteFromFavorite
    case noFavoriteRecipe
    
    var message: String {
        switch self {
        case .savedAsFavorite:
            return "This recipe is saved as favorite"
        case .deleteFromFavorite:
            return "This recipe is no longer part of your favorites"
        case .noFavoriteRecipe:
            return "Oups ! You haven't got favorite recipe"
        }
    }
}
