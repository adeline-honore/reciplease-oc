//
//  SearchRecipes.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 07/06/2022.
//

import Foundation

protocol SearchIngredientsServiceProtocol {
    func getData(ingredients: String, completionHandler: @escaping (Result<[Recipe], ErrorType>) -> ())
}

class SearchIngredientsService: SearchIngredientsServiceProtocol {
    
    private var network: APINetworkProtocol
    
    init(network: APINetworkProtocol) {
        self.network = network
    }
    
    
    func getData(ingredients: String, completionHandler: @escaping (Result<[Recipe], ErrorType>) -> ()) {
        
        try? network.callNetwork(router: SearchRouterNetwork.ingredients(ingredients).asURLRequest()) { result in
            
            switch result {
            case .success(let data):
                do {
                    let recipesResult = try self.transformToRecipes(data: data)
                    let recipes = recipesResult.hits.map { $0.recipe}
                    completionHandler(.success(recipes))
                } catch {
                    completionHandler(.failure(ErrorType.decodingError))
                }
                
            case .failure:
                completionHandler(.failure(ErrorType.network))
            }
        }
    }
    
    private func transformToRecipes(data: Data) throws -> RecipesStructure {
        
        do {
            return try JSONDecoder().decode(RecipesStructure.self, from: data)
        } catch {
            throw ErrorType.decodingError
        }
    }
}
