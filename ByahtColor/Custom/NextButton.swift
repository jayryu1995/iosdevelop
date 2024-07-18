//
//  NextButton.swift
//  ByahtColor
//
//  Created by jaem on 2023/12/28.
//

import UIKit

class NextButton: UIButton {

    // 초기화 메서드
    override init(frame: CGRect = .zero) { // 기본값 .zero를 사용합니다.
        super.init(frame: frame)
        setupButton()
    }

    // Interface Builder에서 사용할 때 필요한 초기화 메서드
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    // 버튼의 스타일을 설정하는 메서드
    private func setupButton() {
        backgroundColor = .black
        setTitle("선택하기", for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        layer.cornerRadius = 12
    }
}
