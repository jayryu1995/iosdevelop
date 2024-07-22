//
//  TabBarViewController.swift
//  ByahtColor
//
//  Created by jaem on 2023/12/22.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        self.tabBar.superview?.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = UIColor(hex: "#F7F7F7").cgColor
        setupTapbar()

        print("User.shared.auth \(User.shared.auth)")
        if User.shared.auth ?? 0 < 2 {
            let homeVC = InfluenceHomeVC()
            let profileVC = InfluenceProfileVC()
            let communityVC = TalkVC()
            let myPageVC = InfluenceMyPageVC()

            homeVC.title = "Home"
            profileVC.title = "Profile"
            communityVC.title = "Community"
            myPageVC.title = "My Page"

            homeVC.tabBarItem.selectedImage = UIImage(named: "icon_home")?.withRenderingMode(.alwaysOriginal)
            homeVC.tabBarItem.image = UIImage(named: "icon_home")

            communityVC.tabBarItem.image = UIImage(named: "icon_community")
            communityVC.tabBarItem.selectedImage = UIImage(named: "icon_community")?.withRenderingMode(.alwaysOriginal)

            myPageVC.tabBarItem.image = UIImage(named: "icon_mypage")
            myPageVC.tabBarItem.selectedImage = UIImage(named: "icon_mypage")?.withRenderingMode(.alwaysOriginal)

            profileVC.tabBarItem.image = UIImage(named: "icon_profile")
            profileVC.tabBarItem.selectedImage = UIImage(named: "icon_profile")?.withRenderingMode(.alwaysOriginal)

            // navigationController의 root view 설정
            let navigationTab = UINavigationController(rootViewController: homeVC)
            let navigationTab2 = UINavigationController(rootViewController: profileVC)
            let navigationTab3 = UINavigationController(rootViewController: communityVC)
            let navigationTab4 = UINavigationController(rootViewController: myPageVC)

            setViewControllers([navigationTab, navigationTab2, navigationTab3, navigationTab4], animated: false)
        } else if User.shared.auth ?? 0 < 5 {
            let homeVC = BusinessHomeVC()
            let searchVC = BusinessSwipeVC()
            let myPageVC = BusinessMypageVC()
            homeVC.title = "Home"
            searchVC.title = "Search"
            myPageVC.title = "My Page"

            homeVC.tabBarItem.selectedImage = UIImage(named: "icon_home")?.withRenderingMode(.alwaysOriginal)
            homeVC.tabBarItem.image = UIImage(named: "icon_home")

            searchVC.tabBarItem.image = UIImage(named: "icon_tab_search")
            searchVC.tabBarItem.selectedImage = UIImage(named: "icon_tab_search")?.withRenderingMode(.alwaysOriginal)

            myPageVC.tabBarItem.image = UIImage(named: "icon_mypage")
            myPageVC.tabBarItem.selectedImage = UIImage(named: "icon_mypage")?.withRenderingMode(.alwaysOriginal)

            // navigationController의 root view 설정
            let navigationTab = UINavigationController(rootViewController: homeVC)
            let navigationTab2 = UINavigationController(rootViewController: searchVC)
            let navigationTab3 = UINavigationController(rootViewController: myPageVC)

            setViewControllers([navigationTab, navigationTab2, navigationTab3], animated: false)

        }

    }

    private func setupTapbar() {
        // iOS 15 이상에서 UITabBarAppearance를 사용하여 탭 바 스타일 설정
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white // 여기에서 원하는 배경색으로 설정

            // 선택된 탭과 기본 탭의 텍스트 속성을 설정할 수도 있습니다.
            // 예시
            let normalAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            let selectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes

            // 탭 바에 스타일 적용
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance // 스크롤 시에도 동일한 스타일이 적용되도록 함

        } else {
            // iOS 15 미만에서는 이전 방식을 사용
            tabBar.backgroundColor = .white
        }
    }

    // tabBar radius
    private func addTopCornerRadiusToTabBar(tabBar: UITabBar, cornerRadius: CGFloat) {
        let path = UIBezierPath(roundedRect: tabBar.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: 0.0))
        let maskLayer = CAShapeLayer()
        maskLayer.strokeColor = UIColor(hex: "#F7F7F7").cgColor
        maskLayer.frame = tabBar.bounds
        maskLayer.path = path.cgPath
        tabBar.layer.mask = maskLayer
        tabBar.clipsToBounds = true
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false

    }

}
