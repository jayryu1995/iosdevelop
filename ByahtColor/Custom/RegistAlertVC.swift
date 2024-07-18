//
//  registAlertVC.swift
//  ByahtColor
//
//  Created by jaem on 7/6/24.
//

import Foundation
import SnapKit
import UIKit
class RegistAlertVC: UIViewController {

    let backgroundView = UIView()
    let alertView = UIView()
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.setTitle("alert_regist_button".localized, for: .normal)
        return button
    }()

    // 콜백 정의
    var onConfirm: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    private func setupView() {
        // 배경 뷰 설정
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.addSubview(backgroundView)

        // alertView 설정
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 8

        // titleLabel 설정
        titleLabel.text = "alert_regist_str".localized
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0

        // messageLabel 설정
        messageLabel.text = "alert_regist_str2".localized
        messageLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        messageLabel.textAlignment = .left
        messageLabel.numberOfLines = 0

        // confirmButton 설정
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)

        // alertView에 컴포넌트 추가
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        alertView.addSubview(confirmButton)

        // 전체 뷰에 alertView 추가
        backgroundView.addSubview(alertView)
    }

    // 오토레이아웃 제약조건을 설정합니다.
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let width = UIScreen.main.bounds.size.width - 30

        alertView.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.center.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().multipliedBy(0.6)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().inset(24)
        }

        alertView.snp.makeConstraints { make in
            make.bottom.equalTo(confirmButton.snp.bottom).offset(20)
        }
    }

    @objc private func confirmButtonTapped() {
        onConfirm?()
        dismiss(animated: true, completion: nil)
    }
}
