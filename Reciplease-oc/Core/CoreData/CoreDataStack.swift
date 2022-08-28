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
    
    
    // MARK: - Public
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
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
    
}
