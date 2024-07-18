//
//  UIButtonExtension.swift
//  ByahtColor
//
//  Created by jaem on 2023/12/22.
//

import UIKit

extension UIButton {
    private struct AssociatedKeys {
            static var gradientLayerKey = "gradientLayerKey"
        }

        private var gradientLayer: CAGradientLayer? {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.gradientLayerKey) as? CAGradientLayer
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.gradientLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))

        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setBackgroundImage(backgroundImage, for: state)
    }
    // 버튼 이미지 상단배치,텍스트 하단 배치
    func alignTextBelow(spacing: CGFloat = 4.0) {
        guard let image = self.imageView?.image else {
            return
        }

        guard let titleLabel = self.titleLabel else {
            return
        }

        guard let titleText = titleLabel.text else {
            return
        }

        let titleSize = titleText.size(withAttributes: [
            NSAttributedString.Key.font: titleLabel.font as Any
        ])

        titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }

    func applyGradient(colors: [CGColor], locations: [NSNumber]? = nil, startPoint: CGPoint, endPoint: CGPoint, transform: CATransform3D = CATransform3DIdentity) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.transform = transform
        gradientLayer.frame = self.bounds

        // 이전에 추가된 그라디언트 레이어가 있으면 제거
        if let oldGradientLayer = self.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            oldGradientLayer.removeFromSuperlayer()
        }

        self.layer.insertSublayer(gradientLayer, at: 0)
    }

}
