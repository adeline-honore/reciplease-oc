//
//  NetworkFake.swift
//  Reciplease-ocTests
//
//  Created by HONORE Adeline on 29/08/2022.
//

import Foundation
import Alamofire
@testable import Reciplease_oc

class NetworkFake: APINetworkProtocol {
    
    private let testCase : TestCase
    private let extensionType = "json"
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
        case .decodeFailure :
            return completionHandler(.success("test".data(using: .utf8)!))
        }
    }
    
    private func prepareData() -> Data {
        let bundle = Bundle(for: NetworkFake.self)
        let url = bundle.url(forResource: testCase.resource, withExtension: extensionType)!
        return try! Data(contentsOf: url)
    }
}
