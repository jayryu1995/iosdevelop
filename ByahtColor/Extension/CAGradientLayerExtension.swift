//
//  ColorExtension.swift
//  ByahtColor
//
//  Created by jaem on 2023/08/01.
//

import Foundation
import UIKit

// Gradation 색 넣기
extension CAGradientLayer {
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContext(self.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }

        self.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

}
