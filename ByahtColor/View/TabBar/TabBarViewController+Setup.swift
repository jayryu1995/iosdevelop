import UIKit

extension TabBarViewController {

    func setupAppearance() {
        view.backgroundColor = .white
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor(hex: "#F7F7F7").cgColor

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white

            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.black]

            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.backgroundColor = .white
        }
    }

    func setupViewControllers() {
        let userAuth = User.shared.auth ?? 0

        chatVC.title = "Chats"
        chatVC.tabBarItem.image = UIImage(named: "icon_chat")
        chatVC.tabBarItem.selectedImage = UIImage(named: "icon_chat2")?.withRenderingMode(.alwaysOriginal)

        notificationVC.title = "Notification"
        notificationVC.tabBarItem.image = UIImage(named: "icon_notification")
        notificationVC.tabBarItem.selectedImage = UIImage(named: "icon_notification")?.withRenderingMode(.alwaysOriginal)

        if userAuth < 2 {
            let profileVC = PortfolioVC()
            profileVC.id = User.shared.id ?? ""
            _ = profileVC.view
            profileVC.title = "Portfolio"
            profileVC.tabBarItem.image = UIImage(named: "icon_profile")
            profileVC.tabBarItem.selectedImage = UIImage(named: "icon_profile")?.withRenderingMode(.alwaysOriginal)

            let myPageVC = InfluenceMyPageVC()
            myPageVC.title = "My Page"
            myPageVC.tabBarItem.image = UIImage(named: "icon_mypage")
            myPageVC.tabBarItem.selectedImage = UIImage(named: "icon_mypage")?.withRenderingMode(.alwaysOriginal)

            setViewControllers([
                UINavigationController(rootViewController: chatVC),
                UINavigationController(rootViewController: profileVC),
                UINavigationController(rootViewController: notificationVC),
                UINavigationController(rootViewController: myPageVC)
            ], animated: false)
        } else {
            let searchVC = SearchVC()
            searchVC.title = "Search"
            searchVC.tabBarItem.image = UIImage(named: "icon_tab_search")
            searchVC.tabBarItem.selectedImage = UIImage(named: "icon_tab_search")?.withRenderingMode(.alwaysOriginal)

            let myPageVC = BusinessMypageVC()
            myPageVC.title = "My Page"
            myPageVC.tabBarItem.image = UIImage(named: "icon_mypage")
            myPageVC.tabBarItem.selectedImage = UIImage(named: "icon_mypage")?.withRenderingMode(.alwaysOriginal)

            setViewControllers([
                UINavigationController(rootViewController: chatVC),
                UINavigationController(rootViewController: searchVC),
                UINavigationController(rootViewController: myPageVC)
            ], animated: false)
        }
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification), name: NSNotification.Name("SendbirdPushNotificationReceived"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(updateAlramReadState), name: .didReceiveNewNotification, object: nil)
    }
}
