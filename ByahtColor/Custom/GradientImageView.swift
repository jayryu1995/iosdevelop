//
//  GradientImageView.swift
//  ByahtColor
//
//  Created by jaem on 7/16/24.
//

import Foundation
import UIKit
import AVFoundation

class GradientImageView: UIImageView {
    private var gradientLayer: CAGradientLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
    }

    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        ]
        gradientLayer.locations = [0.5, 1.0] // Adjust these values to control the gradient position
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }

    func bringGradientLayerToFront() {
        if let gradientLayer = gradientLayer {
            gradientLayer.removeFromSuperlayer()
            layer.addSublayer(gradientLayer)
        }
    }
}
