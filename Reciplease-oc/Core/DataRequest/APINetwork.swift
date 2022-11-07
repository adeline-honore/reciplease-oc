//
//  SearchNetwork.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 07/06/2022.
//

import Foundation
import Alamofire

class APINetwork: APINetworkProtocol {
    func callNetwork(router: URLRequestConvertible, completionHandler: @escaping (Result<Data, Error>) -> ()) {
                
        AF.request(router).responseData { responseData in
             let reponseResult = responseData.result
            
            switch reponseResult {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
            
        }
        
    }
}
