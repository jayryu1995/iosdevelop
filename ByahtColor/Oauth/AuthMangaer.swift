//
//  AuthMangaer.swift
//  ByahtColor
//
//  Created by jaem on 4/23/25.
//

import Foundation
import Alamofire

class AuthManager {
    static let shared = AuthManager()

    private init() {}

    // 토큰 재발급
    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/auth/refreshToken"
        var authHeaders: HTTPHeaders {
            return [
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "refreshToken") ?? "")"
            ]
        }

        AF.request(url, method: .post, headers: authHeaders)
            .responseDecodable(of: TokenDto.self) { response in
                print(response)
                switch response.result {
                    
                case .success(let tokenData):
                    UserDefaults.standard.set(tokenData.accessToken, forKey: "accessToken")
                    UserDefaults.standard.set(tokenData.refreshToken, forKey: "refreshToken")
                    print("token 재발급 완료 : ")
                    print("accessToken : \(tokenData.accessToken)")
                    print("refreshToken : \(tokenData.refreshToken)")
                    completion(true)
                case .failure:
                    completion(false)
                }
            }
    }
    
    // 토큰 발급
    func requestToken(id: String, completion: @escaping (Bool) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/influence/token"

        let requestBody = id  // "influencer123" 형식
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]

        let encoding = RawDataEncoding(data: requestBody.data(using: .utf8)!)  // 직접 바디 인코딩

        AF.request(url,
                   method: .post,
                   parameters: nil,
                   encoding: encoding,
                   headers: headers)
        .validate()
        .responseDecodable(of: TokenDto.self) { response in
            switch response.result {
            case .success(let tokenDto):
                UserDefaults.standard.set(tokenDto.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(tokenDto.refreshToken, forKey: "refreshToken")
                print("토큰 발급 완료")
                completion(true)
            case .failure(let error):
                print(response.data.flatMap { String(data: $0, encoding: .utf8) } ?? "❌ no response body")
                completion(false)
            }
        }
    }

}
