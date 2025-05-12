import UIKit
import SendbirdChatSDK

extension TabBarViewController {

    func initSendBird() {
        SendbirdConfig.initializeSendbirdSDK()
        guard let id = User.shared.id else { return }

        SendbirdUser.shared.login(userId: id) { result in
            switch result {
            case .success:
                print("✅ Sendbird 로그인 성공")
                print("✅ Sendbird ID : \(id)")
                if let nickname = SendbirdUser.shared.currentUser?.nickname{
                    print("✅ Sendbird ID : \(nickname)")
                    User.shared.nickname = nickname
                }
                
                self.updateReadState()
                //self.updateChatProfile()
                self.setNotification()
                NotificationCenter.default.post(name: NSNotification.Name("LoginSuccess"), object: nil)
            case .failure(let error):
                print("❌ Sendbird 로그인 실패: \(error)")
            }
        }
    }

    @objc func handlePushNotification() {
        updateReadState()
    }

    func updateReadState() {
        SendbirdUser.shared.unReadMessages { result in
            switch result {
            case .success(let count):
                print("count: \(count)")
                DispatchQueue.main.async {
                    self.updateChatTabIcon(hasUnread: count > 0)
                }
            case .failure(let error):
                print("❌ 채팅 읽지 않은 메시지 확인 실패: \(error)")
            }
        }
    }

    func updateChatTabIcon(hasUnread: Bool) {
        let imageName = hasUnread ? "icon_chat3" : "icon_chat"
        let selectedImageName = hasUnread ? "icon_chat4" : "icon_chat2"

        chatVC.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        chatVC.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
    }

    func updateChatProfile() {
        
        var nickname = ""
        if User.shared.nickname != "" && User.shared.nickname != nil {
            nickname = User.shared.nickname!
        }else{
            nickname = "default"
        }
        SendbirdUser.shared.updateUserInfo(nickname: nickname,profileImage: nil) { result in
            switch result {
            case .success:
                print("✅ Sendbird 프로필 업데이트 성공")
            case .failure(let error):
                print("❌ Sendbird 프로필 업데이트 실패: \(error)")
            }
        }
    }

    func setNotification() {
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }
}
