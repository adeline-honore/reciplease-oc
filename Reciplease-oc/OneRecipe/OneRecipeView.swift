//
//  OneRecipeView.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 25/06/2022.
//

import UIKit

class OneRecipeView: UIView {

    @IBOutlet weak var oneRecipeImageView: UIImageView!
    
    @IBOutlet weak var oneRecipeTitleLabel: UILabel!
    
    @IBOutlet weak var oneRecipeTime: UILabel!
    
    @IBOutlet weak var oneRecipeDatasView: UIView!
    
    @IBOutlet weak var favoriteStarButton: UIButton!
    
    static let identifier = "ingredientTableViewCell"
}
