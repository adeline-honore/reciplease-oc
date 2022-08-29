//
//  TestCoreDataStack.swift
//  Reciplease-ocTests
//
//  Created by HONORE Adeline on 03/08/2022.
//

import XCTest
import CoreData
@testable import Reciplease_oc

class TestCoreDataStack: CoreDataStack {
    override init() {
        super.init()
        
        // 1 Creates an in-memory persistent store
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        // 2 Creates an NSPersistentContainer instance
        let testPersistentContainer = NSPersistentContainer(
            name: CoreDataStack.persistentContainerName, managedObjectModel: CoreDataStack.model)
        
        // 3 Assigns the in-memory persistent store to the container
        testPersistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
        
        testPersistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // 4 Overrides the storeContainer in CoreDataStack
        persistentContainer = testPersistentContainer
    }
}
