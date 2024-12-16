//
//  BusinessJoinVC.swift
//  ByahtColor
//
//  Created by jaem on 6/12/24.
//

import Foundation
import UIKit
import SnapKit
import WebKit
import UniformTypeIdentifiers

class BusinessSignUpVC2: UIViewController, UIScrollViewDelegate,UIDocumentPickerDelegate {
    lazy private var lbl_manager: UILabel = {
        let lbl = UILabel()
        lbl.text = "signup_manager_info".localized
        lbl.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return lbl
    }()
    
    lazy private var btn_submit: UIButton = {
        let button = UIButton()
        button.setTitle("signup_next".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundColor(.lightGray, for: .disabled)
        button.setBackgroundColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy private var page_num: UILabel = {
       let label = UILabel()
        label.text = "2 / 3"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()
    
    lazy private var bodyTitle: UILabel = {
        let label = UILabel()
        let fullText = "signup2_info".localized
        let highlightText = "signup2_info_highlight".localized
        let attributedString = NSMutableAttributedString(string: fullText)
        if let range = fullText.range(of: highlightText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor(hex: "#0075FF"), range: nsRange)
        }
        
        label.attributedText = attributedString
        label.numberOfLines = 2
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        return label
    }()
    
    // Label
    lazy private var lbl_manager_name = makeLabel(text: "signup_manager_name")
    lazy private var lbl_manager_phone = makeLabel(text: "signup_manager_phone")
    lazy private var lbl_manager_email = makeLabel(text: "signup_manager_email")

    // TextField
    lazy private var tf_manager_name = makeTextField(placeholder: "signup_manager_name_hint")
    lazy private var tf_manager_phone = makeTextField(placeholder: "signup_manager_phone_hint")
    lazy private var tf_manager_email = makeTextField(placeholder: "signup_manager_email_hint")

    // Button
    
    lazy private var managers: [(UILabel, UITextField, UIButton?)] = {
        return [
            (lbl_manager_name, tf_manager_name, nil),
            (lbl_manager_phone, tf_manager_phone, nil),
            (lbl_manager_email, tf_manager_email, nil)
        ]
    }()
    lazy private var scrollView = UIScrollView()
    lazy private var managerView = UIStackView()
    
    var businessObject = Business()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F4F5F8")

        [tf_manager_name, tf_manager_email, tf_manager_phone].forEach {
            $0.delegate = self
        }

        
        setupBackButton()
        setupTitleLabel()
        setupScrollView()
        setupContentView()
        setupConstraints()
        setupGesture()
        setupKeyboardNotifications()
        validateForm()
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor(hex: "#F4F5F8")
        view.addSubview(scrollView)


        managerView.axis = .vertical
        managerView.spacing = 8
        scrollView.addSubview(managerView)
        
        scrollView.addSubview(btn_submit)
    }

    private func setupTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.text = "signup_business".localized
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        titleLabel.textColor = UIColor.black // 폰트 색상 설정
        self.navigationItem.titleView = titleLabel
        
        view.addSubview(page_num)
        view.addSubview(bodyTitle)
    }
    
    private func setupContentView() {
        tf_manager_phone.keyboardType = .asciiCapableNumberPad
        
        // 담당자 정보
        managerView.addArrangedSubview(lbl_manager)
        for (label, textField, button) in managers {
            let containerView = makeContainerView(withLabel: label, textField: textField, button: button)
            managerView.addArrangedSubview(containerView)
            containerView.snp.makeConstraints {
                $0.height.equalTo(48)
                $0.leading.trailing.equalToSuperview()
            }
        
        }
        
    }



    private func setupConstraints() {
        
        page_num.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        bodyTitle.snp.makeConstraints{
            $0.top.equalTo(page_num.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(bodyTitle.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        managerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        lbl_manager.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        btn_submit.snp.makeConstraints {
            $0.top.equalTo(managerView.snp.bottom).offset(24)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    

    @objc private func submitButtonTapped() {
        
        businessObject.manager_name = tf_manager_name.text
        businessObject.email = tf_manager_email.text
        businessObject.tel = tf_manager_phone.text
        
        let vc = BusinessSignUpVC3()
        vc.businessObject = self.businessObject
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }

    //키보드 올라갔다는 알림을 받으면 실행되는 메서드
    @objc func keyboardWillShow(_ sender:Notification){
            self.view.frame.origin.y = -150
    }
    //키보드 내려갔다는 알림을 받으면 실행되는 메서드
    @objc func keyboardWillHide(_ sender:Notification){
            self.view.frame.origin.y = 0
    }
 
    
}

extension BusinessSignUpVC2: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        let currentText = (textField.text as NSString?) ?? ""
        let updatedText = currentText.replacingCharacters(in: range, with: string)

        DispatchQueue.main.async {
            self.validateForm()
        }

        return true
    }


    // 유효성 검사 함수
    private func isValidInput(_ text: String?) -> Bool {
        return !(text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    }

    // 폼 유효성 검사 및 제출 버튼 활성화/비활성화
    private func validateForm() {
        
        let name = tf_manager_name.text ?? ""
        let email = tf_manager_email.text ?? ""
        let phone = tf_manager_phone.text ?? ""

        // 각 입력 필드의 값을 출력
        let isFormValid =
        isValidInput(name) &&
        isValidInput(email) &&
        isValidInput(phone)

        btn_submit.isEnabled = isFormValid
        btn_submit.alpha = isFormValid ? 1.0 : 0.5 // 비활성화 시 시각적 피드백을 주기 위해 투명도 조절
        print("isFormValid: \(isFormValid)")
    }
    
    

}
