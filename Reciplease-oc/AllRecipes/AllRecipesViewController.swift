//
//  AllRecipesViewController.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 07/06/2022.
//

import UIKit


class AllRecipesViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var recipesTableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var recipesUI: [RecipeUI] = []
    private var recipesUIIndex: Int?
    var recipes: [Recipe] = []
    var ingredientsList: String = ""
    
    private let segueShowOneRecipe = "SegueFromAllToOneRecipe"
    
    private let recipesTitle = "Recipes with my ingredients"
    private let favoriteRecipesTitle = "My favorite recipes"
    private let icon = UIImage(imageLiteralResourceName: "icon")
    
    private var cacheManager = CacheManager.shared
    
    private var recipesCD: [RecipeCD]?
    let repository = RecipesCoreDataManager(
        coreDataStack: CoreDataStack(),
        managedObjectContext: CoreDataStack().viewContext)
    
    var allIngredientsService = AllRecipesService(network: APINetwork())
    
    private var loadMoreRecipes: Bool = true
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipesTableView.dataSource = self
        recipesTableView.delegate = self
        configureTableView()
        activityIndicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkDatasOrigin()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        navigationItem.isAccessibilityElement = true
    }
    
    // MARK: - TableViewCell configuration
    
    private func configureTableView() {
        let cellNib = UINib(nibName: "RecipeTableViewCell", bundle: .main)
        recipesTableView.register(cellNib, forCellReuseIdentifier: RecipeTableViewCell.identifier)
        recipesTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func checkDatasOrigin() {
        
        if ingredientsList.isEmpty {
            displayCoreDataDatas()
        } else if (!ingredientsList.isEmpty && recipes.isEmpty) {
            displayNetworkDatas()
        } else {
            recipesTableView.reloadData()
        }
    }
    
    private func configureRecipeCell(cell: RecipeTableViewCell, recipeUI: RecipeUI) {
        cell.configure(recipe: recipeUI)
    }
    
    
    // MARK: - Get RecipeUI from call network
    
    private func displayNetworkDatas() {
        navigationItem.title = recipesTitle
        
        recipesTableView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        allIngredientsService.getData(ingredients: ingredientsList) { result in
            DispatchQueue.main.async { [weak self] in
                
                guard let self = self else {
                    return
                }
                
                switch result {
                case .success(let arrayOfHits):
                    
                    self.recipes = arrayOfHits
                    let recipesUIData = arrayOfHits.map {
                        RecipeUI(recipe: $0,
                                 duration: self.manageTimeDouble(time: $0.totalTime),
                                 isFavorite: self.repository.isItFavorite(urlString: $0.url)
                        )
                    }
                    
                    self.recipesUI += recipesUIData
                                        
                    self.recipesTableView.reloadData()
                    self.recipesTableView.tableFooterView = nil
                    self.recipesTableView.isHidden = false
                    self.activityIndicator.isHidden = true
                    
                    self.loadMoreRecipes = true
                    
                case .failure(let error):
                    self.errorMessage(element: error)
                    self.recipesTableView.isHidden = false
                    self.activityIndicator.isHidden = true
                    self.recipesTableView.tableFooterView = nil
                    self.loadMoreRecipes = true
                }
            }
        }
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    private func fetchImage(urlImage: String, cell: RecipeTableViewCell, indexPathRow: Int, redirection: String) {
        
        if cacheManager.getCacheImage(name: redirection) != nil {
            let image = cacheManager.getCacheImage(name: redirection)
            cell.imageview.image = image
            self.recipesUI[indexPathRow].image = image
            return
        }
        
        allIngredientsService.getImageData(url: urlImage) { result in
            switch result {
            case .success(let image):
                cell.imageview.image = image
                self.recipesUI[indexPathRow].image = image
                self.cacheManager.addImageInCache(image: image, name: redirection as NSString)
            case .failure:
                cell.imageview.image = self.icon
            }
        }
    }
    
    
    // MARK: - Get RecipeUI from CoreData
    
    private func displayCoreDataDatas() {
        navigationItem.title = favoriteRecipesTitle
        getFavoriteRecipes()
        
        recipesTableView.reloadData()
        
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
    
    func sendRecipesUI() {
        performSegue(withIdentifier: segueShowOneRecipe, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueShowOneRecipe {
            let oneRecipeVC = segue.destination as? OneRecipeViewController
            oneRecipeVC?.delegate = self
            oneRecipeVC?.recipesUI = recipesUI
            oneRecipeVC?.recipesUIIndex = recipesUIIndex
        }
    }
}


// MARK: - Extension of AllRecipesViewController
extension AllRecipesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let recipesCount = recipesUI.count
        return recipesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier) as? RecipeTableViewCell ?? RecipeTableViewCell()
        
        if (!ingredientsList.isEmpty && recipesUI[indexPath.row].image == nil) {
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
        recipesUIIndex = indexPath.row
        sendRecipesUI()
    }
}


extension AllRecipesViewController: OneRecipeViewControllerDelegate {
    func didChangeFavoriteState(urlRedirection: String, recipeChanged: RecipeUI) {
        
        if let row = self.recipesUI.firstIndex(where: {$0.redirection == urlRedirection}) {
            recipesUI[row] = recipeChanged
        }
    }
}

extension AllRecipesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
        let contentSize: CGSize = recipesTableView.contentSize
        
        if position > contentSize.height - 100 - scrollView.frame.size.height && loadMoreRecipes {
            
            loadMoreRecipes = false
            
            recipesTableView.tableFooterView = createSpinnerFooter()
            
            displayNetworkDatas()
        }
    }
}
