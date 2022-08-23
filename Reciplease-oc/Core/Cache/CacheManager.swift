//
//  CacheManager.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 22/08/2022.
//

import Foundation
import UIKit

class CacheManager {
    
    public var cache = NSCache<NSString, UIImage>()
    
    func addImageInCache(image: UIImage, name: NSString) {
        cache.setObject(image, forKey: name)
    }
    
    func isImageInCache(name: String) -> Bool {
        cache.object(forKey: name as NSString) == nil ? false : true
    }
    
    func getCacheImage(name: String) -> UIImage {
        guard let image = cache.object(forKey: name as NSString) else { return UIImage()}
        return image
    }
    
}
