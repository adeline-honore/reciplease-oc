//
//  FetchImageNetwork.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 14/08/2022.
//

import Foundation
import Alamofire

public enum FetchImageRouter {
    
    case urlImage(String)
    
    func asURLRequest() throws -> URLRequest {
        
        switch self {
        case .urlImage(let urlString):
            guard let url = URL(string: urlString) else { throw ErrorType.network }
            
            do {
                return try URLRequest(url: url, method: .get, headers: .none)
            } catch {
                throw error
            }
        }
    }
}
