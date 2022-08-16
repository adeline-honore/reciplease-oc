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
        var recipe = RecipeUI()
        recipe.title = "My pop-corn recipe test"
        recipe.imageURL = "http//this-is-a-fake-url-for-my-image"
        recipe.redirection = "http//this-is-a-fake-url-redirection"
        recipe.ingredientsList = ["corn", "tomato"]
        recipe.totalTime = 10.0
        recipe.duration = "10"
        recipe.isFavorite = false
        return recipe
    }()
    
    /*
    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        coreDataManager = RecipesCoreDataManager(coreDataStack: coreDataStack, managedObjectContext: coreDataStack.mainContext)
    }*/
    
    override func setUpWithError() throws {
            coreDataStack = TestCoreDataStack()
            coreDataManager = RecipesCoreDataManager(
                coreDataStack: coreDataStack,
                managedObjectContext: coreDataStack.mainContext
            )
            
            try super.setUpWithError()
        }
    /*
    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
        coreDataStack = nil
    }*/
    
    override func tearDownWithError() throws {
            coreDataStack = nil
            coreDataManager = nil
            try super.tearDownWithError()
        }
    
    /*
    func testCreateRecipeCD() {
        
        do {
            let recipe: () = try coreDataManager.addAsFavorite(recipeToSave: recipeUI)
            XCTAssertNotNil(recipe, "Recipe should not be nil")
        } catch {
            print("error, tests fails !")
        }
    }
     */
    
    func testRootContextIsSavedAfterAddingRecipe() {
        // 1 Creates a background context and a new instance of RecipesCoreDataManager which uses that context.
        let derivedContext = coreDataStack.persistentContainer.newBackgroundContext()
        coreDataManager = RecipesCoreDataManager(coreDataStack: coreDataStack, managedObjectContext: derivedContext)
        
        // 2 Creates an expectation that sends a signal to the test case when the Core Data stack sends an NSManagedObjectContextDidSave notification event
        expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: coreDataStack.mainContext) { _ in
                return true
            }
        
        // 3 It adds a new report inside a perform(_:) block.
        derivedContext.perform {
            do {
                let recipe: () = try self.coreDataManager.addAsFavorite(recipeToSave: self.recipeUI)
                XCTAssertNotNil(recipe)
            } catch {
                print("error, tests fails !")
            }
        }
        
        // 4 The test waits for the signal that the report saved. The test fails if it waits longer than two seconds
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }
    
    func testGetRecipes() {
        do {
            
            //1 Adds a new recipe and assigns it to newRecipe
            //try coreDataManager.addAsFavorite(recipeToSave: recipeUI)
            
            //2 Gets all reports currently stored in Core Data and assigns them to getRecipes
            let getRecipes = try coreDataManager.getRecipes()
            //3 Verifies the result of getRecipes is nil. This is a failing test
            XCTAssertNotNil(getRecipes)
            
            //4 Asserts the results array is empty
            XCTAssertTrue(getRecipes.count > 0)
            //XCTAssertTrue(newReport.id == fetchReports?.first?.id)
        } catch {
            print("error, tests fails !")
        }
    }
    
    func testDeleteRecipe() {
        do {
            //try coreDataManager.addAsFavorite(recipeToSave: recipeUI)
            var fetchRecipes = try coreDataManager.getRecipes()
            
            XCTAssertTrue(fetchRecipes.count > 0)
            //XCTAssertTrue(newReport.id == fetchReports?.first?.id)
            try coreDataManager.removeAsFavorite(urlRedirection: recipeUI.redirection)
            fetchRecipes = try coreDataManager.getRecipes()
            //XCTAssertTrue(fetchReports.isEmpty )
        } catch {
            print("error, tests fails !")
        }
    }
    
}