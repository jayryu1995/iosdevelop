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
    private var cancellables = Set<AnyCancellable>()
    var message: Bool?
    var error: String?

    // 인플루언서 리스트(스와이프)
    func getSearchProfile( completion: @escaping (Result<[InfluenceProfileDto], Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/business/search"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [InfluenceProfileDto].self) { response in
                switch response.result {
                case .success(let data):
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
                    multipartFormData.append(imageData, withName: "file", fileName: "\(memberId)_\(index).jpg", mimeType: "image/jpg")
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
