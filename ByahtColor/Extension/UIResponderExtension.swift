//
//  UIResponderExtension.swift
//  ByahtColor
//
//  Created by jaem on 6/21/24.
//

import UIKit

extension UIResponder {
    private weak static var _currentFirstResponder: UIResponder?

    public static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    @objc private func findFirstResponder(_ sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }

}
