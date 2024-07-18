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

        // Do any additional setup after loading the view.
        let homeVC: UIViewController
        let magazineVC: UIViewController
        let snapVC: UIViewController
        let likeVC: UIViewController
        let profileVC: UIViewController
        if User.shared.auth == 1 {
            homeVC = AdminCollabVC()
            magazineVC = MagazineView()
            snapVC = BoardVC()
            likeVC = LikeVC()
            profileVC = MyPageVC()
        } else {
            homeVC = CollabVC()
            magazineVC = MagazineView()
            snapVC = BoardVC()
            likeVC = LikeVC()
            profileVC = MyPageVC()
        }

        // 각 tab bar의 viewcontroller 타이틀 설정
        magazineVC.title = "Magazine"
        homeVC.title = "Home"
        snapVC.title = "Talk"
        profileVC.title = "Me"
        likeVC.title = "Like"

        homeVC.tabBarItem.selectedImage = UIImage(named: "icon_home")?.withRenderingMode(.alwaysOriginal)
        homeVC.tabBarItem.image = UIImage(named: "icon_home")

        magazineVC.tabBarItem.image = UIImage(named: "icon_magazine")
        magazineVC.tabBarItem.selectedImage = UIImage(named: "icon_magazine")?.withRenderingMode(.alwaysOriginal)

        likeVC.tabBarItem.image = UIImage(named: "icon_heart")
        likeVC.tabBarItem.selectedImage = UIImage(named: "icon_heart")?.withRenderingMode(.alwaysOriginal)

        snapVC.tabBarItem.image = UIImage(named: "icon_talk")
        snapVC.tabBarItem.selectedImage = UIImage(named: "icon_talk2")?.withRenderingMode(.alwaysOriginal)

        profileVC.tabBarItem.image = UIImage(named: "icon_profile")
        profileVC.tabBarItem.selectedImage = UIImage(named: "icon_profile")?.withRenderingMode(.alwaysOriginal)

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

        // navigationController의 root view 설정
        let navigationHome = UINavigationController(rootViewController: homeVC)
        let navigationMagazine = UINavigationController(rootViewController: magazineVC)
        let navigationSnap = UINavigationController(rootViewController: snapVC)
        let navigationProfile = UINavigationController(rootViewController: profileVC)
        let navigationLike = UINavigationController(rootViewController: likeVC)

        setViewControllers([navigationHome, navigationSnap, navigationProfile], animated: false)
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
