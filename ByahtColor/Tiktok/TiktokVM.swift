//
//  TiktokVM.swift
//  ByahtColor
//
//  Created by jaem on 11/20/24.
//

import TikTokOpenAuthSDK

class TiktokVM {

    let authRequest = TikTokAuthRequest(scopes: ["user.info.basic"],
                                        redirectURI: "https://www.example.com/path")
    /* Step 2 */
    func handleTiktokLogin() {
        authRequest.send { response in
            // Step 3: Response 처리
            guard let authResponse = response as? TikTokAuthResponse else {
                print("Invalid response received.")
                return
            }
            
            if authResponse.errorCode == .noError {
                // 성공적인 인증 코드 출력
                print("Auth code: \(authResponse)")
            } else {
                // 실패 시 에러 정보 출력
                let error = authResponse.error ?? "Unknown error"
                let errorDescription = authResponse.errorDescription ?? "No description provided"
                
                print("""
                      Authorization Failed!
                      Error: \(error)
                      Error Description: \(errorDescription)
                      """)
            }
        }
    }

                      
}
