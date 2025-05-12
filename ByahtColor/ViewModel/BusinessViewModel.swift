//
//  BusinessViewModel.swift
//  ByahtColor
//
//  Created by jaem on 7/3/24.
//

import Foundation
import Alamofire
import Combine
import UIKit


class BusinessViewModel: ObservableObject {
    private let session: Session = {
        let interceptor = AuthInterceptor()
        return Session(interceptor: interceptor)
    }()
    @Published var error: String?
    var cancellables = Set<AnyCancellable>()
    var message: Bool?
    
    var authHeaders: HTTPHeaders {
        return [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"
        ]
    }
    
    // 이메일 저장
    func sendEmail(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        // 서버 URL 설정
        let url = "\(Bundle.main.TEST_URL)/ai/email"
        let parameters: Parameters = ["email": email]
        
        session.request(
            url,
            method: .put,
            parameters: parameters,
            encoding: URLEncoding.default,  // ✅ @RequestParam → URLEncoding
            headers: authHeaders
        )
        .validate()
        .responseString{ response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                print("❌ 이메일 등록 실패: \(error)")
                completion(.failure(error))
            }
        }
        
    }
    
    // 마이페이지 기업정보 업데이트
    func updateMypageInfo(dto: BusinessMyPageDto, completion: @escaping (Result<String, Error>) -> Void) {
        // 서버 URL 설정
        guard let url = URL(string: "\(Bundle.main.TEST_URL)/business/info") else {
            let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(urlError))
            return
        }
        
        // 요청 보내기
        session.request(
            url,
            method: .patch,
            parameters: dto,
            encoder: JSONParameterEncoder.default,
            headers: authHeaders
        ).validate().responseString { response in
            switch response.result {
            case .success(let responseString):
                completion(.success(responseString))
            case .failure(let error):
                // 네트워크 에러를 좀 더 구체적으로 전달
                if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                    let detailedError = NSError(domain: "", code: response.response?.statusCode ?? 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(detailedError))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // 마이페이지 기업정보
    func getBusinessMypageInfo(id: String, completion: @escaping (Result<BusinessMyPageDto, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/business/info"
        session.request(url, method: .get,headers: authHeaders)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BusinessMyPageDto.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // 마이페이지 패스워드 변경
    func updateMypagePassword(dto: BusinessPasswordDto, completion: @escaping (Result<String, Error>) -> Void) {
        // 서버 URL 설정
        guard let url = URL(string: "\(Bundle.main.TEST_URL)/business/update/mypage/password") else {
            let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(urlError))
            return
        }
        
        // 요청 보내기
        AF.request(
            url,
            method: .patch,
            parameters: dto,
            encoder: JSONParameterEncoder.default // Encodable 객체를 JSON으로 인코딩
        ).validate().responseString { response in
            switch response.result {
            case .success(let responseString):
                completion(.success(responseString))
            case .failure(let error):
                // 네트워크 에러를 좀 더 구체적으로 전달
                if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                    let detailedError = NSError(domain: "", code: response.response?.statusCode ?? 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(detailedError))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // 이메일 인증
    func checkVerifyCode(email: String, code: String, completion: @escaping (Result<(Int, String), Error>) -> Void) {
        let baseUrl = "\(Bundle.main.TEST_URL)/email/verify"
        guard var urlComponents = URLComponents(string: baseUrl) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // 쿼리 파라미터 추가
        urlComponents.queryItems = [
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "code", value: code)
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL components"])))
            return
        }
        
        AF.request(url, method: .post)
            .responseString { response in
                switch response.result {
                case .success(let data):
                    if let statusCode = response.response?.statusCode {
                        // 성공: 상태 코드와 데이터를 함께 반환
                        completion(.success((statusCode, data)))
                    } else {
                        // 상태 코드가 없는 경우 예외 처리
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No status code"])))
                    }
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        // 실패: 상태 코드와 에러 메시지 반환
                        completion(.failure(NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])))
                    } else {
                        // 상태 코드가 없는 경우 에러 반환
                        completion(.failure(error))
                    }
                }
            }
    }
    
    
    // 패스워드 계정 조회
    func getFindEmail(id: String, name: String, completion: @escaping (Result<Business, Error>) -> Void) {
        let baseUrl = "\(Bundle.main.TEST_URL)/business/find/password"
        guard var urlComponents = URLComponents(string: baseUrl) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // 쿼리 파라미터 추가
        urlComponents.queryItems = [
            URLQueryItem(name: "memberId", value: id),
            URLQueryItem(name: "managerName", value: name)
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL components"])))
            return
        }
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Business.self) { response in
                switch response.result {
                case .success(let business):
                    completion(.success(business))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
    // 아이디찾기
    func getFindId(name: String, email: String, completion: @escaping (Result<String, Error>) -> Void) {
        let baseUrl = "\(Bundle.main.TEST_URL)/business/find/id"
        guard var urlComponents = URLComponents(string: baseUrl) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // 쿼리 파라미터 추가
        urlComponents.queryItems = [
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "email", value: email)
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL components"])))
            return
        }
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // 이메일 인증
    func pushAuthEmail(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        let baseUrl = "\(Bundle.main.TEST_URL)/email/send"
        guard var urlComponents = URLComponents(string: baseUrl) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // 쿼리 파라미터 추가
        urlComponents.queryItems = [
            URLQueryItem(name: "email", value: email)
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL components"])))
            return
        }
        
        AF.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // 패스워드 재설정
    func updatePassword(businessdto: BusinessDto, completion: @escaping (Result<String, Error>) -> Void) {
        // 서버 URL 설정
        guard let url = URL(string: "\(Bundle.main.TEST_URL)/business/update/password") else {
            let urlError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(urlError))
            return
        }
        
        // 요청 보내기
        AF.request(
            url,
            method: .patch,
            parameters: businessdto,
            encoder: JSONParameterEncoder.default // Encodable 객체를 JSON으로 인코딩
        ).validate().responseString { response in
            switch response.result {
            case .success(let responseString):
                completion(.success(responseString))
            case .failure(let error):
                // 네트워크 에러를 좀 더 구체적으로 전달
                if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                    let detailedError = NSError(domain: "", code: response.response?.statusCode ?? 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(detailedError))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
  
  
}
