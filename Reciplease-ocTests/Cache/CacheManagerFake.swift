//
//  CacheManagerFake.swift
//  Reciplease-ocTests
//
//  Created by HONORE Adeline on 01/12/2022.
//

import UIKit
@testable import Reciplease_oc

class CacheManagerFake: CacheManagerProtocol {
    var cache = NSCache<NSString, UIImage>()
    
    init() {}
    
    func addImageInCache(image: UIImage, name: NSString) {
        cache.setObject(image, forKey: name)
    }
    
    func getCacheImage(name: String) -> UIImage? {
        cache.object(forKey: name as NSString) == nil ? nil : cache.object(forKey: name as NSString)
    }
}
