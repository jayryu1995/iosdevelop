//
//  TimeUtils.swift
//  ByahtColor

import Foundation

public struct DateTimeUtils {
    
    /// 베트남 타임존 상수 (UTC+7)
    public static let vietnamTimeZone = TimeZone(identifier: "Asia/Bangkok")!
    
    /// 기기 로컬 타임존 (사용자 지역 기준, 자동 업데이트)
    public static var localTimeZone: TimeZone {
        return .autoupdatingCurrent
    }
    
    /// 베트남 시간 문자열 → Date
    public static func dateFromVietnamString(_ string: String,
                                             format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let df = DateFormatter()
        df.locale     = Locale(identifier: "en_US_POSIX")
        df.timeZone   = vietnamTimeZone
        df.dateFormat = format
        return df.date(from: string)
    }
    
    /// Date 타임존 보정 (source → target)
    public static func convert(_ date: Date,
                               from source: TimeZone,
                               to target: TimeZone) -> Date {
        let srcOffset = source.secondsFromGMT(for: date)
        let tgtOffset = target.secondsFromGMT(for: date)
        let delta     = TimeInterval(tgtOffset - srcOffset)
        return date.addingTimeInterval(delta)
    }
    
    /// 경과 시간 문자열 생성
    public static func elapsedTimeString(since date: Date) -> String {
        let now   = Date()
        let comps = Calendar.current
            .dateComponents([.day, .hour, .minute, .second],
                            from: date, to: now)
        
        // 한국어
        if Locale.current.languageCode == "ko" {
            if let d = comps.day,    d > 0 { return "\(d)일 전" }
            if let h = comps.hour,   h > 0 { return "\(h)시간 전" }
            if let m = comps.minute, m > 0 { return "\(m)분 전" }
            return "방금 전"
        }
        
        // 영어 (기본)
        // 단수/복수 처리를 위해 1일 때는 단수형, 그 외 복수형
        if let d = comps.day, d > 0 {
            return d == 1 ? "1 day ago" : "\(d) days ago"
        }
        if let h = comps.hour, h > 0 {
            return h == 1 ? "1 hour ago" : "\(h) hours ago"
        }
        if let m = comps.minute, m > 0 {
            return m == 1 ? "1 minute ago" : "\(m) minutes ago"
        }
        return "just now"
    }
    
    /// 편의 메서드: “베트남 시간 문자열” → “로컬 기준 경과 문자열”
    public static func elapsedTimeFromVietnamString(
        _ string: String,
        format: String = "yyyy-MM-dd HH:mm:ss"
    ) -> String? {
        // 1) 문자열 → Date (베트남 TZ)
        guard let vietDate = dateFromVietnamString(string, format: format) else {
            return nil
        }
        // 2) 베트남 → 로컬 TZ 보정
        let localDate = convert(vietDate,
                                from: vietnamTimeZone,
                                to: localTimeZone)
        // 3) 경과 문자열 생성
        return elapsedTimeString(since: localDate)
    }
    public static func elapsedTimeFromVietnamDate(_ vietDate: Date) -> String {
           // 1) 베트남 → 로컬 TZ 보정
           let localDate = convert(vietDate,
                                   from: vietnamTimeZone,
                                   to: localTimeZone)
           // 2) 경과 문자열 생성
           return elapsedTimeString(since: localDate)
       }
}
