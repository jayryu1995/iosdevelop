//
//  ApplicationAlertVC.swift
//  ByahtColor
//
//  Created by jaem on 3/19/24.
//

import UIKit
import SnapKit

class ApplicationAlertVC: UIViewController {

    let backgroundView = UIView()
    let alertView = UIView()
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let confirmButton = NextButton()
    let cancleButton = NextButton()

    // 콜백 정의
    var onCancel: (() -> Void)?
    var onSuccess: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupAlertView()
        setupConstraints()
    }

    private func setupBackgroundView() {
        backgroundView.backgroundColor = .black
        view.addSubview(backgroundView)
    }

    private func setupAlertView() {
        // alertView 설정
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 12

        // titleLabel 설정
        titleLabel.text = "application_alert_titleLabel".localized
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        titleLabel.textAlignment = .center

        // messageLabel 설정
        messageLabel.text = "application_alert_messageLabel".localized
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        messageLabel.textAlignment = .center

        // confirmButton 설정
        confirmButton.setTitle("application_alert_agree".localized, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)

        // cancleButton 설정
        cancleButton.setTitle("application_alert_cancel".localized, for: .normal)
        cancleButton.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        cancleButton.backgroundColor = UIColor(hex: "#F4F5F8")
        cancleButton.addTarget(self, action: #selector(cancleButtonTapped), for: .touchUpInside)

        // alertView에 컴포넌트 추가
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        alertView.addSubview(confirmButton)
        alertView.addSubview(cancleButton)

        // 전체 뷰에 alertView 추가
        backgroundView.addSubview(alertView)

    }

    // 오토레이아웃 제약조건을 설정합니다.
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let width = view.frame.size.width-30

        alertView.snp.makeConstraints { make in
            make.width.height.equalTo(width)
            make.center.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.centerX.equalToSuperview()
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }

        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(alertView.snp.height).multipliedBy(0.2)
        }

        cancleButton.snp.makeConstraints { make in
            make.top.equalTo(confirmButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(alertView.snp.height).multipliedBy(0.2)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    @objc private func confirmButtonTapped() {
        dismiss(animated: true, completion: nil)
        onSuccess?()
    }

    @objc private func cancleButtonTapped() {
        // 콜백 호출
        dismiss(animated: true, completion: nil)
    }
}
