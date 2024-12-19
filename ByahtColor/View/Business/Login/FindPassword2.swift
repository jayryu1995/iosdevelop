//
//  FindPassword2.swift
//  ByahtColor
//
//  Created by jaem on 12/12/24.
//

import Foundation
import UIKit
import SnapKit

class FindPassword2: UIViewController {
    lazy private var button = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("change_password".localized, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()
    
    // 라벨 3개 추가
    private let label1 = {
        let label = UILabel()
        label.text = "email_code_check".localized
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let label2 = {
        let label = UILabel()
        label.text = "email_code_check_info".localized
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(hex: "#4E505B")
        label.textAlignment = .left
        return label
    }()
    
    
    lazy private var label3 = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 24)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy private var tf_verifyCode = {
        let tf = UITextField()
        tf.placeholder = "email_code_insert".localized
        tf.layer.cornerRadius = 4
        tf.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        tf.layer.borderWidth = 1
        tf.textColor = UIColor(hex: "#4E505B")
        tf.font = UIFont(name: "Pretendard-Regular", size: 14)
        tf.delegate = self
        tf.leftPadding()
        return tf
    }()
    
    lazy private var label4 = {
        let label = UILabel()
        label.text = "email_change_info".localized
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var viewModel = BusinessViewModel()
    var business : Business?
    
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
                
        setupBackButton()
        setupUI()
        updateSubmitButtonState()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        self.navigationItem.title = "login_find_account".localized
        if let business = business {
            if let email = business.email {
                // 이메일에서 '@'의 위치를 찾습니다.
                if let atIndex = email.firstIndex(of: "@") {
                    let prefixIndex = email.index(atIndex, offsetBy: -3) // '@' 기준으로 앞 3글자를 찾음
                    if prefixIndex >= email.startIndex {
                        // 앞부분만 * 처리하고 나머지와 결합
                        let maskedEmail = email.replacingCharacters(in: prefixIndex..<atIndex, with: "***")
                        label3.text = maskedEmail
                        print(maskedEmail)
                    } else {
                        // '@' 앞의 글자가 3개 미만일 경우 처리
                        label3.text = "***@\(email[email.index(after: atIndex)...])"
                        print(label3.text ?? "")
                    }
                }
            }
        }
        // 기존 버튼 추가
        view.addSubview(button)
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(tf_verifyCode)
        
        // 버튼 액션 추가
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        
        label1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(90)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        label2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(label1.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        label3.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(label2.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        tf_verifyCode.snp.makeConstraints{
            $0.top.equalTo(label3.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(tf_verifyCode.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        
        label4.snp.makeConstraints{
            $0.top.equalTo(button.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc private func submitButtonTapped() {
        button.isEnabled = false
        // 버튼 동작 구현
        viewModel.checkVerifyCode(email: business?.email ?? "", code: tf_verifyCode.text ?? "") { response in
            self.button.isEnabled = true
            DispatchQueue.main.async {
                
                switch response {
                case .success(let (statusCode, data)):
                    
                    // 성공 처리
                    if statusCode == 400{
                        self.showAlert(title: "email_authentication_failed".localized, message: "email_expired_code".localized)
                    }else if statusCode == 404{
                        self.showAlert(title: "email_authentication_failed".localized, message: "email_invalid_code".localized)
                    }else {
                        let vc = FindPasswordSuccessVC()
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                case .failure(let error as NSError):
                    if error.code == 400 {
                        print("Code expired")
                    } else if error.code == 404 {
                        print("Invalid code")
                    } else {
                        print("Error: \(error.localizedDescription), Code: \(error.code)")
                    }
                }
            }
        }


    }
    
}
extension FindPassword2: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 제한할 텍스트 길이
        let maxLength = 20
        // 새로운 텍스트 길이 계산
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        // 업데이트 버튼 상태
        DispatchQueue.main.async {
            self.updateSubmitButtonState()
        }
        return newString.length <= maxLength
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        print("Text changed in: \(textField.placeholder ?? "Unknown")")
        updateSubmitButtonState()
    }
    
    
    private func updateSubmitButtonState() {
        // 모든 텍스트 필드가 채워져 있는지 확인
        let isAllFieldsFilled = !(tf_verifyCode.text?.isEmpty ?? true)
        // 버튼 활성화/비활성화
        button.isEnabled = isAllFieldsFilled
        button.backgroundColor = isAllFieldsFilled ? .black : .lightGray
    }
    
}


