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
    func updateProfile(memberId: String, dto: BusinessDetailDto, images: [UIImage], update: Bool, completion: @escaping (Result<String, Error>) -> Void) {
        print("memberId : ",memberId)
        let url = "\(Bundle.main.TEST_URL)/business/\(memberId)"
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]

        guard let jsonData = try? JSONEncoder().encode(dto) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode dto"])))
            return
        }

        let method: HTTPMethod = update ? .patch : .post

        AF.upload(multipartFormData: { multipartFormData in
            // 텍스트 데이터 추가
            multipartFormData.append(jsonData, withName: "data", mimeType: "application/json")
            // 이미지 데이터 추가
            for (index, image) in images.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    multipartFormData.append(imageData, withName: "file", fileName: "\(memberId).jpg", mimeType: "image/jpg")
                }
            }
        }, to: url, method: method, headers: headers).responseString { response in
            switch response.result {
            case .success(let responseString):
                completion(.success(responseString))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
