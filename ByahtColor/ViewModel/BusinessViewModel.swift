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
    @Published var businessDetail: BusinessDetailDto?
    @Published var proposalList: [InfluenceProfileDto] = []
    @Published var error: String?
    var cancellables = Set<AnyCancellable>()
    var message: Bool?
    
    // 마이페이지 기업정보 업데이트
    func updateMypageInfo(dto: BusinessMyPageDto, completion: @escaping (Result<String, Error>) -> Void) {
        // 서버 URL 설정
        guard let url = URL(string: "\(Bundle.main.TEST_URL)/business/info") else {
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
    
    // 마이페이지 기업정보
    func getBusinessMypageInfo(id: String, completion: @escaping (Result<BusinessMyPageDto, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/business/info/\(id)"
        AF.request(url, method: .get)
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
    
    
    
    // businessonboarding 계정 intro 등록
    func updateIntro(intro: String, completion: @escaping (Result<String, Error>) -> Void) {
        // 서버 URL 설정
        let url = "\(Bundle.main.TEST_URL)/business/profile/intro"
        let dto = BusinessOnboardingDto(memberId: User.shared.id, intro: intro)
        
        
        // JSON 인코딩
        guard let jsonData = try? JSONEncoder().encode(dto) else {
            let encodingError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to encode JSON"])
            completion(.failure(encodingError))
            return
        }
        
        // JSON 데이터를 딕셔너리로 변환
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] else {
            let jsonConversionError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert JSON to Dictionary"])
            completion(.failure(jsonConversionError))
            return
        }
        
        // 요청 보내기
        AF.request(url, method: .patch, parameters: jsonObject, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseString { response in
            switch response.result {
            case .success(let responseString):
                completion(.success(responseString))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 홈 화면 데이터 조회
    func findInfluenceById(id: String, completion: @escaping (Result<InfluenceProfileDto, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/business/search/\(id)"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: InfluenceProfileDto.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                    
                }
            }
    }
    
    // 요청받은 제안 내역
    func getProposalProfile() {
        // Construct the URL
        let url = "\(Bundle.main.TEST_URL)/proposal/\(User.shared.id ?? "")"
        
        // Make the network request using Alamofire
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [InfluenceProfileDto].self) { response in
                
                switch response.result {
                case .success(let data):
                    
                    DispatchQueue.main.async {
                        print("데이터 수 : ", data.count)
                        self.proposalList = data
                    }
                case .failure(let error):
                    // On failure, update the error property
                    DispatchQueue.main.async {
                        self.error = error.localizedDescription
                    }
                }
            }
    }
    
    // 인플루언서 리스트(스와이프)
    func getSearchProfile(sns: [String]?, category: [String]?, nation: [String]?, completion: @escaping (Result<[InfluenceProfileDto], Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/business/search"
        
        // 파라미터 딕셔너리 생성
        var parameters: [String: String] = [:]
        
        if let sns = sns {
            parameters["platform"] = sns.joined(separator: ",")
        }
        if let category = category {
            parameters["category"] = category.joined(separator: ",")
        }
        if let nation = nation {
            parameters["nation"] = nation.joined(separator: ",")
        }
        
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [InfluenceProfileDto].self) { response in
                switch response.result {
                case .success(let data):
                    Globals.shared.searchList = data
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // 인플루언서 리스트(스와이프)
    func getSearchProfilePage(sns: [String]?, category: [String]?, nation: [String]?, page: Int, completion: @escaping (Result<[InfluenceProfileDto], Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/business/search"
        
        // 파라미터 딕셔너리 생성
        var parameters: [String: Any] = [:]
        
        if let sns = sns {
            parameters["platform"] = sns.joined(separator: ",")
        }
        if let category = category {
            parameters["category"] = category.joined(separator: ",")
        }
        if let nation = nation {
            parameters["nation"] = nation.joined(separator: ",")
        }
        
        parameters["page"] = String(page)
        parameters["pageSize"] = "10"
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [InfluenceProfileDto].self) { response in
                switch response.result {
                case .success(let data):
                    print("data.count : \(data.count)")
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // 홈 화면 데이터 조회
    func getHomeData(id: String, completion: @escaping (Result<BusinessHomeDto, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/business/home/\(id)"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BusinessHomeDto.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                    
                }
            }
    }
    
    // BusinessWriteVC
    func getBusinessProfile(id: String, completion: @escaping (Result<BusinessDetailDto, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/business/\(id)"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BusinessDetailDto.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // 자신의 기업프로필 조회
    func getBusinessProfile2(id: String) {
        let url = "\(Bundle.main.TEST_URL)/business/\(id)"
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BusinessDetailDto.self) { response in
                switch response.result {
                case .success(let detail):
                    DispatchQueue.main.async {
                        self.businessDetail = detail
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
    // 기업 프로필 업데이트
    func updateProfile(memberId: String, dto: BusinessDetailDto, images: [UIImage], completion: @escaping (Result<String, Error>) -> Void) {
        print("memberId : ",memberId)
        let url = "\(Bundle.main.TEST_URL)/business/\(memberId)"
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        guard let jsonData = try? JSONEncoder().encode(dto) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode dto"])))
            return
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            // 텍스트 데이터 추가
            multipartFormData.append(jsonData, withName: "data", mimeType: "application/json")
            // 이미지 데이터 추가
            for (index, image) in images.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    multipartFormData.append(imageData, withName: "file", fileName: "\(memberId).jpg", mimeType: "image/jpg")
                }
            }
        }, to: url, method: .patch, headers: headers).responseString { response in
            switch response.result {
            case .success(let responseString):
                completion(.success(responseString))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
