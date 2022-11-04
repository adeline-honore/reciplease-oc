//
//  RecipesStructure.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 07/06/2022.
//

import Foundation

struct RecipesStructure: Codable {
    
    let _links: Links
    
    let hits: [Hit]
}

struct Links: Codable {
    let next: Next
}

struct Next: Codable {
    let href: String
}

struct Hit: Codable {
    let recipe: Recipe
}

struct Recipe: Codable {
    let label: String
    let image: String
    let url: String
    let ingredientLines: [String]
    let totalTime: Double
    
    init() {
        label = ""
        image = ""
        url = ""
        ingredientLines = [""]
        totalTime = 0.0
    }
}
