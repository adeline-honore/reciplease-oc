//
//  CoreDataStack.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 01/07/2022.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // MARK: - Properties
    
    public static let persistentContainerName = "Reciplease-oc"
    
    public static let model: NSManagedObjectModel = {
      let modelURL = Bundle.main.url(forResource: persistentContainerName, withExtension: "momd")!
      return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    public lazy var mainContext: NSManagedObjectContext = {
        return CoreDataStack.sharedInstance.persistentContainer.viewContext
    }()

    
    // MARK: - Singleton
    
    static let sharedInstance = CoreDataStack()
    
    // MARK: - Public
    
    var viewContext: NSManagedObjectContext {
        return CoreDataStack.sharedInstance.persistentContainer.viewContext
        
    }
    
    public init() {}
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.persistentContainerName, managedObjectModel: CoreDataStack.model)
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error) \(error.userInfo) for: \(storeDescription.description)")
            }
        })
        return container
    }()
    
    public func newDerivedContext() -> NSManagedObjectContext {
      let context = persistentContainer.newBackgroundContext()
      return context
    }
    
    
    public func saveContext() {
      saveContext(viewContext)
    }

    public func saveContext(_ context: NSManagedObjectContext) {
      if context != viewContext {
        saveDerivedContext(context)
        return
      }

      context.perform {
        do {
          try context.save()
        } catch let error as NSError {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      }
    }

    public func saveDerivedContext(_ context: NSManagedObjectContext) {
      context.perform {
        do {
          try context.save()
        } catch let error as NSError {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }

        self.saveContext(self.viewContext)
      }
    }
}
