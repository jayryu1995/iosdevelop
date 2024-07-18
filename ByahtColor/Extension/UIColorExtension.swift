//
//  UIColorExtension.swift
//  ByahtColor
//
//  Created by jaem on 2023/08/02.
//

import Foundation
import UIKit

extension UIColor {
    // UIColor에서 RGBA 16진수 문자열로 변환
    var hexString: String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        let alpha = components.count >= 4 ? Float(components[3]) : 1.0

        return String(format: "#%02lX%02lX%02lX%02lX",
                      lroundf(red * 255),
                      lroundf(green * 255),
                      lroundf(blue * 255),
                      lroundf(alpha * 255))
    }

    // 16진수 문자열에서 UIColor로 변환 (RGBA를 지원)
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.hasPrefix("#") ? hex.index(after: hex.startIndex) : hex.startIndex

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r, g, b, a: CGFloat
        switch hex.count {
        case 7: // #RRGGBB
            r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgbValue & 0x0000FF) / 255.0
            a = 1.0
        case 9: // #RRGGBBAA
            r = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgbValue & 0x000000FF) / 255.0
        default:
            r = 0.0
            g = 0.0
            b = 0.0
            a = 1.0
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
