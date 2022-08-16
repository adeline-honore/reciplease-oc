//
//  FetchImageNetwork.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 14/08/2022.
//

import Foundation
import Alamofire

public enum FetchImageNetwork {
    
    case urlImage(String)
        
    func asURLRequest(urlString: String) -> URLRequest {
        
        let myUrl = URL(string: urlString)

        var request: URLRequest?
        
        do {
            request = try URLRequest(url: myUrl!, method: .get, headers: .none)
        } catch {
            
        }
        
        return request!
    }
}
