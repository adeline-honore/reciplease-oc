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
    
    @IBOutlet weak var viewTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTitleLabel.text = "Recipes with my ingredients"
        recipesListTableView.dataSource = self
        recipesListTableView.delegate = self
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - Get Images
    
    func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func manageCellApparence(cell: RecipesListTableViewCell) {
        //cell.datasStackView.backgroundColor = Color(red: 0.4627, green: 0.8392, blue: 1.0)
        
        cell.datasView.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 0.5)
        
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
                
        cell.recipesListTitle.text = oneRecipe.recipe.label
        cell.recipesListTotalTime.text = String(oneRecipe.recipe.totalTime)
        cell.recipesListIngredientLines.text = oneRecipe.recipe.ingredientLines.joined(separator: " ")
        
        guard let pictureUrl = URL(string: oneRecipe.recipe.image) else { return UITableViewCell() }
        
        getImageData(from: pictureUrl) { data, response, error in
            guard let data = data, error == nil else { return }
            
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                cell.recipesListImageView.image = UIImage(data: data)
            }
        }
        manageCellApparence(cell: cell)
        return cell
    }
}
