//
//  OneRecipeViewController.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 25/06/2022.
//

import UIKit

protocol OneRecipeViewControllerDelegate: AnyObject {
    func didChangeFavoriteState(urlRedirection: String, recipeChanged: RecipeUI)
}

class OneRecipeViewController: UIViewController {
    
    // MARK: - Properties
    
    var recipeUI: RecipeUI?
    var recipesUI: [RecipeUI]?
    var recipesUIIndex: Int?
    weak var delegate: OneRecipeViewControllerDelegate?
    private var oneRecipeView: OneRecipeView!
    let repository = RecipesCoreDataManager(
        coreDataStack: CoreDataStack(),
        managedObjectContext: CoreDataStack().viewContext)
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var oneRecipeIngredientTableView: UITableView!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oneRecipeIngredientTableView.dataSource = self
        oneRecipeIngredientTableView.delegate = self
    }
    
    override func loadView() {
        super.loadView()
        oneRecipeView = view as? OneRecipeView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let recipesUIIndex = recipesUIIndex,
              let recipesUI = recipesUI else {
            return
        }
        
        recipeUI = recipesUI[recipesUIIndex]
        
        guard let oneRecipe = recipeUI else { return }
        displayRecipe(recipe: oneRecipe)
    }
    
    
    // MARK: - Display one recipe
    
    private func displayRecipe(recipe: RecipeUI) {
      
        navigationItem.title = recipe.title
        
        UIAccessibility.post(notification: .screenChanged, argument: navigationItem)
        oneRecipeView.configureAccessibility(recipe: recipe)
        oneRecipeView.configure(recipe: recipe)
        
    }
    
    
    // MARK: - Add and Remove Recipe as Favorite
    
    @IBAction func didTapFavoriteButton() {
        toggleFavorite()
    }
    
    private func toggleFavorite() {
        guard var recipe = recipeUI else {
            return
        }
                
        if recipe.isFavorite { // if recipe is saved in Coredata then delete it
            do {
                try repository.removeAsFavorite(urlRedirection: recipe.redirection)
                recipe.isFavorite = false
                informationMessage(element: .deleteFromFavorite)
            } catch {
                errorMessage(element: .coredataError)
            }
        } else { // if recipe isn't saved in Coredata then save it
            recipe.imageBinary = oneRecipeView.imageview.image?.jpegData(compressionQuality: 1.0)
            do {
                try repository.addAsFavorite(recipeToSave: recipe)
                recipe.isFavorite = true
                informationMessage(element: .savedAsFavorite)
            } catch {
                errorMessage(element: .notSaved)
            }
        }
        
        delegate?.didChangeFavoriteState(urlRedirection: recipe.redirection, recipeChanged: recipe)
        
        oneRecipeView.manageFavoriteStarButton(button: oneRecipeView.favoriteStarButton, isFavorite: recipe.isFavorite)
        recipeUI = recipe
    }
    

    // MARK: - Go to recipe's instructions
    
    @IBAction func didTapGoToInstructionsButton() {
        goToInstructions()
    }
    private func goToInstructions() {
        
        guard let oneRecipe = recipeUI,
              let instructionUrl = URL(string: oneRecipe.redirection) else { return }
        
        if !oneRecipe.redirection.isEmpty {
            UIApplication.shared.open(instructionUrl, options: [:], completionHandler: nil)
        } else {
            errorMessage(element: .noInstruction)
        }
    }
    
}


// MARK: - Extension of OneRecipeViewController
extension OneRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipeUI = recipeUI else {
            return 0
        }
        return recipeUI.ingredientsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientsTableViewCell.identifier, for: indexPath) as? IngredientsTableViewCell,
              let recipeUI = recipeUI else {
                  return UITableViewCell()
              }
        
        cell.ingredient.text = "-  " + recipeUI.ingredientsList[indexPath.row]
        return cell
    }
}
