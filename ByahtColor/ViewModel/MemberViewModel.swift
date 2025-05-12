//
//  MemberViewModel.swift
//  ByahtColor
//
//  Created by jaem on 6/18/24.
//

import Foundation
import Alamofire
import Combine

enum SocialLoginType: String {
    case google = "GOOGLE"
    case facebook = "FACEBOOK"
    case kakao = "KAKAO"
    }


class MemberViewModel: ObservableObject {
    
    var tokenDto: TokenDto?
    var message: Bool?
    var error: String?

    // 토큰 발급
    func login(id: String,completion: @escaping (Bool) -> Void) {
        AuthManager.shared.requestToken(id: id){ result in
            switch result {
            case true:
                completion(true)
            case false:
                completion(false)
            }
        }
    }
    
    // 서버 상태 체크
    func checkServerState(completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/ai/admin/"
        print("url : \(url)")
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let exists = value as? Bool {
                    print(exists)
                    completion(.success(exists))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // 기업 로그인
    func loginBusiness(userid: String, password: String, completion: @escaping (Result<BusinessDto, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/business/login"
        let parameters: [String: Any] = [
            "id": userid,
            "password": password
        ]
        AF.request(url, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: BusinessDto.self) { response in
                switch response.result {
                case .success(let business):
                    completion(.success(business))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    // 중복확인
    func checkMemberId(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/member/check/\(id)"
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let exists = value as? Bool {
                    print(exists)
                    completion(.success(exists))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 회원 탈퇴
    func secession(id: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/member/delete/\(id)"
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let value = value as? String {
                    completion(.success(value))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateMemberBusiness(memberBusinessDto: MemberBusinessDto, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/member/update"
        let pdfFileUrl = URL(string: memberBusinessDto.business.licenseFile!)
        let fileName = "\(memberBusinessDto.business.memberId ?? "").pdf"
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            // JSON 데이터를 business_data 파트로 추가
            if let jsonData = try? JSONEncoder().encode(memberBusinessDto) {
                multipartFormData.append(jsonData, withName: "business_data", mimeType: "application/json")
            }
            
            // 파일을 file 파트로 추가 (선택적)
            if let pdfFileUrl = pdfFileUrl {
                multipartFormData.append(pdfFileUrl, withName: "file", fileName: fileName, mimeType: "application/octet-stream")
            }
        }, to: url, headers: headers)
        .validate(statusCode: 200..<300)
        .responseString { response in
            switch response.result {
            case .success(let responseString):
                completion(.success(responseString))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    func updateMemberInfluence(memberInfluenceDto: MemberInfluenceDto, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/influence/signup"
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        AF.request(url, method: .post, parameters: memberInfluenceDto, encoder: JSONParameterEncoder.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success(let responseString):
                    completion(.success(responseString))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}
