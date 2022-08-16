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
    let managedObjectContext: NSManagedObjectContext
    
    // MARK: - Init
    
    public init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance, managedObjectContext: NSManagedObjectContext) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = managedObjectContext
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
    
    func createEntity(recipe: RecipeUI) throws {
        
        let entity = NSEntityDescription.entity(forEntityName: "RecipeCD",
                                                in: coreDataStack.viewContext)!
        
        let recipeCD = NSManagedObject(entity: entity, insertInto: coreDataStack.viewContext)
        
        recipeCD.setValue(recipe.imageURL, forKey: "image")
        recipeCD.setValue(recipe.imageBinary, forKey: "img")
        recipeCD.setValue(recipe.ingredientsList, forKey: "ingredients")
        recipeCD.setValue(recipe.title, forKey: "label")
        recipeCD.setValue(recipe.totalTime, forKey: "totalTime")
        recipeCD.setValue(recipe.redirection, forKey: "url")
        
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
    
    func addAsFavorite(recipeToSave: RecipeUI) throws {
        
        do {
            try createEntity(recipe: recipeToSave)
            do {
                try coreDataStack.viewContext.save()
            } catch {
                throw ErrorType.notSaved
            }
        } catch {
            throw ErrorType.notSaved
        }
    }
    
    func removeAsFavorite(urlRedirection: String) throws {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeCD")
        request.predicate = NSPredicate(format:"url = %@", urlRedirection)
        
        if let results = try coreDataStack.viewContext.fetch(request) as? [NSManagedObject] {
            // delete first object:
            if results.count > 0 {
                coreDataStack.viewContext.delete(results[0])
                do {
                try coreDataStack.viewContext.save()
                } catch {
                    throw ErrorType.coredataError
                }
            }
        } else {
            throw ErrorType.coredataError
        }
    }
}
