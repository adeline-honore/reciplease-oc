//
//  TestRecipesCoreDataManager.swift
//  Reciplease-ocTests
//
//  Created by HONORE Adeline on 03/08/2022.
//

import XCTest
import CoreData
@testable import Reciplease_oc


class TestRecipesCoreDataManager: XCTestCase {
    
    var coreDataManager: RecipesCoreDataManager!
    var coreDataStack: CoreDataStack!
    
    let recipeUI: RecipeUI = {
        var thisRecipeUI = RecipeUI(recipe: Recipe(), duration: "10 mn ", isFavorite: false)
        thisRecipeUI.title = "My pop-corn recipe test"
        thisRecipeUI.imageURL = "http//this-is-a-fake-url-for-my-image"
        thisRecipeUI.redirection = "http//this-is-a-fake-url-redirection"
        thisRecipeUI.ingredientsList = ["corn", "tomato"]
        thisRecipeUI.totalTime = 10.0
        thisRecipeUI.duration = "10 mn "
        thisRecipeUI.isFavorite = false
        return thisRecipeUI
    }()
    
    override func setUpWithError() throws {
        coreDataStack = TestCoreDataStack()
        coreDataManager = RecipesCoreDataManager(
            coreDataStack: coreDataStack,
            managedObjectContext: coreDataStack.viewContext
        )
        
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        coreDataStack = nil
        coreDataManager = nil
        try super.tearDownWithError()
    }
    
    func testRootContextIsSavedAfterAddingRecipe() {
        // 1 Creates a background context and a new instance of RecipesCoreDataManager which uses that context.
        let derivedContext = coreDataStack.persistentContainer.newBackgroundContext()
        coreDataManager = RecipesCoreDataManager(coreDataStack: coreDataStack, managedObjectContext: derivedContext)
        
        // 2 Creates an expectation that sends a signal to the test case when the Core Data stack sends an NSManagedObjectContextDidSave notification event
        expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: coreDataStack.viewContext) { _ in
                return true
            }
        
        // 3 It adds a new recipe inside a perform(_:) block.
        derivedContext.perform {
            do {
                let recipe: () = try self.coreDataManager.addAsFavorite(recipeToSave: self.recipeUI)
                XCTAssertNotNil(recipe)
            } catch {
                print("error, tests fails !")
            }
        }
        
        // 4 The test waits for the signal that the recipe saved. The test fails if it waits longer than two seconds
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }
    
    func testGetRecipes() {
        do {
            
            try coreDataManager.addAsFavorite(recipeToSave: recipeUI)
            
            let getRecipes = try coreDataManager.getRecipes()
            
            XCTAssertNotNil(getRecipes)
            XCTAssertTrue(getRecipes.count == 1)
            XCTAssertTrue(recipeUI.redirection == getRecipes.first?.url)
        } catch {
            print("error, tests fails !")
        }
    }
    
    func testDeleteRecipe() {
        do {
            try coreDataManager.addAsFavorite(recipeToSave: recipeUI)
            var fetchRecipes = try coreDataManager.getRecipes()
            
            XCTAssertTrue(fetchRecipes.count == 1)
            XCTAssertTrue(recipeUI.redirection == fetchRecipes.first?.url)
            
            try coreDataManager.removeAsFavorite(urlRedirection: recipeUI.redirection)
            fetchRecipes = try coreDataManager.getRecipes()
            
            XCTAssertTrue(fetchRecipes.isEmpty )
        } catch {
            print("error, tests fails !")
        }
    }
    
}
