//
//  RadiusUIView.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/02.
//

import UIKit

class RadiusUIView: UIView {

    // 초기화 메서드
    override init(frame: CGRect = .zero) { // 기본값 .zero를 사용합니다.
        super.init(frame: frame)
        setupView()
    }

    // Interface Builder에서 사용할 때 필요한 초기화 메서드
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // 버튼의 스타일을 설정하는 메서드
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 16

    }
}
