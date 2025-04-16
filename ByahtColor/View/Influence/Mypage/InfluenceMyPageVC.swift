//
//  InfulenceMyPageVC.swift
//  ByahtColor
//
//  Created by jaem on 6/26/24.
//

import UIKit
import Combine
import SnapKit

class InfluenceMyPageVC: UIViewController {

    private let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "My Account"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    private let accountButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(UIColor(hex: "#F4F5F8"), for: .normal)
        button.layer.cornerRadius = 4
        return button
    }()

    private let errorButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(UIColor(hex: "#F4F5F8"), for: .normal)
        button.layer.cornerRadius = 4
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
    }

    
    private func setupUI() {
        
        view.addSubview(accountLabel)
        view.addSubview(accountLabel)
        view.addSubview(accountButton)
        view.addSubview(errorButton)
        setupAccountButton()
        setupErrorButton()
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
    
    private func setupAccountButton() {
        let label = UILabel()
        label.text = "privacy_policy".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = .black

        let icon = UIImageView(image: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = UIColor(hex: "#4E505B")
        icon.contentMode = .scaleAspectFit

        accountButton.addTarget(self, action: #selector(accountButtonTapped), for: .touchUpInside)

        accountButton.addSubview(label)
        accountButton.addSubview(icon)
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

    private func setupConstraints() {
        accountLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        errorButton.snp.makeConstraints {
            $0.top.equalTo(accountLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
        
        accountButton.snp.makeConstraints{
            $0.top.equalTo(errorButton.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
    }

    
    @objc private func accountButtonTapped() {
        let vc = PrivatePolicyVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }

    
    @objc private func errorButtonTapped() {
        let urlString = "https://forms.gle/iE8czGec28MGPwvo7"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
