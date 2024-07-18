//
//  CustomLabel.swift
//  ByahtColor
//
//  Created by jaem on 2023/08/08.
//

import UIKit
class CustomLabel: UILabel {

    enum CornerType {
        case bottom
        case left
        case both
    }

    var cornerType: CornerType = .both {
        didSet {
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        switch cornerType {
        case .bottom:
            applyBottomCornerRadius()
        case .left:
            applyLeftCornerRadius()
        case .both:
            applyBothCornerRadius()
        }
    }

    private func applyBottomCornerRadius() {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: 15, height: 15))
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }

    private func applyLeftCornerRadius() {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.bottomLeft, .topLeft],
                                cornerRadii: CGSize(width: 5, height: 5))
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }

    private func applyBothCornerRadius() {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.bottomLeft, .bottomRight, .topLeft, .topRight],
                                cornerRadii: CGSize(width: 15, height: 15))
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
