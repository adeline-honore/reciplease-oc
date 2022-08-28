//
//  IngredientsViewController.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 29/05/2022.
//

import UIKit

class IngredientsViewController: UIViewController {
    
    // MARK: - Properties
    private var ingredients: [String] = []
    private var ingredientsInString: String = ""
    private var ingredientsView: IngredientsView!
    private var ingredientsService = IngredientsService(network: APINetwork())
    private var segueIngreients = "SegueFromIngredientsToAllRecipes"
    private var allRecipes = [Recipe]()
    
    // MARK: - Outlet
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsView = view as? IngredientsView
        ingredientsView.activityIndicator.isHidden = true
        navigationItem.title = "My ingredients"
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
    }
    
    // MARK: - Add ingredients
    
    @IBAction func didTapAddIngredientButton() {
        addIngredient()
    }
    
    private func addIngredient() {
        
        guard var newIngredient = ingredientsView.searchIngredientTextField.text else { return }
        
        newIngredient = newIngredient.trimmingCharacters(in: .whitespaces).lowercased()
                
        // method to test newIngredient characters
        let isValid = validateString(text: newIngredient, with: #"^[a-z]+$"#)
        
        if isValid && !newIngredient.isEmpty {
            ingredients.append(newIngredient)
            ingredientsTableView.reloadData()
            ingredientsView.searchIngredientTextField.text?.removeAll()
        } else if newIngredient.isEmpty {
            ingredientsView.searchIngredientTextField.text?.removeAll()
            errorMessage(element: .empty)
        } else if !isValid {
            errorMessage(element: .notAWord)
            ingredientsView.searchIngredientTextField.text?.removeAll()
        }
    }
    
    
    private func validateString(text: String, with regex: String) -> Bool {
            // Create the regex
            guard let gRegex = try? NSRegularExpression(pattern: regex) else {
                return false
            }
            // Create the range
            let range = NSRange(location: 0, length: text.utf16.count)
            // Perform the test
            if gRegex.firstMatch(in: text, options: [], range: range) != nil {
                return true
            }
            return false
    }
    
    // MARK: - Search Recipes
    @IBAction func didTapSearchRecipeButton() {
        searchRecipes(list: ingredients.joined(separator: "-"))
    }
    
    private func searchRecipes(list: String) {
        ingredientsTableView.isHidden = true
        ingredientsView.activityIndicator.isHidden = false
        
        ingredientsService.getData(ingredients: list) { result in
            DispatchQueue.main.async { [weak self] in
                
                switch result {
                case .success(let arrayOfHits):
                    self?.sendListOfRecipes(list: arrayOfHits)
                case .failure(let error):
                    self?.errorMessage(element: error)
                }
            }
        }
    }
    
    // MARK: - Send Recipes to AllRecipesViewController
    private func sendListOfRecipes(list: [Recipe]) {
        ingredientsTableView.isHidden = false
        ingredientsView.activityIndicator.isHidden = true
        
        if !list.isEmpty {
            allRecipes = list
            performSegue(withIdentifier: segueIngreients, sender: nil)
        } else {
            errorMessage(element: .noRecipe)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIngreients {
            let allRecipesVC = segue.destination as? AllRecipesViewController
            
            allRecipesVC?.recipes = allRecipes
        }
    }
    
    
    // MARK: - Clear List of Ingredients
    @IBAction func didTapClearListIngredientButoon() {
        clearIngredients()
    }
    
    private func clearIngredients() {
        ingredients.removeAll()
        ingredientsInString.removeAll()
        ingredientsTableView.reloadData()
    }
}

// MARK: - Extension of IngredientsViewController
extension IngredientsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientsTableViewCell.identifier, for: indexPath) as? IngredientsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.ingredient.text = "-  " + ingredients[indexPath.row]
        return cell
    }
}
