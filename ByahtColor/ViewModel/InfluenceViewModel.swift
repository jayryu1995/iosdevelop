//
//  InfluenceViewModel.swift
//  ByahtColor
//
//  Created by jaem on 6/25/24.
//

import Foundation
import Alamofire
import Combine
import UIKit


class InfluenceViewModel: ObservableObject {
    @Published var accountData: InfluenceMyPageDto?
    private var cancellables = Set<AnyCancellable>()
    var message: Bool?
    var error: String?

    

    // 마이페이지 조회
    func getMyAccount(id: String) {
        let url = "\(Bundle.main.TEST_URL)/influence/\(id)"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: InfluenceMyPageDto.self) { response in
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.accountData = data
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }

    // 마이페이지 수정
    func updateMyAccount(memberId: String, dto: InfluenceMyPageDto, image: UIImage?, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/influence/\(memberId)"
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]

        guard let jsonData = try? JSONEncoder().encode(dto) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode dto"])))
            return
        }

        AF.upload(multipartFormData: { multipartFormData in
            // 텍스트 데이터 추가
            multipartFormData.append(jsonData, withName: "data", mimeType: "application/json")

            if let image = image {
                if let imageData = image.jpegData(compressionQuality: 1080) {
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
