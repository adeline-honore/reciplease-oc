//
//  RecipesStructure.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 07/06/2022.
//

import Foundation
import CoreData

struct RecipesStructure: Codable {
    
    let hits: [Hit]
}

struct Hit: Codable {
    let recipe: Recipe
}

struct Recipe: Codable {
    var label: String
    var image: String
    var url: String
    var ingredientLines: [String]
    var totalTime: Double
    
    init() {
        label = ""
        image = ""
        url = ""
        ingredientLines = [""]
        totalTime = 0.0
    }
}
