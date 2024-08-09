//
//  FourthOnboardingVC.swift
//  ByahtColor
//
//  Created by jaem on 7/31/24.
//

import Foundation
import UIKit
import SnapKit

class FourthOnboardingVC: UIViewController, UITextFieldDelegate {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "onboarding_fourth_label".localized
        label.textColor = UIColor(hex: "#009BF2")
        label.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let label2: UILabel = {
        let label = UILabel()
        label.text = "onboarding_fourth_label2".localized
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Medium", size: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let textView: UITextField = {
        let tf = UITextField()
        tf.textColor = .black
        tf.placeholder = "onboarding_fourth_hint".localized
        tf.font = UIFont(name: "Pretendard-Regular", size: 16)
        tf.layer.cornerRadius = 16
        tf.layer.borderColor = UIColor(hex: "#B5B8C2").cgColor
        tf.layer.borderWidth = 1
        tf.leftPadding()
        tf.returnKeyType = .done
        return tf
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("onboarding_fourth_button".localized, for: .normal)
        button.setBackgroundColor(.black, for: .normal)
        button.setBackgroundColor(UIColor(hex: "#D3D4DA"), for: .disabled)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.isEnabled = false
        return button
    }()

    private lazy var viewModel = InfluenceViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupUI()
        setupConstraints()
        setupGestureRecognizer()
    }

    private func setupUI() {
        view.addSubview(label)
        view.addSubview(label2)
        view.addSubview(textView)
        view.addSubview(button)
        textView.delegate = self
        textView.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
    }

    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview()
        }

        label2.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(label2.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(64)
        }

        button.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-48)
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

    }

    @objc private func tappedButton() {
        if let name: String = textView.text {
            viewModel.updateAccountName(newName: name) { result in
                switch result {
                case .success(let response):
                    print("Success: \(response)")
                    self.dismiss(animated: true)
                    User.shared.name = name
                    NotificationCenter.default.post(name: .dataChanged, object: nil)

                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    private func setupGestureRecognizer() {
        self.hideKeyboard()
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        let isTextFieldEmpty = textField.text?.isEmpty ?? true
        button.isEnabled = !isTextFieldEmpty
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
