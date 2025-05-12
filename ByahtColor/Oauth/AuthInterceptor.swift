//
//  AuthInterceptor.swift
//  ByahtColor
//
//  Created by jaem on 4/23/25.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    let retryLimit = 1
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 실행")
        print("🔁 retry 실행")

            if let response = request.task?.response as? HTTPURLResponse {
                print("📡 응답 status code:", response.statusCode)
                
                if response.statusCode == 401 && request.retryCount < retryLimit {
                    AuthManager.shared.refreshAccessToken { success in
                        if success {
                            print("✅ 토큰 재발급 성공 → 재시도")
                            completion(.retry)
                        } else {
                            print("❌ 토큰 재발급 실패 → 재시도 안 함")
                            completion(.doNotRetry)
                        }
                    }
                    return
                }
            } else {
                print("⚠️ 응답 객체가 HTTPURLResponse 아님")
            }

            completion(.doNotRetry)

//        AuthManager.shared.refreshAccessToken { success in
//            if success {
//                completion(.retry)
//            } else {
//                // 로그아웃 처리 or 알림
//                //NotificationCenter.default.post(name: .tokenExpired, object: nil)
//                print("token 재발급 실패")
//                completion(.doNotRetry)
//            }
//        }
    }
}
