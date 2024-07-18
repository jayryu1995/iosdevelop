//
//  DeleteAlertView.swift
//  ByahtColor
//
//  Created by jaem on 2024/02/15.
//

import Foundation
import SnapKit
import Alamofire
import FBSDKLoginKit
import FBSDKCoreKit
class DeleteAlertVC: UIViewController {

    let backgroundView = UIView()
    let alertView = UIView()
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let confirmButton = NextButton()
    let cancleButton = NextButton()

    // 콜백 정의
    var onSuccess: (() -> Void)?
    var onCancel: (() -> Void)?
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
        titleLabel.text = "Bạn có muốn xoá không?"
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        titleLabel.textAlignment = .center

        // messageLabel 설정
        messageLabel.text = ""
        messageLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        messageLabel.textAlignment = .center

        // confirmButton 설정
        confirmButton.setTitle("Xoá", for: .normal)
        confirmButton.setTitleColor(UIColor(hex: "#EF369B"), for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        confirmButton.backgroundColor = .white
        // cancleButton 설정
        cancleButton.setTitle("Không", for: .normal)
        cancleButton.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        cancleButton.backgroundColor = .white
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

        let layer1 = UIView()
        layer1.backgroundColor = UIColor(hex: "#F7F7F7")
        backgroundView.addSubview(layer1)
        let layer2 = UIView()
        layer2.backgroundColor = UIColor(hex: "#F7F7F7")
        backgroundView.addSubview(layer2)

        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let width = view.frame.size.width-30

        alertView.snp.makeConstraints { make in
            make.width.height.equalTo(width)
            make.center.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().dividedBy(4)
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

        layer1.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(confirmButton.snp.top)
        }

        layer2.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.top.equalTo(cancleButton.snp.top)
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
