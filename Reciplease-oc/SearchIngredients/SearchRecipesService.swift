//
//  SearchRecipes.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 07/06/2022.
//

import Foundation
import Alamofire

class SearchIngredientsService {
    
    
    private var network: SearchNetwork
        
    init(network: SearchNetwork) {
        self.network = network
    }
     
    
    func getData(ingredients: String, completionHandler: @escaping (DataResponse<RecipesStructure, AFError>) -> ()) {
        
        do {
            let aaa = network.callNetwork(router: try SearchRouterNetwok.ingredients(ingredients).asURLRequest()) { result in
            }
            
                AF.request(aaa).validate().responseDecodable(of: RecipesStructure.self) { response in
                print("response : ")
                print(response)
                    
                    if let object = response.value {
                        print("objet : ")
                        print(object)
                    }
            }
        }
        catch {
            fatalError("unable to convert data to JSON")
        }
    }
}
