//
//  Module.swift
//  ByahtColor
//
//  Created by jaem on 4/21/25.
//

import Alamofire
import Foundation
import FirebaseMessaging
import SVGKit
import UIKit
// svg image process

func loadImage(from urlString: String, into imageContainer: UIView) {
    guard let url = URL(string: urlString.lowercased()) else { return }

    if url.pathExtension == "svg" {
        // SVG 처리 (SVGKit)
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("❌ SVG 다운로드 실패:", error?.localizedDescription ?? "")
                return
            }

            DispatchQueue.main.async {
                if let svgImage = SVGKImage(data: data) {
                    let svgView = SVGKFastImageView(svgkImage: svgImage)!
                    svgView.contentMode = .scaleAspectFit
                    svgView.frame = imageContainer.bounds
                    svgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    imageContainer.addSubview(svgView)
                } else {
                    print("❌ SVG 렌더링 실패")
                }
            }
        }.resume()

    } else {
        // 일반 이미지 처리 (Kingfisher)
        if let imageView = imageContainer as? UIImageView {
            DispatchQueue.main.async {
                imageView.kf.setImage(with: url)
            }
        } else {
            print("⚠️ imageContainer가 UIImageView가 아니에요! Kingfisher는 UIImageView에서만 사용 가능해요.")
        }
    }
}


// 커스텀 RawData 인코딩 정의
struct RawDataEncoding: ParameterEncoding {
    private let data: Data

    init(data: Data) {
        self.data = data
    }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data
        return request
    }
}

func decodeJWT(token: String) -> Int? {
    let parts = token.components(separatedBy: ".")

    // JWT는 보통 3개의 파트로 구성
    guard parts.count == 3 else {
        print("❌ Invalid token format")
        return nil
    }

    let payload = parts[1]
    var decodedPayload = payload
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

    // base64 padding 보정
    while decodedPayload.count % 4 != 0 {
        decodedPayload += "="
    }

    // base64 디코딩 및 JSON 파싱
    guard let data = Data(base64Encoded: decodedPayload),
          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        print("❌ Failed to decode base64 or parse JSON")
        return nil
    }

    // userId 설정
    if let userId = json["userId"] as? String {
        print("🆔 userId: \(userId)")
        User.shared.id = "\(userId)"
        // 개인 FCM 설정
        if let assetId = User.shared.id {
            Messaging.messaging().subscribe(toTopic: assetId) { _ in
                print("Subscribed to MediaConvertFCM \(assetId)")
            }
        }
    }

    // 권한(auth) 추출
    if let authArray = json["auth"] as? [[String: Any]],
       let authority = authArray.first?["authority"] as? String {
        print("🔐 authority: \(authority)")

        let role: Int
        switch authority {
        case "ROLE_USER":
            role = 0
        case "INVALID_ROLE_BUSINESS":
            role = 2
        case "ROLE_BUSINESS":
            role = 3
        case "ROLE_ADMIN":
            role = 4
        default:
            role = -1
        }

        User.shared.auth = role
        return role
    }

    return nil
}

// 시간 차이 계산 메서드 추가
func calculateTimeDifference(from milliseconds: Int64) -> String {
    let messageDate = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    let currentDate = Date()

    let difference = currentDate.timeIntervalSince(messageDate)
    
    let minutesDifference = Int(difference / 60)
    let hoursDifference = Int(difference / 3600)
    let daysDifference = Int(difference / (3600 * 24))

    let dateFormatter = DateFormatter()
    let calendar = Calendar.current

    let messageYear = calendar.component(.year, from: messageDate)
    let currentYear = calendar.component(.year, from: currentDate)

    if daysDifference > 0 {
        if daysDifference > 7 {
            // 로케일에 따라 날짜 포맷 설정
            let isAsianLanguage: Bool = {
                let preferredLanguage = Locale.preferredLanguages.first ?? "en"
                let asianLanguages = ["ko", "zh", "ja"]
                return asianLanguages.contains(String(preferredLanguage.prefix(2))) // Substring을 String으로 변환
            }()

            print("isAsianLocale :  \(isAsianLanguage)")
            if messageYear == currentYear {
                dateFormatter.setLocalizedDateFormatFromTemplate(isAsianLanguage ? "MMdd" : "ddMM")
            } else {
                dateFormatter.setLocalizedDateFormatFromTemplate(isAsianLanguage ? "yyyyMMdd" : "ddMMyyyy")
            }
//                dateFormatter.locale = Locale.current
            return dateFormatter.string(from: messageDate)
        } else {
            return "\(daysDifference)일 전"
        }
    } else if hoursDifference > 0 {
        return "\(hoursDifference)시간 전"
    } else {
        return "\(minutesDifference)분 전"
    }
}
