//
//  NotificationViewModel.swift
//  ByahtColor
//
//  Created by jaem on 4/22/25.
//

import Foundation
import Alamofire
import UIKit
class NotificationViewModel: ObservableObject {
    
    private let session: Session = {
        let interceptor = AuthInterceptor()
        return Session(interceptor: interceptor)
    }()
    var authHeaders: HTTPHeaders {
        return [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")"
        ]
    }
    var message: Bool?
    var error: String?
    
    // 읽지 않은 알림 확인
    func checkUnreadNotification(completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/ai/notification/unread"
        
        session.request(url, method: .get, headers: authHeaders)
            .validate()
            .responseDecodable(of: Bool.self) { response in
                switch response.result {
                case .success(let hasUnread):
                    completion(.success(hasUnread))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // 알림 삭제
    func deleteNotification(id: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/ai/notification/\(id)"
        session.request(url, method: .delete, headers: authHeaders)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // 알림 읽음 처리
    func markNotificationsAsRead(ids: [Int], completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/ai/notification/read"
        let body: [String: Any] = ["notificationIds": ids]
        session.request(url, method: .patch, parameters: body, encoding: JSONEncoding.default, headers: authHeaders)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    
                    completion(.success(()))
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
    
    // 알림 리스트 조회
    func requestNotifications(completion: @escaping (Result<[NotificationDataDto], Error>) -> Void) {
        let url = "\(Bundle.main.TEST_URL)/ai/notification"
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        session.request(url, method: .get, headers: authHeaders)
            .validate()
            .responseDecodable(of: [NotificationDataDto].self, decoder: decoder) { response in
                switch response.result {
                case .success(let notifications):
                    completion(.success(notifications))
                case .failure(let error):
                    print("❌ 디코딩 실패: \(error)")
                    completion(.failure(error))
                }
            }
    }

    
}
