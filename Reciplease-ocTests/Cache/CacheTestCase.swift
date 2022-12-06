//
//  CacheTestCase.swift
//  Reciplease-ocTests
//
//  Created by HONORE Adeline on 01/12/2022.
//

import XCTest
@testable import Reciplease_oc

class CacheTestCase: XCTestCase {
    
    // Given
    private var cacheManager: CacheManager!
    private let image = UIImage(named: "icon")
    private let imageName = "imageTest"
    
    
    override func setUpWithError() throws {
        cacheManager = CacheManager.shared
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        cacheManager = nil
        try super.tearDownWithError()
    }
    
    func testCacheAddImageShouldPostSuccess() {
        // When
        guard let image = image else { return }
        // Then
        cacheManager.addImageInCache(image: image, name: imageName as NSString)
    }
    
    
    func testCacheFetchImageShouldPostSuccess() {
        // When
        guard let image = image else { return }
        // Then
        cacheManager.addImageInCache(image: image, name: imageName as NSString)
        XCTAssertEqual(image, cacheManager.getCacheImage(name: imageName))
    }
}
