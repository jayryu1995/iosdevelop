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
        button.setTitle("찾기".localized, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()
    
    // Label
    lazy private var lbl_id = makeLabel(text: "아이디")
    lazy private var lbl_name = makeLabel(text: "담당자명")
    
    // TextField
    lazy private var tf_id = makeTextField(placeholder: "")
    lazy private var tf_name = makeTextField(placeholder: "")
    
    lazy private var businessView = UIStackView()
    lazy private var business: [(UILabel, UITextField, UIButton?)] = {
        return [ (lbl_id, tf_id, nil), (lbl_name, tf_name, nil) ]
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
        setupContentView()
        setupConstraints()
        updateSubmitButtonState()
    }
    
    private func setupUI() {
        [tf_id,tf_name].forEach {
            $0.delegate = self
        }
        // 스피너 초기화 및 설정
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        
        view.addSubview(businessView)
        view.addSubview(button)
        view.addSubview(activityIndicator)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    
    private func setupContentView() {
        businessView.axis = .vertical
        businessView.spacing = 8
        // 기업
        for (label, textField, button) in business {
            let containerView = makeContainerView(withLabel: label, textField: textField, button: button)
            textField.delegate = self
            businessView.addArrangedSubview(containerView)
            containerView.snp.makeConstraints {
                $0.height.equalTo(48)
                $0.leading.trailing.equalToSuperview()
            }
        }
    }
    
    private func setupConstraints() {
        
        businessView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        button.snp.makeConstraints {
            $0.top.equalTo(businessView.snp.bottom).offset(24)
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc private func submitButtonTapped() {
        self.activityIndicator.startAnimating()
        button.isEnabled = false
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
                    self.showAlert(title: "계정 조회 실패", message: "일치하는 계정이 없습니다. 다시 시도해주세요.")
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
        button.isEnabled = isAllFieldsFilled
        button.backgroundColor = isAllFieldsFilled ? .black : .lightGray
    }
    
}
