//
//  APINetworkProtocol.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 14/06/2022.
//

import Foundation
import Alamofire

protocol APINetworkProtocol {
    func callNetwork(router: URLRequestConvertible, completionHandler: @escaping (Result<Data, Error>) -> ())
}
