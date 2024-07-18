//
//  StringExtension.swift
//  ByahtColor
//
//  Created by jaem on 2023/07/14.
//

import Foundation

var language: Bool = true

extension String {

    var localized: String {
        var key = ""
        if language {
            key = self
        }

        return NSLocalizedString(key, comment: "")
    }

    func dateToString(inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss", outputFormat: String = "MM/dd") -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = inputFormat
            if let date = dateFormatter.date(from: self) {
                dateFormatter.dateFormat = outputFormat
                return dateFormatter.string(from: date)
            } else {
                return ""
            }
        }

    func stringToDate(inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss", outputFormat: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = outputFormat
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }

    func toInt() -> Int? {
           return Int(self) ?? 0
       }

}
