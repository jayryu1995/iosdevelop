//
//  BusinessMypageVC.swift
//  ByahtColor
//
//  Created by jaem on 6/28/24.
//

import UIKit
import Alamofire
import Combine
import SnapKit
import Foundation

class BusinessMypageVC: UIViewController {
    
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "My Account"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    
    private let businessInfoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#F4F5F8")
        button.layer.cornerRadius = 8
        return button
    }()

    private let passwordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#F4F5F8")
        button.layer.cornerRadius = 8
        return button
    }()

    private let errorButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#F4F5F8")
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let introLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = UIColor(hex: "#F4F5F8")
        label.numberOfLines = 2
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupContstraints()
    }


    private func setupUI() {
        
        view.addSubview(accountLabel)
        view.addSubview(businessInfoButton)
        view.addSubview(passwordButton)
        view.addSubview(errorButton)
        
        setupPasswordButton()
        setupBusinessInfoButton()
        setupErrorButton()
    }


    private func setupBusinessInfoButton() {
        let label = UILabel()
        label.text = "modify_businessinfo".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = .black

        let icon = UIImageView(image: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = UIColor(hex: "#4E505B")
        icon.contentMode = .scaleAspectFit

        businessInfoButton.addSubview(label)
        businessInfoButton.addSubview(icon)
        businessInfoButton.addTarget(self, action: #selector(businessInfoButtonTapped), for: .touchUpInside)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }

        icon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
    }
    
    private func setupPasswordButton() {
        let label = UILabel()
        label.text = "change_password".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = .black

        let icon = UIImageView(image: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = UIColor(hex: "#4E505B")
        icon.contentMode = .scaleAspectFit

        passwordButton.addSubview(label)
        passwordButton.addSubview(icon)
        passwordButton.addTarget(self, action: #selector(passwordButtonTapped), for: .touchUpInside)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }

        icon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
    }

    private func setupErrorButton() {
        let label = UILabel()
        label.text = "business_mypage_error_label".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = .black

        let icon = UIImageView(image: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = UIColor(hex: "#4E505B")
        icon.contentMode = .scaleAspectFit

        errorButton.addSubview(label)
        errorButton.addSubview(icon)
        errorButton.addTarget(self, action: #selector(errorButtonTapped), for: .touchUpInside)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }

        icon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
    }
    
    private func setupContstraints() {
        
        accountLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        businessInfoButton.snp.makeConstraints {
            $0.top.equalTo(accountLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
        
        passwordButton.snp.makeConstraints {
            $0.top.equalTo(businessInfoButton.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
        
        errorButton.snp.makeConstraints{
            $0.top.equalTo(passwordButton.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
    }

    @objc private func businessInfoButtonTapped() {
        let vc = BusinessInfoVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc private func passwordButtonTapped() {
        let vc = BusinessPasswordChangeVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc private func errorButtonTapped() {
        if getLanguage() == "ko"{
            let urlString = "https://docs.google.com/forms/d/e/1FAIpQLSeC5FpP1ih5SdTyx5ePlmfseKBRHSk34tH0sHSFXNLOfuM0jg/viewform?usp=dialog"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }else{
            let urlString = "https://docs.google.com/forms/d/e/1FAIpQLSere-Vx71lq7lUFrMcJXYW2vv9JXf8sANJvZHUT2QJhsGocFA/viewform?usp=dialog"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        
    }
}
