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
    
    func getEntity(recipe: Recipe) throws {
        
        let entity = NSEntityDescription.entity(forEntityName: "RecipeCD",
                                                in: coreDataStack.viewContext)!
        
        let recipeCD = NSManagedObject(entity: entity, insertInto: coreDataStack.viewContext)
        
        recipeCD.setValue(recipe.image, forKey: "image")
        recipeCD.setValue(recipe.label, forKey: "label")
        recipeCD.setValue(recipe.totalTime, forKey: "totalTime")
        recipeCD.setValue(recipe.url, forKey: "url")
    }
    
    func isItFavorite(urlString: String) -> Bool {
        
        let request: NSFetchRequest<RecipeCD> = RecipeCD.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", urlString)
        
        do {
            let context = coreDataStack.viewContext
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }
    
    func addAsFavorite(recipeToSave: Recipe) throws {
        
        do {
            try getEntity(recipe: recipeToSave)
            do {
                try coreDataStack.viewContext.save()
            } catch {
                throw ErrorType.notSaved
            }
        } catch {
            throw ErrorType.notSaved
        }
    }
    
    
    
    func removeAsFavorite(recipeToDelete: RecipeCD) throws {
       
        coreDataStack.viewContext.delete(recipeToDelete)
        
        do {
            try coreDataStack.viewContext.save()
        }
        catch {
            throw ErrorType.coredataError
        }
    }
    
    func returnViewContext() -> NSManagedObjectContext {
        coreDataStack.viewContext
    }
}
