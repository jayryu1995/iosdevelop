import UIKit

extension TabBarViewController {

    @objc func updateAlramReadState() {
        loadAlarmNotification()
    }

    func loadAlarmNotification() {
        viewModel.checkUnreadNotification { result in
            switch result {
            case .success(let hasUnread):
                print("hasUnread : \(hasUnread)")
                DispatchQueue.main.async {
                    self.updateNotificationTabIcon(isOn: hasUnread)
                    self.tabBar.setNeedsLayout()
                    self.tabBar.layoutIfNeeded()
                }
            case .failure(let error):
                print("알림 상태 확인 실패: \(error)")
            }
        }
    }

    func updateNotificationTabIcon(isOn: Bool) {
        if isOn {
            let image = UIImage(named: "icon_notification_on2")
            notificationVC.tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
        }else{
            let image = UIImage(named: "icon_notification")
            notificationVC.tabBarItem.image = image
        }
        let selected = UIImage(named: "icon_notification")
        notificationVC.tabBarItem.selectedImage = selected!.withRenderingMode(.alwaysOriginal)
        
    }
}
