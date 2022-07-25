//
//  AllFavoriteRecipesViewController.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 04/07/2022.
//

import UIKit

class AllFavoriteRecipesViewController: AllRecipesViewController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My favorite recipes"
        recipesTableView.dataSource = self
        recipesTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavoriteRecipes()
    }
    
    
    // MARK: - Get Favorite Recipes
    
    private func getFavoriteRecipes() {
        
        do {
            recipesCD = try repository.getRecipes()
        } catch {
            errorMessage(element: .coredataError)
        }
    }
    
}



// MARK: - Extension of AllRecipesViewController
extension AllFavoriteRecipesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipesCount = recipesCD?.count else {
            return 0
        }
        return recipesCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier) as? RecipeTableViewCell ?? RecipeTableViewCell()
        
        guard let recipesCD = recipesCD else { return UITableViewCell()}
        
        let oneRecipeCD = recipesCD[indexPath.row]
        
        guard let cellTitle = oneRecipeCD.label else { return RecipeTableViewCell() }
        
        cell.titleCell.text = cellTitle
        
        cell.datasViewCell.manageDataViewBackground()
        
        manageFavoriteStar(imageView: cell.favoriteStar, isFavorite: true)
        
        return cell
    }
}
