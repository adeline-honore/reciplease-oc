//
//  RecipeUI.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 28/07/2022.
//

import Foundation
import UIKit

struct RecipeUI {
    var id: String?
    var title: String
    var imageURL: String
    var imageBianry: Data?
    var image: UIImage?
    var redirection: String
    var ingredientsList : [String]
    var totalTime: Double
    var duration: String
    var isFavorite: Bool
    
    init() {
        title = ""
        imageURL = ""
        redirection = ""
        ingredientsList = [""]
        totalTime = 0.0
        duration = ""
        isFavorite = false
    }
}
