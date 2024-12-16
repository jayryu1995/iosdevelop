//
//  BusinessLogoutVC.swift
//  ByahtColor
//
//  Created by jaem on 6/29/24.
//

import Foundation
import UIKit
import SnapKit
import FBSDKLoginKit
import FBSDKCoreKit
class BusinessLogoutVC: UIViewController {

    private let bottomView = UIView()
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "business_profile_label".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#4E505B")
        return label
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("business_profile_logout".localized, for: .normal)
        button.setImage(UIImage(named: "logout_icon"), for: .normal)
        button.addTarget(self, action: #selector(facebookLogout), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        button.backgroundColor = UIColor(hex: "#F7F7F7")
        button.layer.cornerRadius = 4
        return button
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("business_profile_secession".localized, for: .normal)
        button.setImage(UIImage(named: "secession_icon"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        button.setTitleColor(UIColor.red, for: .normal) // 텍스트 색상을 빨강으로 설정
        button.backgroundColor = UIColor(hex: "#F7F7F7")
        button.layer.cornerRadius = 4
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        self.navigationItem.title = "business_profile_title".localized
        setupBackButton()
        setupBottomView()
    }

    private func setupBottomView() {
        view.addSubview(bottomView)
        bottomView.isUserInteractionEnabled = true
        
        bottomView.addSubview(infoLabel)
        bottomView.addSubview(logoutButton)
        bottomView.addSubview(deleteButton)
    }

    private func setupConstraints() {
        
        bottomView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).multipliedBy(3)
            $0.leading.trailing.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        }

        logoutButton.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(32)
            $0.trailing.equalTo(view.snp.centerX).offset(-22)
            $0.width.equalTo(106)
            $0.height.equalTo(44)
        }

        deleteButton.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(32)
            $0.leading.equalTo(view.snp.centerX).offset(22)
            $0.width.equalTo(106)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview()
        }
    }

    @objc func facebookLogout(_ sender: Any) {

        User.shared.clear()
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "businessId")
        UserDefaults.standard.removeObject(forKey: "intro")

        let loginManager = LoginManager()
        loginManager.logOut()
        SendbirdUser.shared.logout {
            print("sendbird 로그아웃 완료")
        }
        // SceneDelegate에 접근하여 rootViewController를 변경합니다.
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            // LoginViewController 인스턴스 생성. 스토리보드를 사용하는 경우 스토리보드 ID로 인스턴스화해야 합니다.
            let loginViewController = LoginVC() // 또는 스토리보드에서 생성
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
