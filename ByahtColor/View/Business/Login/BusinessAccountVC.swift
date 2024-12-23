//
//  BusinessAccountVC.swift
//  ByahtColor
//
//  Created by jaem on 10/11/24.
//

import SnapKit
import UIKit

class BusinessAccountVC : UIViewController {
    
    private lazy var label = {
        let label = UILabel()
        label.text = "business_profile_label".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.numberOfLines = 0
        label.textColor = UIColor(hex: "#4E505B")
        return label
    }()
    
    private lazy var logoutLabel = {
        let label = UILabel()
        label.text = "business_profile_logout".localized
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = UIColor(hex: "#4E505B")
        return label
    }()
    
    private lazy var secessionLabel = {
        let label = UILabel()
        label.text = "business_profile_secession".localized
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = UIColor(hex: "#4E505B")
        return label
    }()
    
    private lazy var logoutIcon = {
        let icon = UIImageView(image: UIImage(named: "logout_icon"))
        icon.contentMode = .scaleAspectFit
        icon.layer.cornerRadius = 6
        icon.backgroundColor = UIColor(hex: "#F4F5F8")
        return icon
    }()
    
    private lazy var secessionIcon = {
        let icon = UIImageView(image: UIImage(named: "secession_icon"))
        icon.contentMode = .scaleAspectFit
        icon.layer.cornerRadius = 6
        icon.backgroundColor = UIColor(hex: "#F4F5F8")
        return icon
    }()
    
    private lazy var logoutView = UIView()
    private lazy var secessionView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI(){
        view.addSubview(label)
        view.addSubview(logoutView)
        view.addSubview(secessionView)
        logoutView.addSubview(logoutIcon)
        logoutView.addSubview(logoutLabel)
        secessionView.addSubview(secessionIcon)
        secessionView.addSubview(secessionLabel)
        
        logoutView.isUserInteractionEnabled = true
        secessionView.isUserInteractionEnabled = true
        
        let logoutGesture = UITapGestureRecognizer(target: self, action: #selector(facebookLogout))
        logoutView.addGestureRecognizer(logoutGesture)
        
        let secessionGesture = UITapGestureRecognizer(target: self, action: #selector(deleteTapped))
        secessionView.addGestureRecognizer(secessionGesture)
    }

    
    private func setupConstraints(){
        
        label.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).multipliedBy(0.35)
            $0.leading.trailing.equalToSuperview().inset(90)
            $0.height.equalTo(40)
        }
        
        logoutView.snp.makeConstraints{
            $0.top.equalTo(label.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.equalTo(89)
        }
        
        secessionView.snp.makeConstraints{
            $0.top.equalTo(logoutView.snp.bottom).offset(48)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.equalTo(89)
        }
        
        logoutIcon.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.leading.top.bottom.equalToSuperview()
        }
        
        logoutLabel.snp.makeConstraints{
            $0.height.equalTo(24)
            $0.leading.equalTo(logoutIcon.snp.trailing).offset(16)
            $0.trailing.top.bottom.equalToSuperview()
        }
        secessionIcon.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.leading.top.bottom.equalToSuperview()
        }
        
        secessionLabel.snp.makeConstraints{
            $0.height.equalTo(24)
            $0.leading.equalTo(secessionIcon.snp.trailing).offset(16)
            $0.trailing.top.bottom.equalToSuperview()
        }
        
        
    }
    
    
    @objc private func facebookLogout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "businessId")
        
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
