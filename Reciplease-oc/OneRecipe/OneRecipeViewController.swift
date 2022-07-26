//
//  OneRecipeViewController.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 25/06/2022.
//

import UIKit

class OneRecipeViewController: UIViewController {
    
    // MARK: - Properties
    
    var oneRecipeView: OneRecipeView!
    var recipe: Recipe?
    let repository = RecipesCoreDataManager()
    
    
    @IBOutlet weak var oneRecipeIngredientTableView: UITableView!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oneRecipeView = view as? OneRecipeView
        oneRecipeIngredientTableView.dataSource = self
        oneRecipeIngredientTableView.delegate = self
        displayRecipe()
    }
    
    
    // MARK: - Display one recipe
    
    func displayRecipe() {
        guard let oneRecipe = recipe,
              let favoriteStar = oneRecipeView.favoriteStarButton.imageView else {
            return
        }
        oneRecipeView.oneRecipeTitleLabel.text = oneRecipe.label
        oneRecipeView.oneRecipeTime.text = String(manageTimeDouble(time: oneRecipe.totalTime)) + " mn  "
        oneRecipeView.oneRecipeDatasView.manageDataViewBackground()
        manageFavoriteStar(imageView: favoriteStar, isFavorite: repository.isItFavorite(urlString: oneRecipe.url))
        manageTimeView(time: oneRecipe.totalTime, labelView: oneRecipeView.oneRecipeTime, clockView: oneRecipeView.oneRecipeClock, infoStack: oneRecipeView.infoStack)
    }
    
    
    // MARK: - Add Recipe in Favorite
    
    @IBAction func didTapFavoriteButton() {
        toggleFavorite()
    }
    
    func toggleFavorite() {
        guard let recipe = recipe,
              let favoriteStar = oneRecipeView.favoriteStarButton.imageView else {
            return
        }
        
        var isFavoriteRecipe = repository.isItFavorite(urlString: recipe.url)
        
        if isFavoriteRecipe { // if recipe is saved in Coredata then delete it
            
        } else { // if recipe isn't saved in Coredata then save it
            do {
                try repository.addAsFavorite(recipeToSave: recipe)
                isFavoriteRecipe = true
                manageFavoriteStar(imageView: favoriteStar, isFavorite: true)
                informationMessage(element: .savedAsFavorite)
                
            } catch {
                errorMessage(element: .notSaved)
            }
        }
    }
    

    // MARK: - Go to recipe's instructions
    
    @IBAction func didTapGoToInstructionsButton() {
        goToInstructions()
    }
    private func goToInstructions() {
        
        guard let oneRecipe = recipe,
              let instructionUrl = URL(string: oneRecipe.url) else { return }
        
        if !oneRecipe.url.isEmpty {
            UIApplication.shared.open(instructionUrl, options: [:], completionHandler: nil)
        } else {
            errorMessage(element: .noInstruction)
        }
    }
    
}


// MARK: - Extension of OneRecipeViewController
extension OneRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let recipe = recipe else {
            return 0
        }
        let recipesCount = recipe.ingredientLines.count
        return recipesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableViewCell.identifier, for: indexPath) as? IngredientTableViewCell,
              let recipe = recipe else {
                  return UITableViewCell()
              }
        
        cell.ingredient.text = "-  " + recipe.ingredientLines[indexPath.row]
        return cell
    }
}
