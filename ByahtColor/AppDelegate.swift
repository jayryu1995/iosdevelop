//
//  AppDelegate.swift
//  ByahtColor
//
//  Created by jaem on 2023/05/23.
//

import UIKit
import Alamofire
import AlamofireImage
import FBSDKCoreKit
import FirebaseAnalytics
import FirebaseCore
import AuthenticationServices
import FirebaseMessaging
import AdSupport
import AppTrackingTransparency
import SendbirdChatSDK
import GoogleSignIn
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let viewControllerName = String(describing: type(of: AppDelegate.self))
    let device = UIDevice.current
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    var window: UIWindow?
    // 앱 시작 시 기기 정보 기록
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 2.0)

        let uuid = self.device.identifierForVendor?.uuidString
        log(vc: self.viewControllerName, message: "system Version : \(self.device.systemVersion)")
        log(vc: self.viewControllerName, message: "device : \(self.device.name)")
        log(vc: self.viewControllerName, message: "uuid : \(uuid!)")
        log(vc: self.viewControllerName, message: "appVersion : \(self.appVersion!)")

        let param = ["uuid": uuid!]
        UploaderClass().uploadLog(parameters: param) { result in
            switch result {
            case .success(let data):
                // Handle successful response
                log(vc: self.viewControllerName, message: "upload successful. Response data: \(data)")
            case .failure(let error):
                // Handle error
                log(vc: self.viewControllerName, message: "[Error] Upload Failed. Response data: \(error)")
            }
        }

        // 페이스북 api 설정 & Google Login
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        Messaging.messaging().subscribe(toTopic: "all") { _ in
            log(vc: "AppDelegate", message: "Subscribed to all")
        }
        
        UNUserNotificationCenter.current().delegate = self
        requestNotificationAuthorization()
        registerForPushNotifications()


        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
            return GIDSignIn.sharedInstance.handle(url)
        }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // 세로방향 고정
        return UIInterfaceOrientationMask.portrait
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Kingfisher 캐시 지우기
        let cache = ImageCache.default
        
        cache.clearDiskCache {
            print("Disk cache cleared")
        }
        
        cache.clearMemoryCache()
        print("Memory cache cleared")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Kingfisher 캐시 지우기
        let cache = ImageCache.default
        
        cache.clearDiskCache {
            print("Disk cache cleared")
        }
        
        cache.clearMemoryCache()
        print("Memory cache cleared")
    }

}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    private func requestNotificationAuthorization() {
           let center = UNUserNotificationCenter.current()
           center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
               if granted {
                   print("Notification permission granted.")
               } else {
                   print("Notification permission denied.")
               }
           }
       }

    private func registerForPushNotifications() {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }

    private func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
          guard settings.authorizationStatus == .authorized else { return }
          DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
          }
      }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // sendbird 알림
        if let aps = userInfo["aps"] as? NSDictionary,
           let alertMsg = aps["alert"] as? String,
           let payload = userInfo["sendbird"] as? NSDictionary,
           let count = payload["unread_message_count"] as? Int {
           
            print(payload)
            // 알림 메시지와 카운트가 nil이 아닐 때만 실행
            UIApplication.shared.applicationIconBadgeNumber = count
        }

        print("알림 발생")
        
        // firebase 주제 알림메시지 - springboot 전송
        if let data = userInfo["status"] as? String {
            print(data)
            if data == "COMPLETE"{
                print("알림 실행")
                NotificationCenter.default.post(name: Notification.Name("ProfileUpdateNotification"), object: nil)
            }
        }
        
        
        if let title = userInfo["title"] as? String, let status = userInfo["status"] as? String {
            print("Title: \(title), Status: \(status)")
        }
        
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        PushNotificationUseCase().registerPushToken(deviceToken: deviceToken)
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmToken: \\(fcmToken)")
    }
    
    // foreground 상에서 알림이 보이게끔 해준다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let aps = userInfo["aps"] as? NSDictionary,
           let alertMsg = aps["alert"] as? String,
           let payload = userInfo["sendbird"] as? NSDictionary,
           let count = payload["unread_message_count"] as? Int {
           
            print(payload)
            // 알림 메시지와 카운트가 nil이 아닐 때만 실행
            UIApplication.shared.applicationIconBadgeNumber = count
            NotificationCenter.default.post(name: NSNotification.Name("SendbirdPushNotificationReceived"), object: nil)
        }
        
        // firebase 주제 알림메시지 - springboot 전송
        if let data = userInfo["status"] as? String {
            print(data)
            if data == "COMPLETE"{
                print("알림 실행")
                NotificationCenter.default.post(name: Notification.Name("ProfileUpdateNotification"), object: nil)
            }
        }
        
        
        if let title = userInfo["title"] as? String, let status = userInfo["status"] as? String {
            print("Title: \(title), Status: \(status)")
        }
        
        
        
        print("foreground 알림 발생")
        completionHandler([.banner, .sound, .badge])
    }

//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        
//        // userInfo에서 커스텀 플래그 확인
//        if let isCustomNotification = notification.request.content.userInfo["isCustomNotification"] as? Bool, isCustomNotification {
//            // 이미 수정된 알림이므로 무한 반복 방지를 위해 종료
//            completionHandler([.banner, .sound, .badge])
//            return
//        }
//        
//        // 원본 알림 내용을 추출
//        let originalContent = notification.request.content
//        
//        
//        print(originalContent.title)
//        print(originalContent.body)
//        let modifiedContent = UNMutableNotificationContent()
//        
//        // 제목과 본문 등 수정
//        modifiedContent.title = "\(originalContent.title)에서 협업 메시지 도착"
//        modifiedContent.body = "\(originalContent.body)"
//        modifiedContent.sound = .default
//        
//        // 추가 필드 수정 (예: 배지 개수나 사용자 정의 데이터)
//        if let badge = originalContent.badge as? Int {
//            modifiedContent.badge = NSNumber(value: badge)
//        } else {
//            modifiedContent.badge = NSNumber(value: 1)
//        }
//        
//        // 무한 반복 방지 플래그 추가
//        modifiedContent.userInfo["isCustomNotification"] = true
//        
//        // 수정된 내용으로 로컬 알림 표시
//        let request = UNNotificationRequest(identifier: notification.request.identifier, content: modifiedContent, trigger: nil)
//        center.add(request, withCompletionHandler: nil)
//        
//        // 앱 내부에서 NotificationCenter로 알림을 처리해야 하는 경우
//        NotificationCenter.default.post(name: NSNotification.Name("SendbirdPushNotificationReceived"), object: nil)
//        
//        // 테스트용 로그 출력
//        print("사용자 정의 알림 표시")
//        
//        // 원래 알림은 표시되지 않도록 빈 세트를 전달
//        completionHandler([])
//    }


    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            print("Notification response received: \(response.notification.request.content.userInfo)")
            completionHandler()
        }
    
}
