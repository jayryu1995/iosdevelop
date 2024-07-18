//
//  UITextExtension.swift
//  ByahtColor
//
//  Created by jaem on 2023/08/01.
//

import UIKit

// 텍스트 뷰 힌트기능
extension UITextView {
    private struct AssociatedKeys {
        static var placeholderLabel = "placeholderLabel"
    }

    var placeholder: String? {
        get {
            return placeholderLabel?.text
        }
        set {
            if let placeholderLabel = placeholderLabel {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                addPlaceholderLabel(with: newValue)
            }
        }
    }

    private var placeholderLabel: UILabel? {
        return subviews.first(where: { $0 is UILabel && $0.tag == 999 }) as? UILabel
    }

    private func addPlaceholderLabel(with text: String?) {
        guard let text = text, !text.isEmpty else {
            return
        }

        let placeholderLabel = UILabel()
        placeholderLabel.text = text
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 999
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(placeholderLabel)
        placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true

        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
    }

    @objc private func handleTextChange() {
        placeholderLabel?.isHidden = !text.isEmpty
    }

}
