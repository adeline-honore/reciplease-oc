//
//  AllRecipesViewController.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 07/06/2022.
//

import UIKit

protocol AllRecipesViewControllerDelegate: AnyObject {
    func didSelectRecipe(_ recipe: Recipe)
}

class AllRecipesViewController: UIViewController {
    
    // MARK: - Properties
    
    var recipes: [Recipe]?
    var delegate: AllRecipesViewControllerDelegate?
    var oneRecipe: Recipe?
    private var segueShowOneRecipe = "SegueFromAllToOneRecipe"
    
    var recipesCD: [RecipeCD]?
    let repository = RecipesCoreDataManager()
    
    // MARK: - Outlet
    
    @IBOutlet weak var recipesListTableView: UITableView!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recipes with my ingredients"
        recipesListTableView.dataSource = self
        recipesListTableView.delegate = self
    }
    
    
    // MARK: - Get Images
    
    func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    // MARK: - Send One Recipe to OneRecipeViewController
    func sendOneRecipe(recipe: Recipe) {
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
        
        var cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier) as? RecipeTableViewCell ?? RecipeTableViewCell()
                    
        tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: .main), forCellReuseIdentifier: RecipeTableViewCell.identifier)
        
        cell = RecipeTableViewCell.createCell() ?? RecipeTableViewCell()
        
        guard let recipes = recipes else { return UITableViewCell()}
        
        let oneRecipe = recipes[indexPath.row]
                
        cell.titleRecipeCell.text = oneRecipe.label
        cell.timeRecipeCell.text = String(oneRecipe.totalTime)
        cell.ingredientsRecipeCell.text = oneRecipe.ingredientLines.joined(separator: " ")
        
        guard let pictureUrl = URL(string: oneRecipe.image) else { return UITableViewCell() }
        
        getImageData(from: pictureUrl) { data, response, error in
            guard let data = data, error == nil else { return }
            
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                guard let imageRecipe = UIImage(data: data) else {
                    return
                }
                cell.imageRecipeCell.image = imageRecipe
            }
        }
        cell.datasViewRecipeCell.manageDataViewBackground()
        manageFavoriteStar(imageView: cell.favoriteStar, isFavaorite: isFavoriteRecipe(recipeLabel: oneRecipe.label))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let recipes = recipes else { return }
        let recipesSelectRow = recipes[indexPath.row]
        sendOneRecipe(recipe: recipesSelectRow)
    }
}
