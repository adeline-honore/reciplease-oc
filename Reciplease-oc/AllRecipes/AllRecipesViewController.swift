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
    
    var recipes: [RecipeUI] = []
    var recipesStructure: [Recipe] = []
    var delegate: AllRecipesViewControllerDelegate?
    var oneRecipe: RecipeUI?
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
    
    func configureTableView() {
        let cellNib = UINib(nibName: "RecipeTableViewCell", bundle: .main)
        recipesTableView.register(cellNib, forCellReuseIdentifier: RecipeTableViewCell.identifier)
        recipesTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recipesStructure.forEach { hit in
            let recipeUI = mapRecipeStructureToRecipeUI(recipeStructure: hit, id: nil, title: hit.label, imageUrl: hit.image, image: nil, redirection: hit.url, ingredientsList: hit.ingredientLines, totalTime: hit.totalTime, duration: nil, isFavorite: false)
            
            recipes.append(recipeUI)
        }
        
        recipesTableView.reloadData()
    }
    
    private func mapRecipeStructureToRecipeUI (recipeStructure: Recipe, id: String?, title: String, imageUrl: String?, image: UIImage?, redirection: String, ingredientsList: [String], totalTime: Double, duration: String?, isFavorite: Bool) -> RecipeUI  {
        
        var recipe: RecipeUI = RecipeUI()
        
        recipe.title = recipeStructure.label
        recipe.imageURL = recipeStructure.image
        recipe.redirection = recipeStructure.url
        recipe.ingredientsList = recipeStructure.ingredientLines
        recipe.duration = String(manageTimeDouble(time: recipeStructure.totalTime))
        recipe.isFavorite = repository.isItFavorite(urlString: recipeStructure.url)
        
        return recipe
    }
    
    func configureRecipeCell(cell: RecipeTableViewCell, recipe: RecipeUI) {
        
        cell.configure(titleValue: recipe.title, timeValue: recipe.duration, ingredientsValue: recipe.ingredientsList.joined(separator: ", "))
        
        getImageData(cell: cell, from: recipe.imageURL)
        
        //cell.imageCell.image = recipe.image
        
        cell.datasViewCell.manageDataViewBackground()
        
        manageFavoriteStar(imageView: cell.favoriteStar, isFavorite: recipe.isFavorite)
        
        manageTimeView(time: recipe.totalTime, labelView: cell.timeCell, clockView: cell.clockCell, infoStack: cell.infoStackCell)
    
        
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
    
    // MARK: - Get RecipesUI from RecipeCD
    
    
    func getRecipeUIFromEntity(entity: RecipeCD) -> RecipeUI {
        
        var recipe: RecipeUI = RecipeUI()
        
        //recipe.id = String(entity.id)
        recipe.title = entity.label ?? ""
        recipe.imageURL = entity.image ?? ""
        recipe.imageBianry = entity.img
        recipe.redirection = entity.url ?? ""
        recipe.ingredientsList = entity.ingredients ?? [""]
        recipe.duration = String(entity.totalTime)
        recipe.isFavorite = true
        
        if let imageData = entity.img {
            recipe.image = UIImage(data: imageData)
        } else {
            recipe.image = UIImage(systemName: "star.fill")
        }
        
        return recipe
    }
    
    func getRecipesUIFromEntities(entities: [RecipeCD]) -> [RecipeUI] {
        
        var recipes = [RecipeUI]()
                
        recipes = entities.map{ (une) -> RecipeUI in
            return getRecipeUIFromEntity(entity: une)
        }
        
        return recipes
    }
    
    
    // MARK: - Send One Recipe to OneRecipeViewController
    func sendOneRecipe(recipe: RecipeUI) {
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
         let recipesCount = recipes.count
        return recipesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier) as? RecipeTableViewCell ?? RecipeTableViewCell()
                
        let thisRecipe = recipes[indexPath.row]
        
        configureRecipeCell(cell: cell, recipe: thisRecipe)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipesSelectRow = recipes[indexPath.row]
        sendOneRecipe(recipe: recipesSelectRow)
    }
}
