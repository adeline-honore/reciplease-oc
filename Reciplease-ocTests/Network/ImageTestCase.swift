//
//  ImageTestCase.swift
//  Reciplease-ocTests
//
//  Created by HONORE Adeline on 29/11/2022.
//

import XCTest
@testable import Reciplease_oc

final class ImageTestCase: XCTestCase {
    
    private let urlString = "https://www.google.com"
    
    private func makeSUT(isFailed: Bool = false, scenario: TestCase = .image) -> AllRecipesServiceProtocol {
        let networkFake = NetworkFake(testCase: scenario, isFailed: isFailed)
        let sut = AllRecipesService(network: networkFake)
        return sut
    }
    
    func testGetImageDataFailure() {
        // Given
        let sut = makeSUT(isFailed: true)
        let expectation = XCTestExpectation(description: "Should return failure")
        // When
        sut.getImageData(url: urlString) { result in
            switch result {
            case let .failure(error):
                // Then
                XCTAssertEqual(error, ErrorType.network)
                expectation.fulfill()
            case .success(_):
                XCTFail("Should return failure")
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetImageDataDecodingError() {
        // Given
        let sut = makeSUT(scenario: .decodeFailure)
        let expectation = XCTestExpectation(description: "Should return failure")
        // When
        sut.getImageData(url: urlString) { result in
            switch result {
            case .success(_):
                XCTFail("Should return failure")
            case .failure(let error):
                // Then
                XCTAssertEqual(error, ErrorType.decodingError)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetImageDataSuccess() {
        // Given
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // When
        sut.getImageData(url: urlString) { result in
            switch result {
            case .success(_):
                // Then
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
}
