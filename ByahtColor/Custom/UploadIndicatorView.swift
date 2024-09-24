//
//  UploadIndicatorView.swift
//  ByahtColor
//
//  Created by jaem on 9/20/24.
//

import Foundation
import UIKit

class UploadIndicatorView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let dot1 = UIView()
    private let dot2 = UIView()
    private let dot3 = UIView()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        startAnimatingDots()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        startAnimatingDots()
    }

    private func setupView() {
        // View의 배경 색을 흰색으로 설정
        backgroundColor = .white

        // 동그라미 설정
        [dot1, dot2, dot3].forEach { dot in
            dot.backgroundColor = .black
            dot.layer.cornerRadius = 8 // 반지름을 설정하여 원 모양으로 만듬
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.heightAnchor.constraint(equalToConstant: 16).isActive = true
            dot.widthAnchor.constraint(equalToConstant: 16).isActive = true
            stackView.addArrangedSubview(dot)
        }

        // StackView와 Label을 추가
        let mainStack = UIStackView(arrangedSubviews: [titleLabel, stackView])
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStack)

        // mainStack의 제약 설정
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func startAnimatingDots() {
        animateDot(dot: dot1, delay: 0)
        animateDot(dot: dot2, delay: 0.1)
        animateDot(dot: dot3, delay: 0.2)
    }

    private func animateDot(dot: UIView, delay: TimeInterval) {
        UIView.animateKeyframes(withDuration: 1.5, delay: delay, options: [.repeat, .autoreverse], animations: {
            dot.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: nil)
    }
}
