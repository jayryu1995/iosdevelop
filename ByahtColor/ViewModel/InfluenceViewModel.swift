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
    @Published var profileData: InfluenceProfileDto?
    private var cancellables = Set<AnyCancellable>()
    var message: Bool?
    var error: String?

    
    
    // 기업리스트 가져오기(스와이프)
    func getSearchBusiness( completion: @escaping (Result<[BusinessDetailDto], Error>) -> Void) {
        let id = User.shared.id ?? ""
        let url = "\(Bundle.main.TEST_URL)/influence/search/\(id)"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [BusinessDetailDto].self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // 기업프로필 가져오기
    func getBusinessProfile( member_id: String, completion: @escaping (Result<BusinessDetailDto, Error>) -> Void) {
        let business_id = member_id
        let influence_id = User.shared.id ?? ""
        let url = "\(Bundle.main.TEST_URL)/influence/\(business_id)/proposal/\(influence_id)"
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

    // 인플루언서 프로필 업데이트
    func updateProfile(dto: InfluenceProfileDto, images: [UIImage], video: URL?, getProfile: Bool, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/influence/profile/update"
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        var media = 0
        guard let jsonData = try? JSONEncoder().encode(dto) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode dto"])))
            return
        }

        let method: HTTPMethod = getProfile ? .patch : .post
        func uploadRequest(videoFileURL: URL?) {
            AF.upload(multipartFormData: { multipartFormData in
                // 텍스트 데이터 추가
                multipartFormData.append(jsonData, withName: "data", mimeType: "application/json")

                if let videoFileURL = videoFileURL {
                    media = 1
                    // 파일이 존재하는지 확인
                    guard FileManager.default.fileExists(atPath: videoFileURL.path) else {
                        print("File does not exist at path: \(videoFileURL.path)")
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Video file does not exist"])))
                        return
                    }

                    multipartFormData.append(videoFileURL, withName: "file", fileName: "\(dto.memberId ?? "").mp4", mimeType: "video/mp4")
                } else {
                    
                    // 비디오가 없는 경우에만 이미지 데이터 추가
                    for (index, image) in images.enumerated() {
                        if let imageData = image.jpegData(compressionQuality: 0.8) {
                            multipartFormData.append(imageData, withName: "file", fileName: "\(dto.memberId ?? "").jpg", mimeType: "image/jpg")
                        }
                    }
                }

            }, to: url, method: method, headers: headers).responseString { response in
                switch response.result {
                case .success(let responseString):
                    if media == 0 {
                        NotificationCenter.default.post(name: Notification.Name("ProfileUpdateNotification"), object: nil)
                    }
                    
                    completion(.success(responseString))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

        if let video = video, video.scheme == "http" || video.scheme == "https" {
            // HTTP URL을 로컬 파일로 다운로드
            URLSession.shared.downloadTask(with: video) { (tempFileUrl, _, error) in
                if let error = error {
                    print("Failed to download video: \(error)")
                    completion(.failure(error))
                    return
                }

                guard let tempFileUrl = tempFileUrl else {
                    print("Failed to download video: tempFileUrl is nil")
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to download video"])))
                    return
                }

                // 파일 크기 확인
                do {
                    let fileAttributes = try FileManager.default.attributesOfItem(atPath: tempFileUrl.path)
                    if let fileSize = fileAttributes[.size] as? UInt64 {
                        print("Downloaded file size: \(fileSize) bytes")
                    }
                } catch {
                    print("Failed to get file attributes: \(error)")
                }

                print("Video downloaded to: \(tempFileUrl)")
                uploadRequest(videoFileURL: tempFileUrl)
            }.resume()
        } else {
            // 로컬 파일 URL 사용
            uploadRequest(videoFileURL: video)
        }
    }

    // 인플루언서 홈 데이터 가져오기
    func getHomeData(nation: String?, completion: @escaping (Result<InfluenceHomeDto, Error>) -> Void) {
        let id = User.shared.id ?? ""
        let url = "\(Bundle.main.TEST_URL)/influence/home/\(id)/\(nation)"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: InfluenceHomeDto.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    // 본인 프로필 조회
    func getProfile(id: String) {
        let url = "\(Bundle.main.TEST_URL)/influence/profile/\(id)"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: InfluenceProfileDto.self) { response in
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.profileData = data
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }

    // 본인 프로필 작성페이지 조회
    func getProfileWrite(id: String, completion: @escaping (Result<InfluenceProfileDto, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/influence/profile/\(id)"
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

    // onboarding 계정 이름 등록
    func updateAccountName(newName: String, completion: @escaping (Result<String, Error>) -> Void) {
        // 서버 URL 설정
        let url = "\(Bundle.main.TEST_URL)/influence/account/name"
        let influenceAccountNameDto = InfluenceAccountNameDto(memberId: User.shared.id, name: newName)

        // JSON 인코딩
        guard let jsonData = try? JSONEncoder().encode(influenceAccountNameDto) else {
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
}
