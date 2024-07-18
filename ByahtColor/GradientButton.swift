//
//  GradientButton.swift
//  ByahtColor
//
//  Created by jaem on 2023/07/25.
//

import UIKit

class GradientButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    func setupButton() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor(hex: "28B5E0").cgColor, UIColor(hex: "0496FF").cgColor] // 그라데이션 색상 배열
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // 그라데이션 시작점
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0) // 그라데이션 종료점

        // 그라데이션 레이어를 이미지로 랜더링하여 배경 이미지로 설정
        setBackgroundImage(gradientLayer.toImage(), for: .normal)
        titleLabel?.textColor = UIColor.white
        titleLabel?.font = UIFont(name: "Roboto-Black", size: 16)
    }
}
