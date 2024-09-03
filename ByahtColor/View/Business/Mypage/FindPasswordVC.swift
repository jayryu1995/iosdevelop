//
//  FindPasswordVC.swift
//  ByahtColor
//
//  Created by jaem on 6/19/24.
//

import Foundation
import UIKit
import SnapKit

class FindPasswordVC: UIViewController {
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

    lazy private var tf_id: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "Pretendard-Medium", size: 16)
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(hex: "#E5E6EA").cgColor
        tf.layer.cornerRadius = 4
        tf.leftPadding()
        tf.placeholder = "tel_certification".localized
        tf.delegate = self
        return tf
    }()

    lazy private var tf_num: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "Pretendard-Medium", size: 16)
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(hex: "#E5E6EA").cgColor
        tf.layer.cornerRadius = 4
        tf.leftPadding()
        tf.placeholder = "signup_business_num_hint".localized
        tf.delegate = self
        return tf

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
        view.addSubview(tf_id)
        view.addSubview(tf_num)
        view.addSubview(button)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        tf_id.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.height.equalTo(48)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        tf_num.snp.makeConstraints {
            $0.top.equalTo(tf_id.snp.bottom).offset(8)
            $0.height.equalTo(48)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        button.snp.makeConstraints {
            $0.top.equalTo(tf_num.snp.bottom).offset(20)
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    @objc private func submitButtonTapped() {

    }
}

extension FindPasswordVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 제한할 텍스트 길이
        let maxLength = 20
        // 새로운 텍스트 길이 계산
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           if textField == tf_id {
               tf_num.becomeFirstResponder()
           } else if textField == tf_num {
               textField.resignFirstResponder()
               submitButtonTapped()
           }
           return true
       }
}
