//
//  SearchRouterNetwork.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 07/06/2022.
//

import Foundation
import Alamofire

public enum SearchRouterNetwork: URLRequestConvertible {
    
    enum Constants {
        static let baseURLPath = "https://api.edamam.com/api/recipes/v2"
        static let apiId = "e6088885"
        static let apiKey = "9d5f4557a5f8754c718afdcf5d463945"
        static let publicType = "public"
        static var food = "bb"
    }
    
    case type(String)
    case ingredients(String)
    case apiId(String)
    case apiKey(String)
    
    var method: HTTPMethod {
        switch self {
        case .type, .ingredients, .apiId, .apiKey:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .type:
            return "/type"
        case .ingredients:
            return "/"
        case .apiId:
            return "app_id"
        case .apiKey:
            return "app_key"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .ingredients(let test):
            return ["app_id": Constants.apiId, "app_key": Constants.apiKey, "type": Constants.publicType, "q": test]
        default:
            return [:]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
