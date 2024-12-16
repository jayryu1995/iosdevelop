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

class BusinessSignUpVC3: UIViewController, UIScrollViewDelegate,UIDocumentPickerDelegate {
    
    
    lazy private var lbl_id_message: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Pretendard-Regular", size: 14)
        lbl.text = "signup_check_id_message".localized
        lbl.textColor = UIColor(hex: "#009BF2")
        return lbl
    }()
    
    lazy private var lbl_pwd_message: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Pretendard-Regular", size: 14)
        lbl.text = "signup_check_password_message".localized
        return lbl
    }()
    
    lazy private var lbl_agreement: UILabel = {
        let lbl = UILabel()
        lbl.text = "signup_agreement".localized
        lbl.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return lbl
    }()
    
    lazy private var btn_submit: UIButton = {
        let button = UIButton()
        button.setTitle("signup_submit".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundColor(.lightGray, for: .disabled)
        button.setBackgroundColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()
    
    lazy private var page_num: UILabel = {
        let label = UILabel()
        label.text = "3 / 3"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()
    
    lazy private var bodyTitle: UILabel = {
        let label = UILabel()
        let fullText = "signup3_info".localized
        let highlightText = "signup3_info_highlight".localized
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
    
    lazy private var lbl_manager_id = makeLabel(text: "signup_manager_id")
    lazy private var lbl_manager_pwd = makeLabel(text: "signup_manager_pwd")
    lazy private var lbl_manager_pwd_check = makeLabel(text: "signup_manager_pwd_check")
    lazy private var tf_manager_id = makeTextField(placeholder: "signup_manager_id_hint")
    lazy private var tf_manager_pwd = makeTextField(placeholder: "signup_manager_pwd_hint")
    lazy private var tf_manager_pwd_check = makeTextField(placeholder: "signup_manager_pwd_check_hint")
    
    lazy private var btn_checkId = makeButton(title: "signup_double_check".localized)
    lazy private var managers: [(UILabel, UITextField, UIButton?)] = {
        return [
            (lbl_manager_id, tf_manager_id, btn_checkId),
            (lbl_manager_pwd, tf_manager_pwd, nil),
            (lbl_manager_pwd_check, tf_manager_pwd_check, nil)
        ]
    }()
    
    private var isIdChecked = false
    private var isCheckedPassword = false
    
    lazy private var accountView = UIStackView()
    private let texts = [
        "agree_1".localized,
        "agree_2".localized
    ]
    
    var businessObject = Business()
    lazy private var viewModel = MemberViewModel()
    lazy private var scrollView = UIScrollView()
    lazy private var agreeView = UIView()
    lazy private var agreeButtons: [UIButton] = []
    private var activityIndicator: UIActivityIndicatorView!
    private var isAllAgreed: Bool {
        return agreeButtons.allSatisfy { $0.isSelected }
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
        [tf_manager_id, tf_manager_pwd, tf_manager_pwd_check].forEach {
            $0.delegate = self
        }
        
        // 스피너 초기화 및 설정
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        tf_manager_id.keyboardType = .asciiCapable
        tf_manager_pwd.keyboardType = .asciiCapable
        tf_manager_pwd_check.keyboardType = .asciiCapable
        tf_manager_id.autocapitalizationType = .none
        tf_manager_pwd.isSecureTextEntry = true
        tf_manager_pwd_check.isSecureTextEntry = true
        
        view.addSubview(activityIndicator)
        setupBackButton()
        setupTitleLabel()
        setupScrollView()
        setupAgreeView()
        setupContentView()
        setupButtonsConfig()
        setupConstraints()
        setupGesture()
        validateForm()
    }
    
    private func setupButtonsConfig() {
        btn_checkId.addTarget(self, action: #selector(buttonTapped3), for: .touchUpInside)
    }
    
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor(hex: "#F4F5F8")
        view.addSubview(scrollView)
        accountView.axis = .vertical
        accountView.spacing = 8
        scrollView.addSubview(accountView)
        scrollView.addSubview(agreeView)
        scrollView.addSubview(btn_submit)
        scrollView.addSubview(lbl_agreement)
    }
    
    private func setupContentView() {
        
        
        // 담당자 정보
        
        for (label, textField, button) in managers {
            let containerView = makeContainerView(withLabel: label, textField: textField, button: button)
            accountView.addArrangedSubview(containerView)
            containerView.snp.makeConstraints {
                $0.height.equalTo(48)
                $0.leading.trailing.equalToSuperview()
            }
            
            if label == lbl_manager_id {
                accountView.addArrangedSubview(lbl_id_message)
                lbl_id_message.snp.makeConstraints {
                    $0.height.equalTo(20)
                    $0.leading.trailing.equalToSuperview().inset(10)
                }
            }
            
            if label == lbl_manager_pwd_check {
                accountView.addArrangedSubview(lbl_pwd_message)
                lbl_pwd_message.snp.makeConstraints {
                    $0.height.equalTo(20)
                    $0.leading.trailing.equalToSuperview().inset(10)
                }
            }
        }
        
    }
    
    private func setupAgreeView() {
        agreeView.layer.cornerRadius = 4
        agreeView.backgroundColor = .white
        agreeView.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        agreeView.layer.borderWidth = 1.0
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        agreeView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        for(index, text) in texts.enumerated() {
            addHorizonStackView(to: stackView, text: text, index: index)
        }
    }
    
    private func addHorizonStackView(to parentStackView: UIStackView, text: String, index: Int) {
        let horizonStackView = UIStackView()
        horizonStackView.axis = .horizontal
        horizonStackView.distribution = .fill
        horizonStackView.spacing = 8
        parentStackView.addArrangedSubview(horizonStackView)
        
        horizonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(20)
        }
        
        let checkButton = UIButton()
        checkButton.contentMode = .scaleAspectFit
        checkButton.setImage(UIImage(named: "icon_inactive"), for: .normal)
        checkButton.setImage(UIImage(named: "icon_active"), for: .selected)
        checkButton.backgroundColor = .white
        checkButton.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
        agreeButtons.append(checkButton)
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = UIColor(hex: "#4E505B")
        label.isUserInteractionEnabled = true // 라벨이 제스처를 인식할 수 있도록 설정
        label.tag = index
        
        // 라벨에 탭 제스처 인식기 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        label.addGestureRecognizer(tapGesture)
        
        horizonStackView.addArrangedSubview(checkButton)
        horizonStackView.addArrangedSubview(label)
        
        checkButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(20)
            $0.leading.equalTo(checkButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
    
    // 라벨 탭 제스처 핸들러
    @objc private func labelTapped(_ sender: UITapGestureRecognizer) {
        let agreementVC = AgreementVC()
        agreementVC.index = sender.view?.tag ?? 0
        agreementVC.delegate = self
        self.navigationController?.pushViewController(agreementVC, animated: false)
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
        
        lbl_agreement.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        accountView.snp.makeConstraints{
            $0.top.equalTo(lbl_agreement.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        agreeView.snp.makeConstraints {
            $0.top.equalTo(accountView.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        btn_submit.snp.makeConstraints {
            $0.top.equalTo(agreeView.snp.bottom).offset(24)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().offset(-20)
        }
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
    
    @objc private func checkButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            agreeButtons.append(sender)
        }
        validateForm()
    }
    
    @objc private func submitButtonTapped() {
        print("submitButtonTapped")
        businessObject.memberId = tf_manager_id.text
        businessObject.password = tf_manager_pwd.text
        let member = Member(id: businessObject.memberId!, auth: 2, regi_date: nil)
        let business = businessObject
        print(business)
        view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
        viewModel.updateMemberBusiness(memberBusinessDto: MemberBusinessDto(member: member, business: business)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseString):
                    self?.activityIndicator.stopAnimating()
                    User.shared.id = member.id
                    User.shared.name = business.business_name
                    if let navigationController = self?.navigationController {
                        for viewController in navigationController.viewControllers {
                            if let userLoginVC = viewController as? LoginVC {
                                navigationController.popToViewController(userLoginVC, animated: true)
                                return
                            }
                        }
                    }
                    print( "Success: \(responseString)")
                case .failure(let error):
                    self?.activityIndicator.stopAnimating()
                    print( "Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc private func buttonTapped3() {
        guard let memberId = tf_manager_id.text, !memberId.isEmpty else {
            lbl_id_message.text = "signup_check_id_message".localized
            lbl_id_message.textColor = UIColor(hex: "#FF2727")
            return
        }
        
        viewModel.checkMemberId(id: memberId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    if message {
                        self?.lbl_id_message.text = "signup_check_id_message2".localized
                        self?.lbl_id_message.textColor = UIColor(hex: "#FF2727")
                        self?.isIdChecked = false
                    } else {
                        self?.lbl_id_message.text = "signup_check_id_message3".localized
                        self?.lbl_id_message.textColor = UIColor(hex: "#009BF2")
                        self?.isIdChecked = true
                        
                    }
                    self?.validateForm()
                    
                case .failure(let error):
                    self?.lbl_id_message.text = "Error: \(error.localizedDescription)"
                    self?.isIdChecked = false
                    self?.validateForm()
                }
            }
        }
    }
}

extension BusinessSignUpVC3: AgreementVCDelegate, UITextFieldDelegate {
    
    func didAgree(with index: Int) {
        // 전달받은 index 값으로 필요한 작업 수행
        print("Agreed with index: \(index)")
        agreeButtons[index].isSelected = true
        validateForm()
    }
    
    // 유효성 검사 함수
    private func isValidInput(_ text: String?) -> Bool {
        return !(text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = (textField.text as NSString?) ?? ""
        let updatedText = currentText.replacingCharacters(in: range, with: string)

        if textField == tf_manager_id {
            let allowedCharacters = CharacterSet.lowercaseLetters.union(.decimalDigits)
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
        }
                
        if textField == tf_manager_pwd || textField == tf_manager_pwd_check {
            DispatchQueue.main.async {
                let updatedPwd = (textField == self.tf_manager_pwd) ? updatedText : self.tf_manager_pwd.text ?? ""
                let updatedPwdCheck = (textField == self.tf_manager_pwd_check) ? updatedText : self.tf_manager_pwd_check.text ?? ""
                self.validatePasswords(updatedPwd: updatedPwd, updatedPwdCheck: updatedPwdCheck)
            }
        }
        
        DispatchQueue.main.async {
            self.validateForm()
        }
        
        return true
    }
    
    private func validatePasswords(updatedPwd: String, updatedPwdCheck: String) {
        print("tf_pwd \(updatedPwd) : tf_check \(updatedPwdCheck)")
        
        if updatedPwd.isEmpty || updatedPwdCheck.isEmpty {
            lbl_pwd_message.text = "signup_check_password_message".localized
            lbl_pwd_message.textColor = .red
        } else if updatedPwd != updatedPwdCheck {
            lbl_pwd_message.text = "signup_check_password_message2".localized
            lbl_pwd_message.textColor = .red
        } else {
            isCheckedPassword = true
            lbl_pwd_message.text = ""
            lbl_pwd_message.textColor = UIColor(hex: "#009BF2")
        }
    }
    
    // 폼 유효성 검사 및 제출 버튼 활성화/비활성화
    private func validateForm() {
        
        let id = tf_manager_id.text ?? ""
        let pwd = tf_manager_pwd.text ?? ""
        let pwdCheck = tf_manager_pwd_check.text ?? ""

        // 각 입력 필드의 값을 출력
        let isFormValid =
        isValidInput(id) &&
        isValidInput(pwd) &&
        isValidInput(pwdCheck) &&
        isCheckedPassword &&
        isIdChecked && isAllAgreed
        
        btn_submit.isEnabled = isFormValid
        btn_submit.alpha = isFormValid ? 1.0 : 0.5 // 비활성화 시 시각적 피드백을 주기 위해 투명도 조절
        
        print("isFormValid: \(isFormValid)")
    }
    
}
