//
//  ViewController.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 29/05/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    var ingredients: [String] = []
    private var ingredientsInString: String = ""
    private var searchIngredientView: SearchIngredientView!
    private var searchRecipesService = SearchIngredientsService(network: APINetwork())
    private var segueSearch = "SegueFromSearchToAllRecipes"
    private var allRecipes = [Recipe]()
    
    // MARK: - Outlet
    
    @IBOutlet weak var ingredientTableView: UITableView!
    
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchIngredientView = view as? SearchIngredientView
        navigationItem.title = "My ingredients"
        ingredientTableView.dataSource = self
        ingredientTableView.delegate = self
    }
    
    // MARK: - Add ingredients
    
    @IBAction func didTapAddIngredientButton() {
        addIngredient()
    }
    
    private func addIngredient() {
        
        guard var newIngredient = searchIngredientView.searchIngredientTextField.text else { return }
        
        newIngredient = newIngredient.trimmingCharacters(in: .whitespaces).lowercased()
                
        // method to test newIngredient characters
        let isValid = validateString(text: newIngredient, with: #"^[a-z]+$"#)
        
        if isValid && !newIngredient.isEmpty {
            ingredients.append(newIngredient)
            ingredientTableView.reloadData()
            searchIngredientView.searchIngredientTextField.text?.removeAll()
        } else if newIngredient.isEmpty {
            searchIngredientView.searchIngredientTextField.text?.removeAll()
            errorMessage(element: .empty)
        } else if !isValid {
            errorMessage(element: .notAWord)
            searchIngredientView.searchIngredientTextField.text?.removeAll()
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
        
        searchRecipesService.getData(ingredients: list) { result in
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
        if !list.isEmpty {
            allRecipes = list
            performSegue(withIdentifier: segueSearch, sender: nil)
        } else {
            errorMessage(element: .noRecipe)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueSearch {
            let allRecipesVC = segue.destination as? AllRecipesViewController
            
            allRecipesVC?.recipesStructure = allRecipes
        }
    }
    
    
    // MARK: - Clear List of Ingredients
    @IBAction func didTapClearListIngredientButoon() {
        clearIngredients()
    }
    
    private func clearIngredients() {
        ingredients.removeAll()
        ingredientsInString.removeAll()
        ingredientTableView.reloadData()
    }
}

// MARK: - Extension of SearchViewController
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableViewCell.identifier, for: indexPath) as? IngredientTableViewCell else {
            return UITableViewCell()
        }
        
        cell.ingredient.text = "-  " + ingredients[indexPath.row]
        return cell
    }
}
