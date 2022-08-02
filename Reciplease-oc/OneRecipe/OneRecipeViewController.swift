//
//  OneRecipeViewController.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 25/06/2022.
//

import UIKit

class OneRecipeViewController: UIViewController {
    
    // MARK: - Properties
    
    var oneRecipeView: OneRecipeView!
    var recipe: RecipeUI?
    let repository = RecipesCoreDataManager()
    
    
    @IBOutlet weak var oneRecipeIngredientTableView: UITableView!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oneRecipeView = view as? OneRecipeView
        oneRecipeIngredientTableView.dataSource = self
        oneRecipeIngredientTableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayRecipe()
    }
    
    
    // MARK: - Display one recipe
    
    func displayRecipe() {
        guard let oneRecipe = recipe,
              let favoriteStar = oneRecipeView.favoriteStarButton.imageView else {
            return
        }
        oneRecipeView.oneRecipeTitleLabel.text = oneRecipe.title
        oneRecipeView.oneRecipeTime.text = String(manageTimeDouble(time: oneRecipe.totalTime)) + " mn  "
        oneRecipeView.oneRecipeDatasView.manageDataViewBackground()
        manageFavoriteStar(imageView: favoriteStar, isFavorite: oneRecipe.isFavorite)
        manageTimeView(time: oneRecipe.totalTime, labelView: oneRecipeView.oneRecipeTime, clockView: oneRecipeView.oneRecipeClock, infoStack: oneRecipeView.infoStack)
        
        //oneRecipeView.oneRecipeImageView.image = oneRecipe.image
        getImageData(view: oneRecipeView, from: oneRecipe.imageURL)
    }
    
    func getImageData(view: OneRecipeView,from urlString: String) {
        
        guard let url = URL(string: urlString) else {
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
                view.oneRecipeImageView.image = imageRecipe
            }
        }
        .resume()
    }
    
    
    // MARK: - Add and Remove Recipe as Favorite
    
    @IBAction func didTapFavoriteButton() {
        toggleFavorite()
    }
    
    func toggleFavorite() {
        guard var recipe = recipe,
              let favoriteStar = oneRecipeView.favoriteStarButton.imageView else {
            return
        }
                
        if recipe.isFavorite { // if recipe is saved in Coredata then delete it
            do {
                try repository.removeAsFavorite(urlRedirection: recipe.redirection)
                recipe.isFavorite = false
                manageFavoriteStar(imageView: favoriteStar, isFavorite: false)
                informationMessage(element: .deleteFromFavorite)
            } catch {
                errorMessage(element: .coredataError)
            }
        } else { // if recipe isn't saved in Coredata then save it
            recipe.imageBianry = oneRecipeView.oneRecipeImageView.image?.jpegData(compressionQuality: 1.0)
            do {
                try repository.addAsFavorite(recipeToSave: recipe)
                recipe.isFavorite = true
                favoriteStar.tintColor = .orange
                //manageFavoriteStar(imageView: favoriteStar, isFavorite: true)
                informationMessage(element: .savedAsFavorite)
                
            } catch {
                errorMessage(element: .notSaved)
            }
        }
    }
    

    // MARK: - Go to recipe's instructions
    
    @IBAction func didTapGoToInstructionsButton() {
        goToInstructions()
    }
    private func goToInstructions() {
        
        guard let oneRecipe = recipe,
              let instructionUrl = URL(string: oneRecipe.redirection) else { return }
        
        if !oneRecipe.redirection.isEmpty {
            UIApplication.shared.open(instructionUrl, options: [:], completionHandler: nil)
        } else {
            errorMessage(element: .noInstruction)
        }
    }
    
}


// MARK: - Extension of OneRecipeViewController
extension OneRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let recipe = recipe else {
            return 0
        }
        let recipesCount = recipe.ingredientsList.count
        return recipesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableViewCell.identifier, for: indexPath) as? IngredientTableViewCell,
              let recipe = recipe else {
                  return UITableViewCell()
              }
        
        cell.ingredient.text = "-  " + recipe.ingredientsList[indexPath.row]
        return cell
    }
}
