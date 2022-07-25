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
    
    @IBOutlet weak var recipesTableView: UITableView!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recipes with my ingredients"
        recipesTableView.dataSource = self
        recipesTableView.delegate = self
        configureTableView()
    }
    
    private func configureTableView() {
        let cellNib = UINib(nibName: "RecipeTableViewCell", bundle: .main)
        recipesTableView.register(cellNib, forCellReuseIdentifier: RecipeTableViewCell.identifier)
        recipesTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recipesTableView.reloadData()
    }
    
    // MARK: - Get Images
    
    func getImageData(cell: RecipeTableViewCell, from urlString: String) {
        
        guard let url = URL(string: urlString) else {
            // TODO : mettre une url de defaut
            return
            
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                self.errorMessage(element: .network)
                return
            }
            
            // always update the UI from the main thread
            DispatchQueue.main.async() {
                guard let imageRecipe = UIImage(data: data) else {
                    self.errorMessage(element: .network)
                    return
                }
                cell.imageCell.image = imageRecipe
            }
        }
        .resume()
    }
    
    
    // MARK: - Send One Recipe to OneRecipeViewController
    func sendOneRecipe(recipe: Recipe) {
        oneRecipe = recipe
        performSegue(withIdentifier: segueShowOneRecipe, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueShowOneRecipe {
            let oneRecipeVC = segue.destination as? OneRecipeViewController
            
            oneRecipeVC?.recipe = oneRecipe
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier) as? RecipeTableViewCell ?? RecipeTableViewCell()
        
        guard let recipes = recipes else { return UITableViewCell()}
        
        let thisRecipe = recipes[indexPath.row]
        
        cell.configure(titleValue: thisRecipe.label, timeValue: String(thisRecipe.totalTime), ingredientsValue: thisRecipe.ingredientLines.joined(separator: " "))
        
        getImageData(cell: cell, from: thisRecipe.image)
        
        cell.datasViewCell.manageDataViewBackground()
        
        manageFavoriteStar(imageView: cell.favoriteStar, isFavorite: repository.isItFavorite(urlString: thisRecipe.url))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let recipes = recipes else { return }
        let recipesSelectRow = recipes[indexPath.row]
        sendOneRecipe(recipe: recipesSelectRow)
    }
}
