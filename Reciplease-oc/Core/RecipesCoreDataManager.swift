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
    
    func getRecipes() throws -> [RecipeCD] {
        let request: NSFetchRequest<RecipeCD> = RecipeCD.fetchRequest()
        do {
            return try coreDataStack.viewContext.fetch(request)
        } catch {
            throw ErrorType.coredataError
        }
    }
    
    func addAsFavorite(recipeToSave: Recipe) throws {
        var recipe = recipeToSave.getEntity()
        recipe = RecipeCD(context: coreDataStack.viewContext)
        
        do {
          try coreDataStack.viewContext.save()
        } catch {
            throw ErrorType.notSaved
        }
    }
    
    func isExistsInCoreData(title: String) -> Bool {
        var isExist = false
        let request: NSFetchRequest<RecipeCD> = RecipeCD.fetchRequest()
        request.predicate = NSPredicate(format: "label == %@", title)
        
        do {
            let context = coreDataStack.viewContext
            let count = try context.count(for: request)
            if count < 1 {
                isExist = false
            } else {
                isExist = true
            }
        } catch {
            ErrorType.coredataError
        }
        
        return isExist
    }
    
    func removeAsFavorite(recipe: Recipe) throws {
        
    }
}
