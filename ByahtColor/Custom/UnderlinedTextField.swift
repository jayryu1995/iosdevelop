//
//  UnderLineTextView.swift
//  ByahtColor
//
//  Created by jaem on 2024/03/06.
//
import UIKit

class UnderlinedTextField: UITextField {

    let bottomLine = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        // 하단 테두리 설정
        bottomLine.backgroundColor = UIColor(hex: "#BCBDC0") // 테두리 색상 설정
        addSubview(bottomLine)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1) // 테두리 두께 설정
        ])
    }
}

extension UnderlinedTextField {
    func configure(withPlaceholder placeholder: String, font: UIFont?) {
        self.placeholder = placeholder
        self.font = font
        let placeholderColor = UIColor(hex: "#BCBDC0")
        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: placeholderColor]
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        self.textColor = .black
        self.backgroundColor = .white
    }
}
