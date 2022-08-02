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
    
    private var recipes: [RecipeUI] = []
    var recipesStructure: [Recipe] = []
    var oneRecipe: RecipeUI?
    private var segueShowOneRecipe = "SegueFromAllToOneRecipe"
    private let recipesTitle = "Recipes with my ingredients"
    private let favoriteRecipesTitle = "My favorite recipes"
    
    private var recipesCD: [RecipeCD]?
    private let repository = RecipesCoreDataManager()
    
    // MARK: - Outlet
    
    @IBOutlet weak var recipesTableView: UITableView!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipesTableView.dataSource = self
        recipesTableView.delegate = self
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkSegue()
    }
    
    
    // MARK: - TableViewCell configuration
    
    func configureTableView() {
        let cellNib = UINib(nibName: "RecipeTableViewCell", bundle: .main)
        recipesTableView.register(cellNib, forCellReuseIdentifier: RecipeTableViewCell.identifier)
        recipesTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func checkSegue() {
        
        if recipesStructure.isEmpty {
            navigationItem.title = favoriteRecipesTitle
            getFavoriteRecipes()
            
            if recipes.isEmpty {
                informationMessage(element: .noFavoriteRecipe)
            }
            recipesTableView.reloadData()
        } else {
            navigationItem.title = recipesTitle
            recipes = []
            recipesStructure.forEach { hit in
                let recipeUI = mapRecipeStructureToRecipeUI(recipeStructure: hit, title: hit.label, imageUrl: hit.image, image: nil, redirection: hit.url, ingredientsList: hit.ingredientLines, totalTime: hit.totalTime, duration: nil, isFavorite: false)
                
                recipes.append(recipeUI)
            }
            recipesTableView.reloadData()
        }
    }
    
    func configureRecipeCell(cell: RecipeTableViewCell, recipe: RecipeUI) {
        
        cell.configure(titleValue: recipe.title, timeValue: recipe.duration, ingredientsValue: recipe.ingredientsList.joined(separator: ", "))
        
        cell.imageCell.image = recipe.image
        
        cell.datasViewCell.manageDataViewBackground()
        
        manageFavoriteStar(imageView: cell.favoriteStar, isFavorite: recipe.isFavorite)
        
        manageTimeView(time: recipe.totalTime, labelView: cell.timeCell, clockView: cell.clockCell, infoStack: cell.infoStackCell)
    }
    
    
    // MARK: - Get RecipeUI from call network
    
    private func mapRecipeStructureToRecipeUI (recipeStructure: Recipe, title: String, imageUrl: String?, image: UIImage?, redirection: String, ingredientsList: [String], totalTime: Double, duration: String?, isFavorite: Bool) -> RecipeUI  {
        
        var recipe: RecipeUI = RecipeUI()
        
        recipe.title = recipeStructure.label
        recipe.imageURL = recipeStructure.image
        recipe.image = getImageFromUrl(from: recipeStructure.image)
        recipe.redirection = recipeStructure.url
        recipe.ingredientsList = recipeStructure.ingredientLines
        recipe.duration = String(manageTimeDouble(time: recipeStructure.totalTime))
        recipe.isFavorite = repository.isItFavorite(urlString: recipeStructure.url)
        
        return recipe
    }
    
    func getImageFromUrl(from urlString: String) -> UIImage {
        
        guard let url = URL(string: urlString) else {
            return UIImage()
        }
        
        var image: UIImage = UIImage()
        // always update the UI from the main thread
        DispatchQueue.main.async() {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    self.errorMessage(element: .network)
                    return
                }
                print(data)
                guard let imageRecipe = UIImage(data: data) else {
                    self.errorMessage(element: .network)
                    return
                }
                image = imageRecipe
            }.resume()
        }
        return image
    }
    
    
    // MARK: - Get RecipeUI from CoreData
    
    private func getFavoriteRecipes() {
        do {
            recipesCD = try repository.getRecipes()
            if let recipesCD = recipesCD {
                recipes = getRecipesUIFromEntities(entities: recipesCD)
            }
        } catch {
            errorMessage(element: .coredataError)
        }
    }
    
    func getRecipeUIFromEntity(entity: RecipeCD) -> RecipeUI {
        
        var recipe: RecipeUI = RecipeUI()
        
        recipe.id = String(entity.id.hashValue)
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
            // ----------------------------------//////
            recipe.image = UIImage(systemName: "star.fill")
        }
        
        return recipe
    }
    
    func getRecipesUIFromEntities(entities: [RecipeCD]) -> [RecipeUI] {
        
        var recipes = [RecipeUI]()
                
        recipes = entities.map{ (entity) -> RecipeUI in
            return getRecipeUIFromEntity(entity: entity)
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
