//
//  SceneDelegate.swift
//  ByahtColor
//
//  Created by jaem on 2023/05/23.
//
import AdSupport
import AppTrackingTransparency
import FirebaseAnalytics
import FBSDKCoreKit
import KakaoSDKAuth
import TikTokOpenSDKCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // 페이스북, 카카오
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // URLContexts에서 URL 가져오기
        guard let url = URLContexts.first?.url else {
            return
        }

        // 페이스북 URL 처리 (URL이 페이스북 로그인과 관련된 경우에만 실행)
        if url.absoluteString.contains("fb") { // 페이스북 관련 URL인지 확인
            ApplicationDelegate.shared.application(
                UIApplication.shared,
                open: url,
                sourceApplication: nil,
                annotation: [UIApplication.OpenURLOptionsKey.annotation]
            )
        }
        
        // 카카오톡 로그인 URL 처리
        if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
        }
        
        // 틱톡
        if (TikTokURLHandler.handleOpenURL(URLContexts.first?.url)) {
            return
        }
    }


    func sceneDidBecomeActive(_ scene: UIScene) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        print("enable tracking")
                    case .denied:
                        print("disable tracking")
                    default:
                        print("default tracking")
                    }
                }
            }

        })
    }

    // 상단 네비게이션 바 설정
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: UIFont(name: "Pretendard-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16)
            ]
            appearance.shadowColor = nil // 선을 없애기 위해 추가

            // 적용
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            // iOS 15.0 미만의 경우
            UINavigationBar.appearance().barTintColor = .white
            UINavigationBar.appearance().titleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: UIFont(name: "Pretendard-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16)
            ]
            UINavigationBar.appearance().shadowImage = nil
        }

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

 
    
}
