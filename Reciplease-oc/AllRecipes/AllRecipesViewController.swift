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
    
    var recipesUI: [RecipeUI] = []
    var recipes: [Recipe] = []
    var oneRecipeUI: RecipeUI?
    
    private let segueShowOneRecipe = "SegueFromAllToOneRecipe"
    
    private let recipesTitle = "Recipes with my ingredients"
    private let favoriteRecipesTitle = "My favorite recipes"
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let icon = UIImage(imageLiteralResourceName: "icon")
    
    private var cacheManager = CacheManager.shared
        
    private var recipesCD: [RecipeCD]?
    private let repository = RecipesCoreDataManager(
        coreDataStack: CoreDataStack(),
        managedObjectContext: CoreDataStack().viewContext)
    
    private var allIngredientsService = AllRecipesService(network: APINetwork())
    
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
        checkDatasOrigin()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        navigationItem.isAccessibilityElement = true
        
        oneRecipeUI?.tellRecipeUIInformations()
    }
    
    // MARK: - TableViewCell configuration
    
    private func configureTableView() {
        let cellNib = UINib(nibName: "RecipeTableViewCell", bundle: .main)
        recipesTableView.register(cellNib, forCellReuseIdentifier: RecipeTableViewCell.identifier)
        recipesTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func checkDatasOrigin() {
        
        if (recipes.isEmpty) {
            displayCoreDataDatas()
        } else if (!recipes.isEmpty && recipesUI.isEmpty) {
            displayNetworkDatas()
        }
        // else: do not anything because all datas will come from recipesUI
        
        recipesTableView.reloadData()
    }
    
    private func configureRecipeCell(cell: RecipeTableViewCell, recipeUI: RecipeUI) {
        
        cell.configure(titleValue: recipeUI.title,
                       timeValue: recipeUI.duration,
                       ingredientsValue: recipeUI.ingredientsList.joined(separator: ", "),
                       imageValue: recipeUI.image ?? icon
        )
                
        cell.datasViewCell.manageDataViewBackground()
        
        manageFavoriteStarImageView(imageView: cell.favoriteStar, isFavorite: recipeUI.isFavorite)
        
        manageTimeView(time: recipeUI.totalTime, labelView: cell.timeCell, clockView: cell.clockCell, infoStack: cell.infoStackCell)
    }
    
    
    // MARK: - Get RecipeUI from call network
    
    private func displayNetworkDatas() {
        navigationItem.title = recipesTitle
        
        recipesUI = recipes.map {
            RecipeUI(recipe: $0,
                            duration: manageTimeDouble(time: $0.totalTime),
                            isFavorite: repository.isItFavorite(urlString: $0.url)
            )
        }
    }
    
    private func fetchImage(urlImage: String, cell: RecipeTableViewCell, indexPathRow: Int, redirection: String) {
        
        if cacheManager.getCacheImage(name: redirection) != nil {
            let image = cacheManager.getCacheImage(name: redirection)
            cell.imageCell.image = image
            self.recipesUI[indexPathRow].image = image
            return
        }
        
        allIngredientsService.getImageData(url: urlImage) { result in
            switch result {
            case .success(let image):
                cell.imageCell.image = image
                self.recipesUI[indexPathRow].image = image
                self.cacheManager.addImageInCache(image: image, name: redirection as NSString)
            case .failure:
                cell.imageCell.image = self.icon
            }
        }
    }
    
    
    // MARK: - Get RecipeUI from CoreData
    
    private func displayCoreDataDatas() {
        navigationItem.title = favoriteRecipesTitle
        getFavoriteRecipes()
        
        if recipesUI.isEmpty {
            informationMessage(element: .noFavoriteRecipe)
        }
    }
    
    private func getFavoriteRecipes() {
        do {
            recipesCD = try repository.getRecipes()
            if let recipesCD = recipesCD {
                recipesUI = getRecipesUIFromEntities(entities: recipesCD)
            }
        } catch {
            errorMessage(element: .coredataError)
        }
    }
    
    private func getRecipesUIFromEntities(entities: [RecipeCD]) -> [RecipeUI] {
        
        var recipesUI = [RecipeUI]()
        
        recipesUI = entities.map {
            RecipeUI(recipeCD: $0, image: UIImage(data: $0.img ?? Data()) ?? icon,isFavorite: repository.isItFavorite(urlString: $0.url ?? ""))
        }
        
        return recipesUI
    }
    
    
    // MARK: - Send One Recipe to OneRecipeViewController
    func sendOneRecipe(recipe: RecipeUI) {
        oneRecipeUI = recipe
        performSegue(withIdentifier: segueShowOneRecipe, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueShowOneRecipe {
            let oneRecipeVC = segue.destination as? OneRecipeViewController
            oneRecipeVC?.delegate = self
            oneRecipeVC?.recipeUI = oneRecipeUI
        }
    }
}


// MARK: - Extension of AllRecipesViewController
extension AllRecipesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         let recipesCount = recipesUI.count
        return recipesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier) as? RecipeTableViewCell ?? RecipeTableViewCell()
        
        if (!recipes.isEmpty && recipesUI[indexPath.row].image == nil) {
            let index = recipesUI.firstIndex { recipeUI in
                recipesUI[indexPath.row].redirection == recipeUI.redirection
            } ?? 0
            fetchImage(urlImage: recipesUI[indexPath.row].imageURL, cell: cell, indexPathRow: index, redirection: recipesUI[indexPath.row].redirection)
        }
        
        configureRecipeCell(cell: cell, recipeUI: recipesUI[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.width / 1.9
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipesSelectRow = recipesUI[indexPath.row]
        sendOneRecipe(recipe: recipesSelectRow)
    }
}


extension AllRecipesViewController: OneRecipeViewControllerDelegate {
    func didChangeFavoriteState(urlRedirection: String, recipeChanged: RecipeUI) {
        
        if let row = self.recipesUI.firstIndex(where: {$0.redirection == urlRedirection}) {
               recipesUI[row] = recipeChanged
        }
    }
}
