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
    
    func testIsItFavorite() {
        do {
            
            try coreDataManager.addAsFavorite(recipeToSave: recipeUI)
            
            let getRecipes = try coreDataManager.getRecipes()
            
            XCTAssertNotNil(getRecipes)
            XCTAssertTrue(getRecipes.count == 1)
            XCTAssertTrue(recipeUI.redirection == getRecipes.first?.url)
            XCTAssertTrue(coreDataManager.isItFavorite(urlString: recipeUI.redirection))
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
