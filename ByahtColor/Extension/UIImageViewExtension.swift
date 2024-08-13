//
//  UIImageViewExtension.swift
//  ByahtColor
//
//  Created by jaem on 2024/02/01.
//

import UIKit
import SkeletonView

extension UIImageView {
    func loadImage2(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let downloadedImage = UIImage(data: data) else { return }
            let resizedImage = downloadedImage.resized(toWidth: 480)
            if let resizedImage = resizedImage {
                DispatchQueue.main.async {
                    self.image = resizedImage
                    self.clipsToBounds = true
                }
            }

        }.resume()
    }

    func loadImage(from urlString: String) {

        self.isSkeletonable = true
        self.showAnimatedGradientSkeleton()
        if let cachedImage = ImageCacheManager.shared.image(for: urlString) {
            DispatchQueue.main.async {
                print("캐싱이미지 사용")
                self.image = cachedImage
                self.hideSkeleton()
                self.layer.cornerRadius = 4
                return
            }
        }

        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let downloadedImage = UIImage(data: data) else { return }

            // 이미지 리사이징
            let resizedImage = downloadedImage.resized(toWidth: 480)
            if let resizedImage = resizedImage {
                DispatchQueue.main.async {
                    self.image = resizedImage
                    self.layer.cornerRadius = 4
                    self.clipsToBounds = true
                }
                // 리사이징된 이미지를 캐시에 저장하고 이미지 뷰에 설정
                ImageCacheManager.shared.setImage(resizedImage, for: urlString)

            }

        }.resume()
         self.hideSkeleton()
    }

    func loadProfileImage(from url: String, completion: @escaping (UIImage?) -> Void) {

        if let cachedImage = ImageCacheManager.shared.image(for: url) {
            DispatchQueue.main.async {
                print("캐싱이미지 사용")
                completion(cachedImage)
            }
            return
        }

        URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
            self.isSkeletonable = true
            self.showAnimatedGradientSkeleton()
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                    self.hideSkeleton()
                }
                return
            }

            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    // 이미지를 캐시에 추가
                    ImageCacheManager.shared.setImage(image, for: url)
                    completion(image)
                    self.hideSkeleton()
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                    self.hideSkeleton()
                }
            }
        }.resume()
    }

}
