//
//  UITextFiledExtension.swift
//  ByahtColor
//
//  Created by jaem on 6/12/24.
//

import UIKit

extension UITextField {
    func leftPadding() {
            // 1
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
            // 2
            self.leftView = paddingView
            // 3
            self.leftViewMode = ViewMode.always
        }
}
