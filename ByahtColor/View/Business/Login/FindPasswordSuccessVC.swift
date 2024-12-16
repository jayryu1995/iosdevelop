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
        button.setTitle("변경하기".localized, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()
    lazy private var tf_password = makeTextField(placeholder: "영소문자, 숫자 조합 8~20자 사이")
    lazy private var tf_password2 = makeTextField(placeholder: "비밀번호를 다시 입력해주세요.")
    lazy private var lbl_password = makeLabel(text: "비밀번호")
    lazy private var lbl_password2 = makeLabel(text: "비밀번호 확인")
    lazy private var component: [(UILabel, UITextField, UIButton?)] = {
        return [ (lbl_password, tf_password, nil), (lbl_password2, tf_password2, nil)]
    }()
    lazy private var insertView = UIStackView()
    lazy private var lbl_passwordMismatch: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.text = "비밀번호가 일치하지 않습니다.".localized
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
            
            // 비밀번호 확인 아래 메시지 추가
            if textField == tf_password2 {
                containerView.addSubview(lbl_passwordMismatch)
                lbl_passwordMismatch.snp.makeConstraints {
                    $0.top.equalTo(containerView.snp.bottom).offset(4) // 필드 바로 아래
                    $0.leading.trailing.equalTo(textField) // 텍스트 필드와 동일한 가로
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

        lbl_passwordMismatch.snp.makeConstraints {
            $0.top.equalTo(tf_password2.snp.bottom).offset(20)
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    @objc private func submitButtonTapped() {
        self.button.isEnabled = false
        guard lbl_passwordMismatch.isHidden else { return }
        guard business != nil else { return }
        guard tf_password.text != "" else { return }
        
        var businessDto = BusinessDto()
        businessDto.memberId = business?.memberId
        businessDto.password = tf_password.text ?? ""
        viewModel.updatePassword(businessdto: businessDto){ response in
            DispatchQueue.main.async { // UI 변경은 메인 스레드에서 수행
                switch response {
                case .success(let result):
                    // 인증 성공 시 페이지 이동
                    let vc = LoginVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case .failure(let error):
                    // 인증 실패 시 실패 메시지 표시
                    self.showAlert(title: "계정 오류", message: "오류가 발생했습니다.")
                    self.button.isEnabled = true
                }
            }
        }
    }
}

extension FindPasswordSuccessVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 제한할 텍스트 길이
        let maxLength = 20
        // 현재 텍스트와 새 입력값을 합쳐서 새 문자열 계산
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        // 새 값으로 유효성 검사 호출
        if textField == tf_password || textField == tf_password2 {
            validatePasswordMatch(currentPassword: tf_password == textField ? newString : tf_password.text ?? "",
                                  confirmPassword: tf_password2 == textField ? newString : tf_password2.text ?? "")
        }

        return newString.count <= maxLength
    }

    private func validatePasswordMatch(currentPassword: String, confirmPassword: String) {
        print("currentPassword : \(currentPassword)")
        print("confirmPassword : \(confirmPassword)")
        self.lbl_passwordMismatch.isHidden = currentPassword == confirmPassword
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

}
