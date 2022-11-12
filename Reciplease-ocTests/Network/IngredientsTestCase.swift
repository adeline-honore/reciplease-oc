//
//  IngredientsTestCase.swift
//  Reciplease-ocTests
//
//  Created by HONORE Adeline on 29/08/2022.
//

import XCTest
@testable import Reciplease_oc

class IngredientsTestCase: XCTestCase {

    // Given
    private var allRecipesService: AllRecipesService!
    private let ingredients = "tomato"
    
    private func initSUT(isFailed: Bool = false) {
        allRecipesService = AllRecipesService(network: NetworkFake(testCase: .ingredients, isFailed: isFailed))
    }
    
    override func tearDown() {
        super.setUp()
        allRecipesService = nil
    }
    
    func testAllRecipesServiceShouldPostSuccess() {
        // Given
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        allRecipesService.getData(ingredients: ingredients) { result in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAllRecipesServiceShouldPostSuccessOnDataLabelValue() {
        // Given
        let labelReceived = "Tomato Gravy"
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        allRecipesService.getData(ingredients: ingredients) { result in
            switch result {
            case .success(_):
                XCTAssertEqual(try? result.get().first?.label, labelReceived)
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAllRecipesServiceShouldPostSuccessOnDataImageValue() {
        // Given
        let imageReceived = "https://edamam-product-images.s3.amazonaws.com/web-img/58a/58a93a8d0c48110ac1c59e3b6e82a9ef.jpg?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEJf%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJHMEUCICaW3QhsqDNZVsshNQwknmZpri5K%2FgT4TFcutNPyBM1cAiEA8JbLLGR3B2RLqdnJy4Ynmw44CWoni88i85Xyp7QlUTMq0gQIHxAAGgwxODcwMTcxNTA5ODYiDO5gIwFuPkUpoos3IiqvBLl1Uf2v4GLiEEVGndXjhBXXHlQHr1sPPxKyelGpaGenyiyQh1l8hLudgrpJMeiy72ZgtDQ61U5MwDmUp6UvpVzFb3TkdvxCjOK7hN1fcsxVp00Wr2uSl8u0USlOaP2MEkLkdcUAdc91LuQcKRcdKFNhbjF0DHnH0xJCQWCXAikk6m8B%2Fig16zY9gSSwa9grnEk0zQsj%2FVaYOdym5dpo%2B5wcQxohrELUjue8CiIQJMBFf2akH5hZ%2Fp4VU%2F9flFiacxccdi8nnN%2B1hL3Hp0SZSuOq2E8xf9YMNAnjYE0a%2F9d4IxkDp2L0jXQB6L5tQExPdjy2JrS%2FR3rTkrNjcEUJkYLt1OrY0eCF8NwvbbhqaBmnevTO7mV0jKCXcVXiNX2a%2Fbs5%2F3bIQ7a4jD04QJRUYvRysJG3HYNUV2dd5GVA6a8acxT%2Fpeg92M2gfqvO%2BDOJb8qnnUJ2Ri%2FYySUvH3YuwRrd1LK1uWEamN4sZhDn8h6oEupBLPIBc3nGrU%2BdLVy%2BN93hX7jaZJKCkZsQnOXe2Vcln8i0SQfl038gpeWcKZADD3h489%2Bw%2B%2BzIKMwTacpN371TAA9G95GvVrjlqtU%2BghW2lj%2F70XHZcs%2Fm%2FzRtQyt7yGtFEhJBFi99R2RXUcynaIzBzRdLDJd44P3xWXk%2BNiRhbQ55QQRhFOMea6S0Mmsvy2f3fHkBdND%2FJ9k5g8kXZlC5NiPBybEPJAvwvcAxUzNS62dpPHFLBM4lZPSmjpowm9SvmAY6qQEGbSks1wnTdjfxYhx1WpGmjXTvaiAYJpvY20zucAG74j09tuue9Fm0DQfdz3tsh7epG8SWhHiWNush8qdfjx2ERONR8QLwlFi3KEMfeSN6md3fXFXMSyCb3BvE5%2BOOTBzcY8TTxN%2BOLFi582rLBZGjdoqJ01dVNHASgyc6ayDnn%2BGV4Xy4AH1AkE%2FZtHIJQlP%2FeIAk%2FJlfiX1wE%2FYQqBcz2zI0XvXv%2B2gy&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20220828T232604Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3599&X-Amz-Credential=ASIASXCYXIIFGB3CV3XZ%2F20220828%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=478200b07548dbe616e895446b5913f02017de17cfdab47d70ce0714e139cb96"
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        allRecipesService.getData(ingredients: ingredients) { result in
            switch result {
            case .success(_):
                XCTAssertEqual(try? result.get().first?.image, imageReceived)
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAllRecipesServiceShouldPostSuccessOnDataUrlValue() {
        // Given
        let urlReceived = "http://www.seriouseats.com/recipes/2013/01/sauced-tomato-gravy-recipe.html"
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        allRecipesService.getData(ingredients: ingredients) { result in
            switch result {
            case .success(_):
                XCTAssertEqual(try? result.get().first?.url, urlReceived)
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAllRecipesServiceShouldPostSuccessOnDataIngredientLinesValue() {
        // Given
        let ingredientLinesReceived = [
            "1/4 cup bacon drippings",
            "1/4 cup all-purpose flour",
            "1 tablespoon tomato paste",
            "1 (15-ounce) can diced tomatoes, with juice",
            "1 cup milk",
            "1/4 cup heavy cream",
            "Kosher salt and freshly ground black pepper"
          ]
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        allRecipesService.getData(ingredients: ingredients) { result in
            switch result {
            case .success(_):
                XCTAssertEqual(try? result.get().first?.ingredientLines, ingredientLinesReceived)
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAllRecipesServiceShouldPostSuccessOnDataTotalTimeValue() {
        // Given
        let totalTimeReceived = 10.0
        initSUT()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        // Then
        allRecipesService.getData(ingredients: ingredients) { result in
            switch result {
            case .success(_):
                XCTAssertEqual(try? result.get().first?.totalTime, totalTimeReceived)
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
