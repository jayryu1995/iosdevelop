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
    lazy private var button = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("find".localized, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()
    
    // TextField
    lazy private var tf_id: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "Pretendard-Medium", size: 16)
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(hex: "#E5E6EA").cgColor
        tf.layer.cornerRadius = 4
        tf.leftPadding()
        tf.placeholder = "signup_manager_id".localized
        tf.delegate = self
        return tf
    }()

    lazy private var tf_name: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "Pretendard-Medium", size: 16)
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(hex: "#E5E6EA").cgColor
        tf.layer.cornerRadius = 4
        tf.leftPadding()
        tf.placeholder = "signup_manager_name".localized
        tf.delegate = self
        return tf

    }()

    // ViewModel
    lazy private var viewModel = BusinessViewModel()
    
    // loadingPage
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "login_find_account".localized
        setupBackButton()
        setupUI()
        setupConstraints()
        updateSubmitButtonState()
    }
    
    private func setupUI() {
        // 스피너 초기화 및 설정
        activityIndicator = UIActivityIndicatorView(style: .large)
        
        
        view.addSubview(tf_id)
        view.addSubview(tf_name)
        view.addSubview(button)
        view.addSubview(activityIndicator)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    
    private func setupConstraints() {
        
        tf_id.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.height.equalTo(48)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        tf_name.snp.makeConstraints {
            $0.top.equalTo(tf_id.snp.bottom).offset(8)
            $0.height.equalTo(48)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        button.snp.makeConstraints {
            $0.top.equalTo(tf_name.snp.bottom).offset(24)
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        // activityIndicator 위치 설정
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview() // 화면 중앙
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func submitButtonTapped() {
        
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.activityIndicator.startAnimating()
            self.button.isEnabled = false
        }
        
        viewModel.getFindEmail(id: tf_id.text ?? "", name: tf_name.text ?? ""){ response in
            self.activityIndicator.stopAnimating()
            self.button.isEnabled = true
            DispatchQueue.main.async { // UI 변경은 메인 스레드에서 수행
                switch response {
                case .success(let result):
                    // 인증 성공 시 페이지 이동
                    let vc = FindPassword2()
                    vc.business = result
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case .failure(let error):
                    // 인증 실패 시 실패 메시지 표시
                    self.showAlert(title: "invalid_account".localized, message: "invalid_account_message".localized)
                    self.button.isEnabled = true
                }
            }
        }
        
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
        // 업데이트 버튼 상태
        DispatchQueue.main.async {
            self.updateSubmitButtonState()
        }
        return newString.length <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tf_id {
            tf_name.becomeFirstResponder()
        }else{
            self.hideKeyboard()
        }
        return true
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        print("Text changed in: \(textField.placeholder ?? "Unknown")")
        updateSubmitButtonState()
    }
    
    
    private func updateSubmitButtonState() {
        // 모든 텍스트 필드가 채워져 있는지 확인
        let isAllFieldsFilled = !(tf_id.text?.isEmpty ?? true) &&
        !(tf_name.text?.isEmpty ?? true)
        // 버튼 활성화/비활성화
        //button.isEnabled = isAllFieldsFilled
        button.isEnabled = true
        button.backgroundColor = isAllFieldsFilled ? .black : .lightGray
    }
    
}
