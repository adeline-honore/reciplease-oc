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
    private var searchIngredientView: SearchIngredientView!
    
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
    
    
    // MARK: - Action
    
    @IBAction func didTapAddIngredientButton() {
        addIngredient()
    }
    

    @IBAction func didTapSearchRecipeButton() {
    }
    
    
    
    @IBAction func didTapClearListIngredientButoon() {
    }
    
    
    // MARK: - Private methods
    
    private func addIngredient() {
        
        guard let newIngredient = searchIngredientView.searchIngredientTextField.text else { return }
        
        ingredients.append(newIngredient)
        ingredientTableView.reloadData()
        searchIngredientView.searchIngredientTextField.text = ""
    }
}


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
