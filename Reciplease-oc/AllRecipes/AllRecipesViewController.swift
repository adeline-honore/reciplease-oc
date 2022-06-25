//
//  AllRecipesViewController.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 07/06/2022.
//

import UIKit

class AllRecipesViewController: UIViewController {
    
    // MARK: - Properties
    
    var recipes: [Hit]?
    
    
    // MARK: - Outlet
    
    @IBOutlet weak var recipesListTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipesListTableView.dataSource = self
        recipesListTableView.delegate = self
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}


// MARK: - Extension of AllRecipesViewController
extension AllRecipesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipesCount = recipes?.count else {
            return 0
        }
        return recipesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipesListTableViewCell.identifier, for: indexPath) as? RecipesListTableViewCell else {
            return UITableViewCell()
        }
        guard let recipes = recipes else { return UITableViewCell()}
        
        let oneRecipe = recipes[indexPath.row]
        
        let imageString = oneRecipe.recipe.image
        
        cell.recipesListTitle.text = oneRecipe.recipe.label
        cell.recipesListTotalTime.text = String(oneRecipe.recipe.totalTime)
        cell.recipesListIngredientLines.text = oneRecipe.recipe.ingredientLines.joined(separator: " ")
        
        return cell
    }
}
