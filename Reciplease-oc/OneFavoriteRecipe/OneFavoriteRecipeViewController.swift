//
//  OneFavoriteRecipeViewController.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 26/07/2022.
//

import UIKit

class OneFavoriteRecipeViewController: OneRecipeViewController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oneRecipeView = view as? OneRecipeView
        displayRecipe()
        oneRecipeIngredientTableView.dataSource = self
        oneRecipeIngredientTableView.delegate = self
    }
}
