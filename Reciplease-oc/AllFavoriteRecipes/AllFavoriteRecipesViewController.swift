//
//  AllFavoriteRecipesViewController.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 04/07/2022.
//

import UIKit

class AllFavoriteRecipesViewController: AllRecipesViewController {
    
    // MARK: - Properties

    let repository = RecipesCoreDataManager()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My favorite recipes"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavoriteRecipes()
    }
    
    
    // MARK: - Get Favorite Recipes

       private func getFavoriteRecipes() {
           print("eeee")
         repository.getRecipes(completion: { [weak self] favoriteRecipes in
           for favoriteRecipe in favoriteRecipes {
             if let label = favoriteRecipe.label {
                 print(label)
             }
           }
         })
       }
}
