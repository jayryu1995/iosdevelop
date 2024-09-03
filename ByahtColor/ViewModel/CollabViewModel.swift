//
//  CollabViewModel.swift
//  ByahtColor
//
//  Created by jaem on 6/5/24.
//

import Foundation
import Alamofire
import Combine

class CollabViewModel: ObservableObject {
    @Published var collabList: [CollabDto] = []
    @Published var isLoading: Bool = false
    var cancellables = Set<AnyCancellable>()

    func loadData(url: String, userId: String, styles: [String], sns: [String]) {
        isLoading = true
        let nation = User.shared.nation
        let parameters = CollabRequestDTO(user_id: userId, styles: styles, sns: sns, nation: nation)
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [CollabDto].self)
            .value()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error loading data: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] collabList in
                self?.collabList = collabList
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    // Collab insert
    func insertCollab(dto : SnapInsertDto, images : [UIImage]?, completion: @escaping (Result<String, Error>) -> Void) {
    
        let url = "\(Bundle.main.TEST_URL)/snap/update"
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]

        guard let jsonData = try? JSONEncoder().encode(dto) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode dto"])))
            return
        }

        AF.upload(multipartFormData: { multipartFormData in
            // 텍스트 데이터 추가
            multipartFormData.append(jsonData, withName: "data", mimeType: "application/json")

            // 이미지 데이터 추가
            if let images = images {
                for (index, image) in images.enumerated() {
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        multipartFormData.append(imageData, withName: "files", fileName: "image_\(index).jpg", mimeType: "image/jpg")
                    }
                }
            }
        }, to: url, method: .post, headers: headers).responseString { response in
            switch response.result {
            case .success(let responseString):
                completion(.success(responseString))
            case .failure(let error):
                completion(.failure(error))
            }

        }
    }
    
    // Collab 수정
    func updateCollab(dto : SnapInsertDto, images : [UIImage]?, completion: @escaping (Result<String, Error>) -> Void) {
    
        let url = "\(Bundle.main.TEST_URL)/snap/update"
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]

        guard let jsonData = try? JSONEncoder().encode(dto) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode dto"])))
            return
        }

        AF.upload(multipartFormData: { multipartFormData in
            // 텍스트 데이터 추가
            multipartFormData.append(jsonData, withName: "data", mimeType: "application/json")
            
            // 이미지 데이터 추가
            if let images = images {
                for (index, image) in images.enumerated() {
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        multipartFormData.append(imageData, withName: "files", fileName: "image_\(index).jpg", mimeType: "image/jpg")
                    }
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
