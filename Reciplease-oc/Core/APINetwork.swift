//
//  SearchNetwork.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 07/06/2022.
//

import Foundation
import Alamofire

protocol SearchNetworkProtocol {
    func callNetwork(router: URLRequestConvertible, completionHandler: @escaping (Data) -> ())
}


class SearchNetwork: SearchNetworkProtocol {
    func callNetwork(router: URLRequestConvertible, completionHandler: @escaping (Data) -> ()) {
        
        do {
        let urlRequest = try router.asURLRequest()
            
            print(urlRequest)
            AF.request(urlRequest).validate().responseDecodable(of: RecipesStructure.self) { response in
            print("response : ")
                print(response)
                if let objet = response.value {
                    print("objet : ")
                    print(objet)
                    completionHandler(objet)
                }
            }
            
        } catch {
            print("eeeddededede")
        }
    }
}
