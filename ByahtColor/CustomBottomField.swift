//
//  CustomProfileField.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/25.
//

import Foundation

import UIKit

class CustomBottomField: UITextField {

    private let bottomLine = CALayer()

    // 테두리 색상을 설정할 수 있도록 프로퍼티 추가
    var lineColor: UIColor = .blue {
        didSet {
            bottomLine.backgroundColor = lineColor.cgColor
        }
    }

    var lineHeight: CGFloat = 1.0 {
        didSet {
            updateBottomLineFrame()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        borderStyle = .none

        // 하단 테두리 설정
        bottomLine.backgroundColor = lineColor.cgColor
        layer.addSublayer(bottomLine)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateBottomLineFrame()
    }

    private func updateBottomLineFrame() {
        let lineFrame = CGRect(x: 0, y: frame.size.height - lineHeight, width: frame.size.width, height: lineHeight)
        bottomLine.frame = lineFrame
    }
}
