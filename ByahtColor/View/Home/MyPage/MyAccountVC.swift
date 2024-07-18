//
//  MypageVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/02/28.
//

import Alamofire
import UIKit
import SnapKit
import FBSDKLoginKit
import FBSDKCoreKit

class MyAccountVC: UIViewController {

    private let textView1: UILabel = {
        let text = UILabel()
        text.text = "Chúng mình sẽ tiếp tục cập nhật nhiều tính năng mới nha.\nHãy đợi chúng mình!"
        text.numberOfLines = 3
        text.textAlignment = .center
        return text
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        setText()
        setButton()
    }

    private func setText() {
        view.addSubview(textView1)

        textView1.font = UIFont(name: "Pretendard-Medium", size: 16)
        textView1.textColor = UIColor(hex: "#535358")

        textView1.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func setButton() {
        let logoutButton = UIButton()
        logoutButton.setTitle("Đăng xuất", for: .normal)
        logoutButton.addTarget(self, action: #selector(facebookLogout), for: .touchUpInside)
        logoutButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        logoutButton.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        logoutButton.backgroundColor = UIColor(hex: "#F7F7F7")
        logoutButton.layer.cornerRadius = 4
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(textView1.snp.bottom).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.centerX).offset(-20)
            $0.width.equalTo(106)
            $0.height.equalTo(44)
        }

        let deleteButton = UIButton()
        deleteButton.setTitle("Xoá tài khoản", for: .normal)
        deleteButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        deleteButton.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        deleteButton.backgroundColor = UIColor(hex: "#F7F7F7")
        deleteButton.layer.cornerRadius = 4
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(logoutButton)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.centerX).offset(20)
            $0.width.equalTo(106)
            $0.height.equalTo(44)
        }
    }

    @objc func facebookLogout(_ sender: Any) {
        let id = User.shared.id ?? ""
        if id.contains(".") {
            UserDefaults.standard.set("", forKey: "name")
            UserDefaults.standard.set("", forKey: "userID")
            UserDefaults.standard.set("", forKey: "email")
        } else {
            let loginManager = LoginManager()
            loginManager.logOut()

        }
        // SceneDelegate에 접근하여 rootViewController를 변경합니다.
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            // LoginViewController 인스턴스 생성. 스토리보드를 사용하는 경우 스토리보드 ID로 인스턴스화해야 합니다.
            let loginViewController = LoginViewController() // 또는 스토리보드에서 생성
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
