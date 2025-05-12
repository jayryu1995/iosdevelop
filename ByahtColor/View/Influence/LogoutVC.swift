//
//  LogoutVC.swift
//  ByahtColor
//
//  Created by jaem on 4/14/25.
//

import Foundation
import UIKit
import SnapKit
import FBSDKLoginKit

class LogoutVC : UIViewController {
    
    lazy private var logoutButton = {
        let view = UIButton()
        view.setTitle("influence_mypage_write_logout".localized, for: .normal)
        view.setImage(UIImage(named: "logout_icon"), for: .normal)
        view.addTarget(self, action: #selector(facebookLogout), for: .touchUpInside)
        view.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        view.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        view.imageView?.backgroundColor = UIColor(hex: "#F7F7F7")
        view.imageView?.layer.cornerRadius = 4
        
        return view
    }()
    
    lazy private var secessionButton = {
        let deleteButton = UIButton()
        deleteButton.setTitle("influence_mypage_write_secession".localized, for: .normal)
        deleteButton.setImage(UIImage(named: "secession_icon"), for: .normal)
        deleteButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        deleteButton.setTitleColor(UIColor.red, for: .normal) // 텍스트 색상을 빨강으로 설정
        deleteButton.imageView?.backgroundColor = UIColor(hex: "#F7F7F7")
        deleteButton.imageView?.layer.cornerRadius = 4
        
        return deleteButton
    }()
    
    
    override func viewDidLoad(){
        view.addSubview(logoutButton)
        view.addSubview(secessionButton)
        setupConstraints()
    }
    
    private func setupConstraints(){
        logoutButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
        }

        secessionButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(24)
            $0.leading.equalTo(logoutButton.snp.leading)
            $0.height.equalTo(44)
        }
    }
    
    @objc func facebookLogout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "nickname")
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "businessId")
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        let loginManager = LoginManager()
        loginManager.logOut()

        SendbirdUser.shared.logout {
            print("sendbird 로그아웃 완료")
        }
        
        // SceneDelegate에 접근하여 rootViewController를 변경합니다.
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = nil // 기존 컨트롤러 해제
            let loginViewController = InitialViewController()
            let navigationController = UINavigationController(rootViewController: loginViewController)
            sceneDelegate.window?.rootViewController = navigationController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    @objc private func deleteTapped() {
        let customAlertVC = ProfileAlertVC()
        customAlertVC.modalPresentationStyle = .overCurrentContext
        customAlertVC.modalTransitionStyle = .crossDissolve

        self.present(customAlertVC, animated: true, completion: nil)
    }
}
