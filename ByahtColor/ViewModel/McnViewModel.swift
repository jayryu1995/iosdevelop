//
//  McnViewModel.swift
//  ByahtColor
//
//  Created by jaem on 9/25/24.
//

import Alamofire
import Combine

class McnViewModel: ObservableObject {
    
    @Published var accountData: McnMyPageDto?
    
    
    // 마이페이지 수정
    func updateMyAccount(memberId: String, dto: McnMyPageDto, image: UIImage?, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/mcn/myPage"
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
    
    // 마이페이지 조회
    func getMyAccount(id: String) {
        let url = "\(Bundle.main.TEST_URL)/mcn/myPage"
        let parameters: [String: Any] = ["id": id]  // id를 파라미터로 설정
        AF.request(url, method: .get, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: McnMyPageDto.self) { response in
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
    
    // 소속 인플루언서 조회
    func loadInfluence(id: String, completion: @escaping (Result<[InfluenceProfileDto], Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/mcn/\(id)"
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
    
    // 인플루언서 등록 및 프로필 업데이트
    func updateProfile(dto: McnInfluenceDto, images: [UIImage], video: URL?, getProfile: Bool, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/mcn/profile/update"
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        var media = 0
        guard let jsonData = try? JSONEncoder().encode(dto) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode dto"])))
            return
        }

        let method: HTTPMethod = getProfile ? .patch : .post
        let influenceId = dto.influenceProfileDto.memberId
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

                    multipartFormData.append(videoFileURL, withName: "file", fileName: "\(influenceId ?? "").mp4", mimeType: "video/mp4")
                } else {
                    
                    // 비디오가 없는 경우에만 이미지 데이터 추가
                    for (index, image) in images.enumerated() {
                        if let imageData = image.jpegData(compressionQuality: 0.8) {
                            multipartFormData.append(imageData, withName: "file", fileName: "\(influenceId ?? "").jpg", mimeType: "image/jpg")
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
}
