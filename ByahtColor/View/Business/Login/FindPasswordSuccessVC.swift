//
//  FindPasswordSuccessVC.swift
//  ByahtColor
//
//  Created by jaem on 12/5/24.
//

import Foundation
import UIKit
import SnapKit

class FindPasswordSuccessVC: UIViewController {
    lazy private var button = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("change".localized, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()
    lazy private var tf_password = makeTextField(placeholder: "signup_manager_pwd_hint")
    lazy private var tf_password2 = makeTextField(placeholder: "rewrite_password")
    lazy private var lbl_password = makeLabel(text: "signup_manager_pwd")
    lazy private var lbl_password2 = makeLabel(text: "signup_manager_pwd_check")
    lazy private var component: [(UILabel, UITextField, UIButton?)] = {
        return [ (lbl_password, tf_password, nil), (lbl_password2, tf_password2, nil)]
    }()
    lazy private var insertView = UIStackView()
    lazy private var lbl_passwordMismatch: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.text = "signup_check_password_message3".localized
        label.isHidden = true // 처음에는 숨김
        return label
    }()
    lazy private var lbl_passwordMismatch2: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.text = "signup_check_password_message2".localized
        label.isHidden = true // 처음에는 숨김
        return label
    }()
    lazy private var changePassword: UILabel = {
        let lbl = UILabel()
        lbl.text = "비밀번호 재설정".localized
        lbl.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return lbl
    }()
    lazy private var viewModel = BusinessViewModel()
    var business: Business?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "login_find_account".localized
        setupBackButton()
        setupUI()
        setupContentView()
        setupConstraints()

        
        updateButtonState(with: tf_password.text ?? "", confirmPassword: tf_password2.text ?? "")
    }


    private func setupUI() {
        view.addSubview(changePassword)
        view.addSubview(insertView)
        view.addSubview(button)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    private func setupContentView() {
        insertView.axis = .vertical
        insertView.spacing = 8
        for (label, textField, button) in component {
            let containerView = makeContainerView(withLabel: label, textField: textField, button: button)
            textField.delegate = self
            
            insertView.addArrangedSubview(containerView)
            containerView.snp.makeConstraints {
                $0.height.equalTo(48)
                $0.leading.trailing.equalToSuperview()
            }

            // 경고 메시지를 containerView 외부에 추가
            if textField == tf_password {
                textField.isSecureTextEntry = true
                insertView.addArrangedSubview(lbl_passwordMismatch)
                lbl_passwordMismatch.snp.makeConstraints {
                    $0.leading.trailing.equalTo(containerView)
                }
            }

            if textField == tf_password2 {
                textField.isSecureTextEntry = true
                insertView.addArrangedSubview(lbl_passwordMismatch2)
                lbl_passwordMismatch2.snp.makeConstraints {
                    $0.leading.trailing.equalTo(containerView)
                }
            }
        }
    }



    
    private func setupConstraints() {
        
        changePassword.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(20)
        }
        
        insertView.snp.makeConstraints {
            $0.top.equalTo(changePassword.snp.bottom).offset(24)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }

        button.snp.makeConstraints {
            $0.top.equalTo(insertView.snp.bottom).offset(24)
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    @objc private func submitButtonTapped() {
        guard isValidPassword(tf_password.text ?? "") else {
            lbl_passwordMismatch.text = "signup_manager_pwd_hint".localized
            lbl_passwordMismatch.isHidden = false
            return
        }

        guard tf_password.text == tf_password2.text else {
            lbl_passwordMismatch2.isHidden = false
            return
        }

        self.button.isEnabled = false
        guard business != nil else { return }
        guard let password = tf_password.text, !password.isEmpty else { return }

        var businessDto = BusinessDto()
        businessDto.memberId = business?.memberId
        businessDto.password = password
        viewModel.updatePassword(businessdto: businessDto) { response in
            DispatchQueue.main.async {
                switch response {
                case .success:
                    let vc = LoginVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                case .failure:
                    self.showAlert(title: "Error", message: "An error has occurred.")
                    self.button.isEnabled = true
                }
            }
        }
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&*()\\-_+=<>?])[a-zA-Z\\d!@#$%^&*()\\-_+=<>?]{8,20}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }


}

extension FindPasswordSuccessVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        if textField == tf_password {
            validatePasswordFormat(newString)
        } else if textField == tf_password2 {
            validatePasswordMatch(currentPassword: tf_password.text ?? "", confirmPassword: newString)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if textField == self.tf_password {
                self.updateButtonState(with: newString, confirmPassword: self.tf_password2.text ?? "")
            } else if textField == self.tf_password2 {
                self.updateButtonState(with: self.tf_password.text ?? "", confirmPassword: newString)
            }
        }


        return newString.count <= maxLength
    }


    private func validatePasswordMatch(currentPassword: String, confirmPassword: String) {
        print("currentPassword : \(currentPassword)")
        print("confirmPassword : \(confirmPassword)")
        self.lbl_passwordMismatch2.isHidden = currentPassword == confirmPassword
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tf_password {
            tf_password2.becomeFirstResponder()
        } else if textField == tf_password2 {
            textField.resignFirstResponder()
            submitButtonTapped()
        }
        return true
    }

    private func validatePasswordFormat(_ password: String) {
        if isValidPassword(password) {
            lbl_passwordMismatch.isHidden = true
        } else {
            lbl_passwordMismatch.isHidden = false
        }
        
    }
    
    private func updateButtonState(with password: String, confirmPassword: String) {
        let isPasswordValid = isValidPassword(password)
        let isPasswordMatching = password == confirmPassword
        print("Password: \(password), Confirm Password: \(confirmPassword)")
        button.isEnabled = isPasswordValid && isPasswordMatching
        button.backgroundColor = button.isEnabled ? .black : .gray
    }

}
