//
//  OneRecipeViewController.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 25/06/2022.
//

import UIKit
import CoreData

class OneRecipeViewController: UIViewController {
    
    // MARK: - Properties
    var oneRecipeView: OneRecipeView!
    var oneRecipe: Recipe?
    
    
    @IBOutlet weak var oneRecipeIngredientTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oneRecipeView = view as? OneRecipeView
        oneRecipeIngredientTableView.dataSource = self
        oneRecipeIngredientTableView.delegate = self
        displayOneRecipe()
    }
    
    // MARK: - Display one recipe
    func displayOneRecipe() {
        guard let oneRecipe = oneRecipe else {
            return
        }
        oneRecipeView.oneRecipeTitleLabel.text = oneRecipe.label
        oneRecipeView.oneRecipeTime.text = String(oneRecipe.totalTime)
        oneRecipeView.oneRecipeDatasView.manageDataViewBackground()        
    }
    
    // MARK: - Add Recipe in Favorite
    
    @IBAction func didTapAddAsFavoriteButton() {
        // TODO mettre un toggle ajouter / retirer étoile
        // if coreData ne contient pas ce recipe.label alors :
        
        // sinon:
        //removeAsFavorite(recipe: oneRecipe!)
    }
    
    private func addAsFavorite(recipe: Recipe) {
        let recipeCD = RecipeCD(context: CoreDataStack.sharedInstance.viewContext)
        recipeCD.label = recipe.label
        recipeCD.image = recipe.image
        
        do {
            try CoreDataStack.sharedInstance.viewContext.save()
            print("okkkkk")
        } catch {
            print("pas possible sauvegarder ")
            errorMessage(element: .notSaved)
        }
    }
    
    private func removeAsFavorite(recipe: Hit) {
        
    }
    

    // MARK: - Go to recipe's instructions
    
    
    @IBAction func didTapGoToInstructionsButton() {
        goToInstructions()
    }
    private func goToInstructions() {
        
        guard let oneRecipe = oneRecipe,
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
        
        guard let oneRecipe = oneRecipe else {
            return 0
        }
        let recipesCount = oneRecipe.ingredientLines.count
        return recipesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableViewCell.identifier, for: indexPath) as? IngredientTableViewCell,
              let oneRecipe = oneRecipe else {
                  return UITableViewCell()
              }
        
        cell.ingredient.text = "-  " + oneRecipe.ingredientLines[indexPath.row]
        return cell
    }
}
