//
//  ProposalAlert2VC.swift
//  ByahtColor
//
//  Created by jaem on 8/29/24.
//

import Foundation
import SnapKit
import UIKit
class ProposalAlert2VC: UIViewController {

    private let backgroundView = UIView()
    private let alertView = UIView()
    private let messageLabel = {
        let label = UILabel()
        label.text = "proposal_alert2_label".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let messageLabel2 = {
        let label = UILabel()
        label.text = "proposal_alert2_label2".localized
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(hex: "#4E505B")
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private let confirmButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.setTitle("proposal_alert2_button".localized, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
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

        // confirmButton 설정
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        

        // alertView에 컴포넌트 추가
        alertView.addSubview(messageLabel)
        alertView.addSubview(messageLabel2)
        alertView.addSubview(confirmButton)

        // 전체 뷰에 alertView 추가
        backgroundView.addSubview(alertView)
    }

    // 오토레이아웃 제약조건을 설정합니다.
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        alertView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.center.equalToSuperview()
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        messageLabel2.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel2.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().inset(24)
        }

    }

    @objc private func confirmButtonTapped() {
        onConfirm?()
        dismiss(animated: true, completion: nil)
    }

}
