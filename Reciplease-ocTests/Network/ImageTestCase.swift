//
//  ImageTestCase.swift
//  Reciplease-ocTests
//
//  Created by HONORE Adeline on 29/11/2022.
//

import XCTest
@testable import Reciplease_oc

final class ImageTestCase: XCTestCase {
    
    let urlString = "https://www.google.com"
    
    private func makeSUT(isFailed: Bool = false, scenerio: TestCase = .image) -> AllRecipesServiceProtocol {
        let networkFake = NetworkFake(testCase: scenerio, isFailed: isFailed)
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
        let sut = makeSUT(scenerio: .imageDecodeFailure)
        let expectation = XCTestExpectation(description: "Should return failure")
        // When
        sut.getImageData(url: urlString) { result in
            switch result {
            case .success(_):
                XCTFail("Should return failure")
            case .failure(_):
                // Then
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetImageDataSuccess() {
        // Given
        let sut = makeSUT()
        let expectation = XCTestExpectation(description: "Should return failure")
        // When
        sut.getImageData(url: urlString) { result in
            switch result {
            case .success(_):
                // Then
                expectation.fulfill()
            case .failure(_):
                XCTFail("This test should fail")
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
}
