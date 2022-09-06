//
//  AllRecipesService.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 14/08/2022.
//

import UIKit

protocol AllRecipesServiceProtocol {
    func getImageData(url: String, completionHandler: @escaping (Result<UIImage, ErrorType>) -> ())
}

class AllRecipesService: AllRecipesServiceProtocol {
    
    private var network: APINetworkProtocol
    
    init(network: APINetworkProtocol) {
        self.network = network
    }
    
    func getImageData(url: String, completionHandler: @escaping (Result<UIImage, ErrorType>) -> ()) {
        
        try? network.callNetwork(router:  FetchImageRouter.urlImage(url).asURLRequest()) { result in
            
            switch result {
            case .success(let data):
                guard let imageToUpload = UIImage(data: data) else { return }
                completionHandler(.success(imageToUpload))
                
            case .failure:
                completionHandler(.failure(ErrorType.network))
            }
        }
    }
}
