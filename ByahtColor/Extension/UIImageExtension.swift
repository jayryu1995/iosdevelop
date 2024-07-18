//
//  UIImageExtension.swift
//  ByahtColor
//
//  Created by jaem on 2023/08/02.
//

import UIKit
import Photos

// UIImage Extension
// 이미지 크롭 기능 추가
extension UIImage {
    func crop(rect: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        guard let croppedCGImage = cgImage.cropping(to: CGRect(origin: CGPoint(x: rect.minX, y: rect.minY), size: CGSize(width: rect.size.height, height: rect.size.width))) else {
            return nil
        }
        // Create a new UIImage from the cropped CGImage
        return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
    }

    public func resized(to newSize: CGSize, scale: CGFloat = 1) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        let image = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
        return image
    }

    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }

        var transform = CGAffineTransform.identity

        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
        case .up, .upMirrored:
            break
        }

        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }

        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                            bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                            space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx!.concatenate(transform)
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }

        let cgImage = ctx!.makeImage()
        return UIImage(cgImage: cgImage!)
    }

    func resizeAndCompressImage(maxResolution: CGFloat, compressionQuality: CGFloat = 0.5) -> UIImage? {
        let width = self.size.width
        let height = self.size.height

        // 이미지의 가로세로 비율 계산
        let aspectRatio = width / height

        // 새로운 너비와 높이 계산
        var newWidth: CGFloat
        var newHeight: CGFloat
        if aspectRatio > 1 {  // 가로가 세로보다 긴 경우
            newWidth = maxResolution
            newHeight = maxResolution / aspectRatio
        } else {  // 세로가 가로보다 긴 경우 또는 정사각형 이미지
            newHeight = maxResolution
            newWidth = maxResolution * aspectRatio
        }

        let newSize = CGSize(width: newWidth, height: newHeight)

        // 이미지 크기 조정
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // 이미지 압축
        if let resizedImageData = resizedImage?.jpegData(compressionQuality: compressionQuality),
           let compressedImage = UIImage(data: resizedImageData) {
            return compressedImage
        }

        return nil
    }

    func resized(toWidth width: CGFloat, isOpaque: Bool = false) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = isOpaque
        let renderer = UIGraphicsImageRenderer(size: canvasSize, format: format)
        return renderer.image { (_) in
            draw(in: CGRect(origin: .zero, size: canvasSize))
        }
    }
}
