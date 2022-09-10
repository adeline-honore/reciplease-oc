//
//  RecipeUI.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 28/07/2022.
//

import UIKit

struct RecipeUI {
    var title: String
    var imageURL: String
    var imageBinary: Data?
    var image: UIImage?
    var redirection: String
    var ingredientsList : [String]
    var totalTime: Double
    var duration: String
    var isFavorite: Bool
    
    init(recipe: Recipe, duration: String , isFavorite: Bool) {
        title = recipe.label
        imageURL = recipe.image
        redirection = recipe.url
        ingredientsList = recipe.ingredientLines
        totalTime = recipe.totalTime
        self.duration = duration
        self.isFavorite = isFavorite
    }
    
    init(recipeCD: RecipeCD,image: UIImage, isFavorite: Bool) {
        title = recipeCD.label ?? ""
        imageURL = recipeCD.image ?? ""
        self.image = image
        redirection = recipeCD.url ?? ""
        ingredientsList = recipeCD.ingredients ?? [""]
        totalTime = recipeCD.totalTime
        duration = recipeCD.duration ?? ""
        self.isFavorite = isFavorite
    }
    
    func tellRecipeUIInformations() {
        title.accessibilityHint = "The label of recipe"
        title.isAccessibilityElement = true
        
        ingredientsList.joined(separator: ", ").accessibilityHint = "The ingredients of recipe"
        ingredientsList.joined(separator: ", ").isAccessibilityElement = true
        
        duration.accessibilityHint = "The time of recipe is \(totalTime.isZero ? "not mentioned" : "\(totalTime) minutes")"
        
        isFavorite.description.accessibilityHint = " This is\(isFavorite == true ? "" : "not") a favorite recipe"
        
    }
}
