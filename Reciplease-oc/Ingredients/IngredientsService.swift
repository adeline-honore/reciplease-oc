//
//  IngredientsService.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 07/06/2022.
//

import Foundation

protocol IngredientsServiceProtocol {
    func getData(ingredients: String, completionHandler: @escaping (Result<[Recipe], ErrorType>) -> ())
}

class IngredientsService: IngredientsServiceProtocol {
    
    private var network: APINetworkProtocol
    
    private var nextUrl: String?
    
    init(network: APINetworkProtocol) {
        self.network = network
    }
    
    
    func getData(ingredients: String, completionHandler: @escaping (Result<[Recipe], ErrorType>) -> ()) {
            
//        try? network.callNetwork(router: IngredientsRouterNetwork.ingredients(ingredients).asURLRequest()) { [weak self] result in
        
        network.callNetwork(router: prepareUrlRequest(ingredients: ingredients)) { [weak self]
            result in
                
            guard let self = self else {
                completionHandler(.failure(ErrorType.network))
                return
            }
//            if pagination {
//                self.isPaginating = true
//            }
            
            switch result {
            case .success(let data):
                do {
                    let recipesResult = try self.transformToRecipes(data: data)
                    
                    // get url for next recipes
                    self.nextUrl = recipesResult._links.next.href
                    
                    // if
                    
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
    
    
    
    private func prepareUrlRequest(ingredients: String) -> URLRequest {
        
        if nextUrl == nil {
            do {
                return try IngredientsRouterNetwork.ingredients(ingredients).asURLRequest()
            } catch {
                ErrorType.network
                return URLRequest(url: URL(string: "")!)
            }
            
        } else {
            guard let nextUrl = nextUrl else {
                return URLRequest(url: URL(string: "")!)
            }

            do {
                return try createNextUrlRequest(url: nextUrl)
            }
            catch {
                ErrorType.network
                return URLRequest(url: URL(string: "")!)
            }
        }
    }
    
    
    func createNextUrlRequest(url: String) throws -> URLRequest {
        
        guard let url = URL(string: url) else {
            throw ErrorType.network
        }

        do {
            return try URLRequest(url: url, method: .get, headers: .none)
        } catch {
            throw ErrorType.network
        }
        
    }
    
    
    func getnextUrl(nextUrl: String?) -> String? {
        return nextUrl
    }
    
}
