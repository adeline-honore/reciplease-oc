//
//  AllRecipesService.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 14/08/2022.
//

import UIKit

protocol AllRecipesServiceProtocol {
    func getData(ingredients: String, completionHandler: @escaping (Result<[Recipe], ErrorType>) -> ())
    func getImageData(url: String, completionHandler: @escaping (Result<UIImage, ErrorType>) -> ())
}

class AllRecipesService: AllRecipesServiceProtocol {
    
    private var network: APINetworkProtocol
    private var nextUrl: String?
    
    init(network: APINetworkProtocol) {
        self.network = network
    }
    
    func getData(ingredients: String, completionHandler: @escaping (Result<[Recipe], ErrorType>) -> ()) {
        
        guard let urlRequest = try? prepareUrlRequest(ingredients: ingredients) else {
            return completionHandler(.failure(ErrorType.network))
        }
        
        network.callNetwork(router: urlRequest) {
            [weak self] result in
                
            guard let self = self else {
                completionHandler(.failure(ErrorType.network))
                return
            }
            
            switch result {
            case .success(let data):
                do {
                    let recipesResult = try self.transformToRecipes(data: data)
                    
                    // get url for next recipes
                    self.nextUrl = recipesResult._links.next.href
                    
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
        return try JSONDecoder().decode(RecipesStructure.self, from: data)
    }
    
    
    
    private func prepareUrlRequest(ingredients: String) throws -> URLRequest {
        guard let nextUrl = nextUrl else {
            return try IngredientsRouterNetwork.ingredients(ingredients).asURLRequest()
        }
        return try createNextUrlRequest(url: nextUrl)
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
    
    
    func getImageData(url: String, completionHandler: @escaping (Result<UIImage, ErrorType>) -> ()) {
        
        try? network.callNetwork(router:  FetchImageRouter.urlImage(url).asURLRequest()) { result in
            switch result {
            case .success(let data):
                guard let imageToUpload = UIImage(data: data) else {
                    return completionHandler(.failure(.decodingError))
                }
                completionHandler(.success(imageToUpload))
            case .failure:
                completionHandler(.failure(ErrorType.network))
            }
        }
    }
}
