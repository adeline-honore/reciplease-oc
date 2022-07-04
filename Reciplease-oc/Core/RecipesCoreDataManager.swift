//
//  RecipesCoreDataManager.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 04/07/2022.
//

import Foundation
import CoreData

final class RecipesCoreDataManager {
    
    // MARK: - Properties
    
    private let coreDataStack: CoreDataStack
    
    // MARK: - Init
    
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    
    
    // MARK: - Repository
    
    func getRecipes(completion: ([RecipeCD]) -> Void) {
        let request: NSFetchRequest<RecipeCD> = RecipeCD.fetchRequest()
        do {
          let recipesCD = try coreDataStack.viewContext.fetch(request)
          completion(recipesCD)
        } catch {
          completion([])
        }
    }
    
    func addAsFavorite(recipe: Recipe, completion: () -> Void) {
        
        let recipeToSave = RecipeCD(context: coreDataStack.viewContext)
        recipeToSave.label = recipe.label
        recipeToSave.image = recipe.image
        recipeToSave.totalTime = recipe.totalTime
        recipeToSave.url = recipe.url
        
        do {
          try coreDataStack.viewContext.save()
          completion()
        } catch {
            //ErrorType.notSaved
          print("We were unable to save !!!")
        }
        
    }
    
    func removeAsFavorite(recipe: Recipe) {
        
    }
}
