//
//  BusinessFourthOnboardingVC.swift
//  ByahtColor
//
//  Created by jaem on 9/9/24.
//

import Foundation
import UIKit
import SnapKit

class BusinessFourthOnboardingVC: UIViewController, UITextViewDelegate {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "business_onboarding_fourth_label".localized
        label.textColor = UIColor(hex: "#009BF2")
        label.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let label2: UILabel = {
        let label = UILabel()
        label.text = "business_onboarding_fourth_label2".localized
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Medium", size: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let textView: UITextView = {
        let tv = UITextView()
        tv.textColor = .lightGray
        tv.text = "business_onboarding_fourth_hint".localized
        tv.font = UIFont(name: "Pretendard-Regular", size: 16)
        tv.layer.cornerRadius = 16
        tv.layer.borderColor = UIColor(hex: "#B5B8C2").cgColor
        tv.layer.borderWidth = 1
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return tv
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

    private lazy var viewModel = BusinessViewModel()

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
            make.height.equalTo(60)
        }

        button.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-48)
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    @objc private func tappedButton() {
        if let intro: String = textView.text, textView.textColor != .lightGray {
            viewModel.updateIntro(intro: intro) { result in
                switch result {
                case .success(let response):
                    print("Success: \(response)")
                    self.dismiss(animated: true)
                    User.shared.intro = intro
                    UserDefaults.standard.setValue(intro, forKey: "intro")
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

    // UITextViewDelegate - Placeholder 관리 및 버튼 활성화 처리
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "business_onboarding_fourth_hint".localized
            textView.textColor = .lightGray
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        let isTextViewEmpty = textView.text.isEmpty || textView.textColor == .lightGray
        button.isEnabled = !isTextViewEmpty
    }

    // 최대 100자 입력 제한 처리
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 100
    }
}
