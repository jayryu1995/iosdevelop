//
//  KakaoAuthVM.swift
//  ByahtColor
//
//  Created by jaem on 11/18/24.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser
class KakaoAuthVM: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    
    func handleKakaoLogin(completion: @escaping (String?) -> Void) {
        print("KakaoAuthVM - handleKakaoLogin() called")
        
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오 앱으로 로그인
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print("KakaoTalk login failed: \(error)")
                    completion(nil) // 에러 발생 시 nil 반환
                } else {
                    print("loginWithKakaoTalk() success.")
                    _ = oauthToken
                    // 사용자 ID 가져오기
                    self.getId(completion: completion)
                }
            }
        } else { // 카카오톡 미설치 상태 -> 웹으로 이동해 로그인
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print("KakaoAccount login failed: \(error)")
                    completion(nil) // 에러 발생 시 nil 반환
                } else {
                    print("loginWithKakaoAccount() success.")
                    _ = oauthToken
                    // 사용자 ID 가져오기
                    self.getId(completion: completion)
                }
            }
        }
    }

    private func getId(completion: @escaping (String?) -> Void) {
        UserApi.shared.me { (user, error) in
            if let error = error {
                print("Failed to fetch user info: \(error)")
                completion(nil) // 에러 발생 시 nil 반환
            } else if let user = user {
                if let id = user.id {
                    let stringId = String(id)
                    User.shared.id = stringId
                    print("stringId : \(stringId)") // "123"
                    completion(stringId)
                } else {
                    completion(nil)
                }

            } else {
                completion(nil) // 예상치 못한 경우 nil 반환
            }
        }
    }

    
    func kakaoLogOut() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    }
}
