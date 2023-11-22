//
//  ImageCache.swift
//  PawPal
//
//  Created by Yitian Guo on 11/22/23.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()

    private init() {}

    var cache = NSCache<NSString, UIImage>()

    func getImage(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
