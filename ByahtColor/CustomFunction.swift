//
//  ToastMessage.swift
//  ByahtColor
//
//  Created by jaem on 2023/06/13.
//

import UIKit
import Alamofire
import MLKit
import MLImage
class CustomFunction {
    // 날짜로 자르기
    func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM-dd"
            return outputFormatter.string(from: date)
        } else {
            return ""
        }
    }
    // 원 영역 자르기 //
    func cropImageToCircle(image: UIImage, cropRect: CGRect) -> UIImage? {
        let imageSize = image.size
        let circleSize = CGSize(width: cropRect.height, height: cropRect.width)

        UIGraphicsBeginImageContextWithOptions(circleSize, false, image.scale)
        defer { UIGraphicsEndImageContext() }

        let circlePath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: circleSize))
        circlePath.addClip()

        image.draw(in: CGRect(origin: CGPoint(x: (circleSize.width - imageSize.width) / 2, y: (circleSize.height - imageSize.height) / 2), size: imageSize))

        guard let croppedImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        return croppedImage
    }

    // 배경 제거
    func detectSegmentationMask(segmenter: Segmenter, image: UIImage, completion: @escaping (UIImage?) -> Void) {

        // Initialize a `VisionImage` object with the given `UIImage`.

        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation

        segmenter.process(visionImage) { mask, error in
            if let error = error {
                print("Error processing the image: \(error)")
                completion(nil)
                return
            }

            guard let mask = mask, let imageBuffer = UIUtilities.createImageBuffer(from: image) else {
                print("Failed to process the image or create an image buffer.")
                completion(nil)
                return
            }

            UIUtilities.applySegmentationMask(
                mask: mask, to: imageBuffer,
                backgroundColor: UIColor.white,
                foregroundColor: nil)

            let maskedImage = UIUtilities.createUIImage(from: imageBuffer, orientation: .up)
            completion(maskedImage)

        }
    }

    // 하단 모서리 Radious
    func roundCorners(view: UIView, corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }

    // toastMessage
    func showToast(message: String, font: UIFont, view: UIView) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 125, y: view.frame.size.height/2, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.systemGray
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(_) in
            toastLabel.removeFromSuperview()
        })
    }

    func showToastLong(message: String, font: UIFont, view: UIView) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 125, y: view.frame.size.height-100, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.systemGray
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(_) in
            toastLabel.removeFromSuperview()
        })
    }

    // customButton
    func showButton(title: String, font: UIFont, view: UIView) -> UIButton {
        let button = UIButton(frame: CGRect(x: view.frame.size.width/2 - 40, y: view.frame.size.height-60, width: 80, height: 35))
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle(title, for: .normal)
        button.alpha = 1.0
        button.layer.cornerRadius = 10
        button.clipsToBounds  =  true

        return button
    }

}
