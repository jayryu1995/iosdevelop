//
//  DateExtension.swift
//  ByahtColor
//
//  Created by jaem on 7/23/24.
//

import UIKit

extension Date {
    /// Default date formats.
    /// - Since: 2.1.13
    public enum SBUDateFormat: String {
        case EMMMyyyy = "E, MMM yyyy"
        case MMMddyyyy = "MMM dd, yyyy"
        case EMMMdd = "E, MMM dd"
        case MMMdd = "MMM dd"
        case hhmma = "hh:mm a"
        case hhmm = "hh:mm"
        case yyyyMMddhhmm = "yyyyMMddhhmm"
        case yyyyMMddhhmmss = "yyyyMMddhhmmss"
        case yyyyMMdd = "yyyyMMdd"
        case ko = "yyyy년 MM월 dd일"
        case jp = "yyyy年 MM月 dd日"
        case global = "MM/dd/yyyy"
    }

    /// The `Date` value represents the time interval since 1970 with the time stamp
    /// - Parameter baseTimestamp: The `Int64` value representing the base timestamp.
    /// - Since: 2.2.0
    static public func sbu_from(_ baseTimestamp: Int64) -> Date {
        let timestampString = String(format: "%lld", baseTimestamp)
        let timeInterval = timestampString.count == 10
            ? TimeInterval(baseTimestamp)
            : TimeInterval(Double(baseTimestamp) / 1000.0)
        return Date(timeIntervalSince1970: timeInterval)
    }

    /// Gets string value with `SBUDateFormat`.
    /// - Parameters:
    ///    - format: The `SBUDateFormat` value.
    ///    - localizedFormat: If `true`, it sets localized date format.
    /// - Note: If you want to use your own date format, please see `sbu_toString(formatString:localizedFormat:)`.
    /// - Since: 2.1.13
    public func sbu_toString(format: SBUDateFormat, localizedFormat: Bool = false) -> String {
        self.sbu_toString(formatString: format.rawValue, localizedFormat: localizedFormat)
    }

    /// Gets string value with own date format string.
    /// - Parameters:
    ///   - formatString: The string value representing the date format.
    ///   - localizedFormat: If `true`, it sets localized date format.
    /// - Since: 2.1.13
    public func sbu_toString(formatString: String, localizedFormat: Bool = true) -> String {
        let formatter = DateFormatter()

            let languageCode = Locale.preferredLanguages.first?.prefix(2)

            if languageCode == "ko" {
                print("한국어")
                // 한국 로컬의 경우 커스텀 형식 사용
                formatter.dateFormat = SBUDateFormat.ko.rawValue
            } else if languageCode == "ja" {
                formatter.dateFormat = SBUDateFormat.jp.rawValue
            } else {
                formatter.dateFormat = SBUDateFormat.global.rawValue
            }

        return formatter.string(from: self)
    }

    static func lastUpdatedTime(baseTimestamp: Int64) -> String? {
        let baseDate = Date.sbu_from(baseTimestamp)
        let currDate = Date()

        let baseDateComponents = Calendar.current
            .dateComponents([.day, .month, .year], from: baseDate)
        let currDateComponents = Calendar.current
            .dateComponents([.day, .month, .year], from: currDate)

        if baseDateComponents.year != currDateComponents.year ||
            baseDateComponents.month != currDateComponents.month ||
            baseDateComponents.day != currDateComponents.day {

            if baseDateComponents.day != currDateComponents.day {
                let interval = (currDateComponents.day ?? 0) - (baseDateComponents.day ?? 0)
                if interval == 1 {
                    return "Yesterday"
                }
            }

            return baseDate.sbu_toString(format: .MMMdd)
        } else {
            return baseDate.sbu_toString(format: .hhmma)
        }
    }

    func isSameDay(as otherDate: Date) -> Bool {
        let baseDate = self
        let otherDate = otherDate

        let baseDateComponents = Calendar.current.dateComponents(
            [.day, .month, .year],
            from: baseDate
        )
        let otherDateComponents = Calendar.current.dateComponents(
            [.day, .month, .year],
            from: otherDate
        )

        if baseDateComponents.year == otherDateComponents.year,
            baseDateComponents.month == otherDateComponents.month,
            baseDateComponents.day == otherDateComponents.day {
            return true
        } else {
            return false
        }
    }

    public func nextDay() -> Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
}
