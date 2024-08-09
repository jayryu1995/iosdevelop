//
//  MemberViewModel.swift
//  ByahtColor
//
//  Created by jaem on 6/18/24.
//

import Foundation
import Alamofire
import Combine

class MemberViewModel: ObservableObject {

    var message: Bool?
    var error: String?

    let headers: HTTPHeaders = [
        .contentType("application/json")
    ]

    // 서버 상태 체크
    func checkServerState(completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/"
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

    // 기업 자동로그인
    func loginAutoBusiness(userid: String, completion: @escaping (Result<BusinessDataDto, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/member/data/\(userid)"
        AF.request(url).validate().response { response in
            switch response.result {
            case .success(let value):
                if let exists = value as? BusinessDataDto {
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

    // 로그인 데이터
    func getLoginData(member_id: String, completion: @escaping (Result<InfluenceDataDto, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/member/data/\(member_id)"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: InfluenceDataDto.self) { response in
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        User.shared.id = data.memberId
                        User.shared.name = data.name
                        User.shared.auth = data.auth
                    }
                    print("success: \(data)")
                    completion(.success(data))
                case .failure(let error):
                    print("Error: \(error)")
                    completion(.failure(error))
                }
            }

    }

    // 인플루언서 로그인 및 권한조회
    func login(id: String, completion: @escaping (Result<Int, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/member/login/\(id)"
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let exists = value as? Int {
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
        AF.request(url, method: .post, parameters: memberBusinessDto, encoder: JSONParameterEncoder.default, headers: headers)
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
