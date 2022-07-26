//
//  AllFavoriteRecipesViewController.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 04/07/2022.
//

import UIKit

class AllFavoriteRecipesViewController: AllRecipesViewController {
    
    private var segueShowOneFavoriteRecipe = "SegueFromAllToOneFavoriteRecipe"
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My favorite recipes"
        recipesTableView.dataSource = self
        recipesTableView.delegate = self
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavoriteRecipes()
    }
    
    
    // MARK: - Get Favorite Recipes
    
    private func getFavoriteRecipes() {
        
        do {
            recipesCD = try repository.getRecipes()
            if let recipesCD = recipesCD {
                recipes = repository.getRecipesFromEntities(entities: recipesCD)
            }
        } catch {
            errorMessage(element: .coredataError)
        }
    }
    
    // MARK: - Send One Recipe to OneRecipeViewController
    func sendOneFavoriteRecipe(recipe: Recipe) {
        oneRecipe = recipe
        performSegue(withIdentifier: segueShowOneFavoriteRecipe, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueShowOneFavoriteRecipe {
            let oneFavoriteRecipeVC = segue.destination as? OneFavoriteRecipeViewController
            
            oneFavoriteRecipeVC?.recipe = oneRecipe
        }
    }
}


// MARK: - Extension of AllRecipesViewController
extension AllFavoriteRecipesViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let recipes = recipes else { return }
        let recipesSelectRow = recipes[indexPath.row]
        sendOneFavoriteRecipe(recipe: recipesSelectRow)
    }
}
