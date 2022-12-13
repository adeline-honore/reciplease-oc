//
//  CacheManager.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 22/08/2022.
//

import UIKit

protocol CacheManagerProtocol: AnyObject {
    func addImageInCache(image: UIImage, name: NSString)
    func getCacheImage(name: String) -> UIImage?
    func clear()
}


class CacheManager: CacheManagerProtocol {
    
    private var cache = NSCache<NSString, UIImage>()
    static var shared: CacheManagerProtocol = CacheManager()
    
    private init() {}
    
    func addImageInCache(image: UIImage, name: NSString) {
        cache.setObject(image, forKey: name)
    }
    
    func getCacheImage(name: String) -> UIImage? {
        
        cache.object(forKey: name as NSString) == nil ? nil : cache.object(forKey: name as NSString)
    }
    
    func clear() {
        cache.removeAllObjects()
    }
}
