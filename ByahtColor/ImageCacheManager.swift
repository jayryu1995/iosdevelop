//
//  ImageCacheManager.swift
//  ByahtColor
//
//  Created by jaem on 2024/02/01.
//

import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {
        imageCache.countLimit = 50 // 캐시할 수 있는 최대 객체 수
        imageCache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }

    private var imageCache = NSCache<NSString, UIImage>()

    func setImage(_ image: UIImage, for key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }

    func image(for key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }

    func clearCache() {
        imageCache.removeAllObjects()
    }
}
