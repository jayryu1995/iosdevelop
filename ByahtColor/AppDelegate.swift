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
        ImageCacheManager.shared.clearCache()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        ImageCacheManager.shared.clearCache()
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
        let alertMsg = (userInfo["aps"] as! NSDictionary)["alert"] as! NSDictionary
        let payload = userInfo["sendbird"] as! NSDictionary
        let count = payload.value(forKey: "unread_message_count") as! Int
        print("didReceiveRemoteNotification: ", count)
        UIApplication.shared.applicationIconBadgeNumber = count

        completionHandler(UIBackgroundFetchResult.newData)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        PushNotificationUseCase().registerPushToken(deviceToken: deviceToken)
    }

    // foreground 상에서 알림이 보이게끔 해준다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NotificationCenter.default.post(name: NSNotification.Name("SendbirdPushNotificationReceived"), object: nil)
        completionHandler([.banner, .sound, .badge])
    }

}
