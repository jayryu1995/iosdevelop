//
//  BusinessPasswordChangeVC.swift
//  ByahtColor
//
//  Created by jaem on 12/17/24.
//

import Foundation
import UIKit
import SnapKit

class BusinessPasswordChangeVC: UIViewController {
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
    // UILabel 및 UITextField 정의
    lazy private var lbl_currentPassword = {
        let label = UILabel()
        label.text = "current_password".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = .black
        return label
    }()
    
    lazy private var tf_currentPassword = {
        let textField = UITextField()
        textField.placeholder = "current_password_insert".localized
        textField.font = UIFont(name: "Pretendard-Regular", size: 14)
        textField.isSecureTextEntry = true
        textField.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.leftPadding()
        return textField
    }()
    
    lazy private var lbl_password = {
        let label = UILabel()
        label.text = "new_password".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = .black
        return label
    }()
    
    lazy private var tf_password = {
        let textField = UITextField()
        textField.placeholder = "signup_manager_pwd_hint".localized
        textField.font = UIFont(name: "Pretendard-Regular", size: 14)
        textField.isSecureTextEntry = true
        textField.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.leftPadding()
        return textField
    }()
    
    lazy private var lbl_password2 = {
        let label = UILabel()
        label.text = "new_password_check".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = .black
        return label
    }()
    
    lazy private var tf_password2 = {
        let textField = UITextField()
        textField.placeholder = "rewrite_password".localized
        textField.font = UIFont(name: "Pretendard-Regular", size: 14)
        textField.isSecureTextEntry = true
        textField.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.leftPadding()
        return textField
    }()
    
    lazy private var lbl_currentPasswordMismatch = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.text = "signup_check_password_message2".localized
        label.isHidden = true // 처음에는 숨김
        label.textAlignment = .right
        return label
    }()
    
    lazy private var lbl_passwordMismatch = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.text = "signup_check_password_message3".localized
        label.isHidden = true // 처음에는 숨김
        label.textAlignment = .right
        return label
    }()
    lazy private var lbl_passwordMismatch2 = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.text = "signup_check_password_message2".localized
        label.textAlignment = .right
        label.isHidden = true // 처음에는 숨김
        return label
    }()
    
    lazy private var viewModel = BusinessViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "change_password".localized
        setupBackButton()
        setupUI()
        setupConstraints()
        setupTextFields()
        updateButtonState()
    }
    
    
    private func setupUI() {
        view.addSubview(lbl_currentPassword)
        view.addSubview(lbl_password)
        view.addSubview(lbl_password2)
        view.addSubview(tf_currentPassword)
        view.addSubview(tf_password)
        view.addSubview(tf_password2)
        view.addSubview(lbl_passwordMismatch)
        view.addSubview(lbl_passwordMismatch2)
        view.addSubview(lbl_currentPasswordMismatch)
        
        button.addTarget(self, action: #selector(submitButton), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func submitButton(){
        guard let memberId = User.shared.id, let currentPassword = tf_currentPassword.text,
              let newPassword = tf_password.text else { return }
        
        let dto = BusinessPasswordDto(memberId: memberId, currentPassword: currentPassword, newPassword: newPassword)
        
        viewModel.updateMypagePassword(dto: dto){ response in
            DispatchQueue.main.async {
                switch response {
                case .success:
                    // 성공 Alert 표시
                    let alert = UIAlertController(title: "change_success".localized, message: "change_success_message".localized, preferredStyle: .alert)
                    self.present(alert, animated: true)
                    
                    // 2초 후에 Alert를 닫고 Pop
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        alert.dismiss(animated: true) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                case .failure:
                    self.showAlert(title: "Error", message: "change_fail_message".localized)
                    self.validateCurrentPassword(flag:false)
                }
            }
        }
    }
    
    private func setupConstraints(){
        
        // 기존 비밀번호
        lbl_currentPassword.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(42)
            $0.leading.equalToSuperview().offset(20)
        }
        
        tf_currentPassword.snp.makeConstraints{
            $0.top.equalTo(lbl_currentPassword.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        lbl_currentPasswordMismatch.snp.makeConstraints{
            $0.top.equalTo(lbl_currentPassword.snp.top)
            $0.leading.equalTo(lbl_currentPassword.snp.trailing).offset(10)
            $0.trailing.equalTo(tf_currentPassword.snp.trailing)
        }
        
        
        // 새비밀번호
        
        lbl_password.snp.makeConstraints{
            $0.top.equalTo(tf_currentPassword.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        tf_password.snp.makeConstraints{
            $0.top.equalTo(lbl_password.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        lbl_passwordMismatch.snp.makeConstraints{
            $0.top.equalTo(lbl_password.snp.top)
            $0.leading.equalTo(lbl_password.snp.trailing).offset(10)
            $0.trailing.equalTo(tf_password.snp.trailing)
        }
        
        // 비밀번호 확인
        
        lbl_password2.snp.makeConstraints{
            $0.top.equalTo(tf_password.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        tf_password2.snp.makeConstraints{
            $0.top.equalTo(lbl_password2.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        lbl_passwordMismatch2.snp.makeConstraints{
            $0.top.equalTo(lbl_password2.snp.top)
            $0.leading.equalTo(lbl_password2.snp.trailing).offset(10)
            $0.trailing.equalTo(tf_password2.snp.trailing)
        }
        
        button.snp.makeConstraints{
            $0.top.equalTo(tf_password2.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
    }
    
    private func setupTextFields() {
        [tf_currentPassword, tf_password, tf_password2].forEach { textField in
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        validateFields() // 전체 필드 검증
        if textField == tf_currentPassword {
            
            validateCurrentPassword(flag :true) // 현재 비밀번호 필드 검증
        }
        if textField == tf_password {
            validateNewPassword() // 새 비밀번호 검증
        } else if textField == tf_password2 {
            validatePasswordMatch() // 새 비밀번호 확인 검증
        }
    }
    
    private func validatePasswordMatch() {
            guard let newPassword = tf_password.text, let confirmPassword = tf_password2.text else { return }

            if newPassword == confirmPassword {
                tf_password2.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
                lbl_passwordMismatch2.isHidden = true
            } else {
                tf_password2.layer.borderColor = UIColor.red.cgColor
                tf_password2.layer.borderWidth = 1
                lbl_passwordMismatch2.isHidden = false
            }
        }
    
    private func validateNewPassword() {
        guard let newPassword = tf_password.text else { return }
        
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>]).{8,20}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let isValid = passwordPredicate.evaluate(with: newPassword)
        
        if isValid {
            tf_password.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
            lbl_passwordMismatch.isHidden = true
        } else {
            tf_password.layer.borderColor = UIColor.red.cgColor
            tf_password.layer.borderWidth = 1
            lbl_passwordMismatch.isHidden = false
        }
    }
    
    private func validateFields() {
        guard let currentPassword = tf_currentPassword.text,
              let newPassword = tf_password.text,
              let confirmPassword = tf_password2.text else {
            return
        }
        
        let allFieldsFilled = !currentPassword.isEmpty && !newPassword.isEmpty && !confirmPassword.isEmpty
        let currentAndNewPasswordDifferent = currentPassword != newPassword
        let newPasswordMatches = newPassword == confirmPassword
        
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>]).{8,20}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let newPasswordValid = passwordPredicate.evaluate(with: newPassword)
        
        let isEnabled = allFieldsFilled && currentAndNewPasswordDifferent && newPasswordMatches && newPasswordValid
        
        button.isEnabled = isEnabled
        button.backgroundColor = isEnabled ? UIColor.black : UIColor(hex: "#D3D4DA") // 버튼 색상 변경
    }
    
    private func validateCurrentPassword(flag: Bool) {
        if flag {
            // 정상 상태
            lbl_currentPasswordMismatch.isHidden = true
            tf_currentPassword.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
            tf_currentPassword.layer.borderWidth = 1
        } else {
            // 에러 상태
            lbl_currentPasswordMismatch.isHidden = false
            tf_currentPassword.layer.borderColor = UIColor.red.cgColor
            tf_currentPassword.layer.borderWidth = 1
        }
    }
    
    private func updateButtonState() {
        button.isEnabled = false
        button.backgroundColor = UIColor(hex: "#D3D4DA") // 초기 비활성화 색상 설정
    }
}


extension BusinessPasswordChangeVC : UITextFieldDelegate {
    // UITextFieldDelegate 메서드 - 최대 입력 길이 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        
        // 새 텍스트의 길이 계산
        let newLength = currentText.count + string.count - range.length
        
        // 최대 길이 20자 제한
        return newLength <= 20
    }
}
