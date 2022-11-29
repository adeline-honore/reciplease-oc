//
//  NetworkFake.swift
//  Reciplease-ocTests
//
//  Created by HONORE Adeline on 29/08/2022.
//

import Foundation
import Alamofire
@testable import Reciplease_oc
import UIKit

class NetworkFake: APINetworkProtocol {
    
    private let testCase : TestCase
    private let jsonExtensionType = "json"
    private let imageExtensionType = "png"
    private var isFailed: Bool = false
    
    init(testCase: TestCase, isFailed: Bool = false) {
        self.testCase = testCase
        self.isFailed = isFailed
    }
    
    func callNetwork(router: URLRequestConvertible, completionHandler: @escaping (Result<Data, Error>) -> ()) {
         guard !isFailed else { return completionHandler(.failure(ErrorType.network)) }
         
        switch testCase {
        case .ingredients:
            return completionHandler(.success(prepareData()))
        case .image:
            return completionHandler(.success(prepareImageData()))
        case .decodeFailure, .imageDecodeFailure:
            return completionHandler(.success("test".data(using: .utf8)!))
        
        }
    }
    
    private func prepareData() -> Data {
        let bundle = Bundle(for: NetworkFake.self)
        let url = bundle.url(forResource: testCase.resource, withExtension: jsonExtensionType)!
        return try! Data(contentsOf: url)
    }
    
    private func prepareImageData() -> Data {
        let image = UIImage(named: "icon")
        let data = image!.jpegData(compressionQuality: 1)
        return data!
    }
}
