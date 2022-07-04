//
//  AllRecipesViewController.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 07/06/2022.
//

import UIKit

protocol AllRecipesViewControllerDelegate: AnyObject {
    func didSelectRecipe(_ recipe: Hit)
}

class AllRecipesViewController: UIViewController {
    
    // MARK: - Properties
    
    var recipes: [Recipe]?
    var delegate: AllRecipesViewControllerDelegate?
    var oneRecipe: Recipe?
    private var segueShowOneRecipe = "SegueFromAllToOneRecipe"
    var n = 0
    
    
    // MARK: - Outlet
    
    @IBOutlet weak var recipesListTableView: UITableView!
    
    @IBOutlet weak var viewTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTitleLabel.text = "Recipes with my ingredients"
        recipesListTableView.dataSource = self
        recipesListTableView.delegate = self
    }
    
    
    // MARK: - Get Images
    
    func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    // MARK: - Send One Recipe to OneRecipeViewController
    private func sendOneRecipe(recipe: Recipe) {
        oneRecipe = recipe
        performSegue(withIdentifier: segueShowOneRecipe, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueShowOneRecipe {
            let oneRecipeVC = segue.destination as? OneRecipeViewController
            
            oneRecipeVC?.oneRecipe = oneRecipe
        }
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
        
        cell.recipesListTitle.text = oneRecipe.label
        cell.recipesListTotalTime.text = String(oneRecipe.totalTime)
        cell.recipesListIngredientLines.text = oneRecipe.ingredientLines.joined(separator: " ")
        
        guard let pictureUrl = URL(string: oneRecipe.image) else { return UITableViewCell() }
        
        getImageData(from: pictureUrl) { data, response, error in
            guard let data = data, error == nil else { return }
            
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                guard let imageRecipe = UIImage(data: data) else {
                    return
                }
                cell.recipesListImageView.image = imageRecipe
            }
        }
        cell.datasView.manageDataViewBackground()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let recipes = recipes else { return }
        let recipesSelectRow = recipes[indexPath.row]
        sendOneRecipe(recipe: recipesSelectRow)
    }
}


extension UIView {
    func manageDataViewBackground() {
        self.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 0.5)
    }
}
