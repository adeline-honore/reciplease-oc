//
//  OneRecipeView.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 25/06/2022.
//

import UIKit

class OneRecipeView: UIView {

    @IBOutlet weak var imageview: UIImageView!
        
    @IBOutlet weak var timeLabel: UILabel!
        
    @IBOutlet weak var favoriteStarButton: UIButton!
    
    @IBOutlet weak var clockImageView: UIImageView!
    
    @IBOutlet weak var infoStack: UIStackView!
    
    @IBOutlet weak var goToInstructionsButton: UIButton!
    
    static let identifier = "ingredientTableViewCell"
}


extension OneRecipeView {
    func configureAccessibility(recipe: RecipeUI) {
        
        favoriteStarButton.accessibilityLabel = recipe.getAccessibilityOnFavorite(isFavorite: recipe.isFavorite)
        favoriteStarButton.accessibilityHint = "Press Favorite Button to add or remove this recipe as favorite"
        
        timeLabel.accessibilityLabel = recipe.getAccessibilityOnTime()
        
        goToInstructionsButton.accessibilityHint = "Press Intructions Button to go to recipe's instructions"
    }
    
    func configure(recipe: RecipeUI) {
        
        timeLabel.text = recipe.duration
        imageview.image = recipe.image
        
        manageTimeView(time: recipe.totalTime, timeLabel: timeLabel, clockView: clockImageView, infoStack: infoStack)
        
        manageFavoriteStarButton(button: favoriteStarButton, isFavorite: recipe.isFavorite)
    }
}
