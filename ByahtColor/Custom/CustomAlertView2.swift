//
//  CustomAlertView2.swift
//  ByahtColor
//
//  Created by jaem on 2024/02/15.
//

import UIKit

class CustomAlertViewController2: UIViewController {

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
        titleLabel.text = "Thay đổi sao?"
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        titleLabel.textAlignment = .center

        // messageLabel 설정
        messageLabel.text = "Kết quả lần trước bạn lưu vẫn có đó.\nBạn có muốn đổi thành kết quả hiện không?"
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        messageLabel.textAlignment = .center

        // confirmButton 설정
        confirmButton.setTitle("Thay đổi", for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)

        // cancleButton 설정
        cancleButton.setTitle("Không thay đổi", for: .normal)
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
            make.centerX.equalToSuperview()
        }

        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(alertView.snp.centerY)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(alertView.snp.height).multipliedBy(0.2)
        }

        cancleButton.snp.makeConstraints { make in
            make.top.equalTo(confirmButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(alertView.snp.height).multipliedBy(0.2)
        }
    }

    @objc private func confirmButtonTapped() {
        dismiss(animated: true, completion: nil)
        onSuccess?()
    }

    @objc private func cancleButtonTapped() {
        // 콜백 호출
        dismiss(animated: true, completion: nil)
        onCancel?()
    }
}
