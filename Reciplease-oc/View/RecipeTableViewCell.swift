//
//  RecipeTableViewCell.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 08/07/2022.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageview: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var clockImageView: UIImageView!
    
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    @IBOutlet weak var datasView: UIView!
    
    @IBOutlet weak var favoriteStarImageView: UIImageView!
    
    @IBOutlet weak var infoStackView: UIStackView!
    
    
    static let identifier = "recipeCellIdentifier"
    
    
    // MARK: - Life
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = bounds
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(recipe: RecipeUI) {
        titleLabel.text = recipe.title
        timeLabel.text = recipe.duration
        ingredientsLabel.text = recipe.ingredientsList.joined(separator: ", ")
        imageview.image = recipe.image
        
        configureAccessibility(recipe: recipe)
        
        manageFavoriteStarImageView(imageView: favoriteStarImageView, isFavorite: recipe.isFavorite)
        
        manageTimeView(time: recipe.totalTime, timeLabel: timeLabel, clockView: clockImageView, infoStack: infoStackView)
        
        datasView.manageDataViewBackground()
    }
}


extension RecipeTableViewCell {
    func configureAccessibility(recipe: RecipeUI) {
        imageview.isAccessibilityElement = false
        titleLabel.isAccessibilityElement = false
        clockImageView.isAccessibilityElement = false
        ingredientsLabel.isAccessibilityElement = false
        favoriteStarImageView.isAccessibilityElement = false
        
        isAccessibilityElement = true
        
        accessibilityLabel = recipe.getAccessibility()
    }
}
