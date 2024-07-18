//
//  UILabelExtension.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/17.
//

import UIKit

extension UILabel {
    // 라인 간격
    func setLineSpacing(lineSpacing: CGFloat) {
           guard let labelText = self.text else { return }

           let paragraphStyle = NSMutableParagraphStyle()
           paragraphStyle.lineSpacing = lineSpacing

           let attributedString: NSMutableAttributedString
           if let attributedText = self.attributedText {
               attributedString = NSMutableAttributedString(attributedString: attributedText)
               attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
           } else {
               attributedString = NSMutableAttributedString(string: labelText)
               attributedString.addAttributes([
                   .paragraphStyle: paragraphStyle,
                   .font: self.font ?? UIFont.systemFont(ofSize: 16)
               ], range: NSRange(location: 0, length: attributedString.length))
           }

           self.attributedText = attributedString
       }

    // 라벨의 줄수 계산
    func calculateMaxLines() -> Int {
        guard let text = text, !text.isEmpty, let font = font else {
            return 0
        }

        let textStorage = NSTextStorage(string: text)
        let textContainer = NSTextContainer(size: bounds.size)
        let layoutManager = NSLayoutManager()

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textStorage.addAttribute(.font, value: font, range: NSMakeRange(0, textStorage.length))

        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines

        var numberOfLines = 0

        for _ in 0..<textStorage.length {
            let glyphRange = layoutManager.glyphRange(forCharacterRange: NSMakeRange(0, textStorage.length), actualCharacterRange: nil)
            let lineRect = layoutManager.lineFragmentUsedRect(forGlyphAt: glyphRange.location, effectiveRange: nil)

            if lineRect.size.height > 0 {
                numberOfLines += 1
            }
        }

        return numberOfLines
    }
}
