//
//  CacheManager.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 22/08/2022.
//

import Foundation
import UIKit

class CacheManager {
    
    private var cache = NSCache<NSString, UIImage>()
    static var shared = CacheManager()
    
    private init() {}
    
    func addImageInCache(image: UIImage, name: NSString) {
        cache.setObject(image, forKey: name)
    }
    
    func getCacheImage(name: String) -> UIImage? {
        
        cache.object(forKey: name as NSString) == nil ? nil : cache.object(forKey: name as NSString)
    }
    
}
