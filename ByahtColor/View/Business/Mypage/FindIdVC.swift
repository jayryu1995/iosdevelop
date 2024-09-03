//
//  FindIdVC.swift
//  ByahtColor
//
//  Created by jaem on 6/19/24.
//

import Foundation
import UIKit
import SnapKit

class FindIdVC: UIViewController {
    lazy private var label: UILabel = {
        let label = UILabel()
        label.text = "findid_label".localized
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(hex: "#4E505B")
        label.textAlignment = .center
        return label
    }()

    lazy private var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("tel_certification".localized, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "login_find_account".localized
        setupBackButton()
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.addSubview(label)
        view.addSubview(button)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        button.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(20)
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    @objc private func submitButtonTapped() {

    }
}
