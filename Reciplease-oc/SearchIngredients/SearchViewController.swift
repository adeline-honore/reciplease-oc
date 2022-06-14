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
    var searchRecipesService = SearchIngredientsService(network: APINetwork())
    private var segueSearch = "SegueFromSearchToAllRecipes"
    var allRecipesArray = [Hit]()
    
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
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueSearch {
            let allRecipesVC = segue.destination as? AllRecipesViewController
            
            let recipes = sender as? [Hit]
            allRecipesVC?.recipes = recipes
        }
    }
    
    // MARK: - Add ingredients
    
    @IBAction func didTapAddIngredientButton() {
        addIngredient()
    }
    
    private func addIngredient() {
        
        guard var newIngredient = searchIngredientView.searchIngredientTextField.text else { return }
        
        newIngredient = newIngredient.trimmingCharacters(in: .whitespaces)
        
        // TODO create regex to test newIngredient
        
        if !newIngredient.isEmpty {
            ingredients.append(newIngredient)
            ingredientTableView.reloadData()
            searchIngredientView.searchIngredientTextField.text = ""
        } else {
            searchIngredientView.searchIngredientTextField.text = ""
            errorMessage(element: .empty)
        }
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
    
    private func sendListOfRecipes(list: [Hit]) {
        if !list.isEmpty {
            allRecipesArray = list
        } else {
            errorMessage(element: .noRecipe)
        }
    }
    
    // MARK: - Clear List of Ingredients
    @IBAction func didTapClearListIngredientButoon() {
        clearIngredients()
    }
    
    private func clearIngredients() {
        ingredients = [""]
        ingredientsInString = ""
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
        
        cell.ingredient.text = ingredients[indexPath.row]
        return cell
    }
}
