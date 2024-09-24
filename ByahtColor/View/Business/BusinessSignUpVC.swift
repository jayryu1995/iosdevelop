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

class BusinessSignUpVC: UIViewController, UIScrollViewDelegate {
    lazy private var lbl_business: UILabel = {
        let lbl = UILabel()
        lbl.text = "signup_business_info".localized
        lbl.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return lbl
    }()

    lazy private var lbl_manager: UILabel = {
        let lbl = UILabel()
        lbl.text = "signup_manager_info".localized
        lbl.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return lbl
    }()

    lazy private var lbl_agreement: UILabel = {
        let lbl = UILabel()
        lbl.text = "signup_agreement".localized
        lbl.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return lbl
    }()

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

    lazy private var btn_submit: UIButton = {
        let button = UIButton()
        button.setTitle("signup_submit".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundColor(.lightGray, for: .disabled)
        button.setBackgroundColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()

    let texts = [
        "agree_1".localized,
        "agree_2".localized
    ]

    // Label
    lazy private var lbl_name = makeLabel(text: "signup_business_name")
    lazy private var lbl_address = makeLabel(text: "signup_business_address")
    lazy private var lbl_address_detail = makeLabel(text: "signup_business_address_detail")
    lazy private var lbl_num = makeLabel(text: "signup_business_num")
    lazy private var lbl_license = makeLabel(text: "signup_business_license")
    lazy private var lbl_manager_name = makeLabel(text: "signup_manager_name")
    lazy private var lbl_manager_phone = makeLabel(text: "signup_manager_phone")
    lazy private var lbl_manager_email = makeLabel(text: "signup_manager_email")
    lazy private var lbl_manager_id = makeLabel(text: "signup_manager_id")
    lazy private var lbl_manager_pwd = makeLabel(text: "signup_manager_pwd")
    lazy private var lbl_manager_pwd_check = makeLabel(text: "signup_manager_pwd_check")

    // TextField
    lazy private var tf_name = makeTextField(placeholder: "signup_business_name_hint")
    lazy private var tf_address = makeTextField(placeholder: "signup_business_address_hint")
    lazy private var tf_address_detail = makeTextField(placeholder: "signup_business_address_detail_hint")
    lazy private var tf_num = makeTextField(placeholder: "signup_business_num_hint")
    lazy private var tf_license = makeTextField(placeholder: "signup_business_license_hint")
    lazy private var tf_manager_name = makeTextField(placeholder: "signup_manager_name_hint")
    lazy private var tf_manager_phone = makeTextField(placeholder: "signup_manager_phone_hint")
    lazy private var tf_manager_email = makeTextField(placeholder: "signup_manager_email_hint")
    lazy private var tf_manager_id = makeTextField(placeholder: "signup_manager_id_hint")
    lazy private var tf_manager_pwd = makeTextField(placeholder: "signup_manager_pwd_hint")
    lazy private var tf_manager_pwd_check = makeTextField(placeholder: "signup_manager_pwd_check_hint")

    // Button
    // lazy private var btn_address = makeButton(title: "주소검색")
    // lazy private var btn_upload = makeButton(title: "첨부")
    lazy private var btn_checkId = makeButton(title: "signup_double_check".localized)

    lazy private var business: [(UILabel, UITextField, UIButton?)] = {
        return [ (lbl_name, tf_name, nil), (lbl_num, tf_num, nil) ]
    }()

    lazy private var managers: [(UILabel, UITextField, UIButton?)] = {
        return [
            (lbl_manager_id, tf_manager_id, btn_checkId),
            (lbl_manager_pwd, tf_manager_pwd, nil),
            (lbl_manager_pwd_check, tf_manager_pwd_check, nil)
        ]
    }()
    lazy private var viewModel = MemberViewModel()
    lazy private var scrollView = UIScrollView()
    lazy private var businessView = UIStackView()
    lazy private var managerView = UIStackView()
    lazy private var agreeView = UIView()
    private var agreeButtons: [UIButton] = []
    private var isIdChecked = false
    private var isCheckedPassword = false
    private var isAllAgreed: Bool {
        return agreeButtons.allSatisfy { $0.isSelected }
    }
    var webView: WKWebView!
    var address: String = "" {
        didSet {
            tf_address.text = address
        }
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
        view.backgroundColor = .white

        [tf_name, tf_num, tf_manager_id, tf_manager_pwd, tf_manager_pwd_check].forEach {
            $0.delegate = self
        }

        tf_manager_pwd.isSecureTextEntry = true
        tf_manager_pwd_check.isSecureTextEntry = true

        setupBackButton()
        setupTitleLabel()
        setupScrollView()
        setupContentView()
        setupAgreeView()
        setupConstraints()
        setupButtonsConfig()
        setupGesture()
        validateForm()
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    private func setupButtonsConfig() {
        btn_submit.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        // btn_address.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        btn_checkId.addTarget(self, action: #selector(buttonTapped3), for: .touchUpInside)
    }

    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor(hex: "#F4F5F8")
        view.addSubview(scrollView)

        businessView.axis = .vertical
        businessView.spacing = 8
        scrollView.addSubview(businessView)

        managerView.axis = .vertical
        managerView.spacing = 8
        scrollView.addSubview(managerView)
        scrollView.addSubview(lbl_agreement)
        scrollView.addSubview(agreeView)
        scrollView.addSubview(btn_submit)
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

    private func setupContentView() {
        tf_num.keyboardType = .asciiCapableNumberPad
        tf_manager_id.keyboardType = .asciiCapable
        tf_manager_pwd.keyboardType = .asciiCapable
        tf_manager_pwd_check.keyboardType = .asciiCapable

        // 기업
        businessView.addArrangedSubview(lbl_business)
        for (label, textField, button) in business {
            let containerView = makeContainerView(withLabel: label, textField: textField, button: button)
            textField.delegate = self
            businessView.addArrangedSubview(containerView)
            containerView.snp.makeConstraints {
                $0.height.equalTo(48)
                $0.leading.trailing.equalToSuperview()
            }
        }

        // 담당자 정보
        managerView.addArrangedSubview(lbl_manager)
        for (label, textField, button) in managers {
            let containerView = makeContainerView(withLabel: label, textField: textField, button: button)
            managerView.addArrangedSubview(containerView)
            containerView.snp.makeConstraints {
                $0.height.equalTo(48)
                $0.leading.trailing.equalToSuperview()
            }

            if label == lbl_manager_id {
                managerView.addArrangedSubview(lbl_id_message)
                lbl_id_message.snp.makeConstraints {
                    $0.height.equalTo(20)
                    $0.leading.trailing.equalToSuperview().inset(10)
                }
            }

            if label == lbl_manager_pwd_check {
                managerView.addArrangedSubview(lbl_pwd_message)
                lbl_pwd_message.snp.makeConstraints {
                    $0.height.equalTo(20)
                    $0.leading.trailing.equalToSuperview().inset(10)
                }
            }
        }

    }

    private func makeContainerView(withLabel label: UILabel, textField: UITextField, button: UIButton?) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 4
        containerView.addSubview(label)

        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill

        stackView.addArrangedSubview(textField)
        if let button = button {
            stackView.addArrangedSubview(button)
        }

        containerView.addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.leading.equalTo(label.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }

        if let button = button {
            button.snp.makeConstraints {
                $0.width.equalTo(60)
            }
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        return containerView
    }

    // 라벨 탭 제스처 핸들러
    @objc private func labelTapped(_ sender: UITapGestureRecognizer) {
        let agreementVC = AgreementVC()
        agreementVC.index = sender.view?.tag ?? 0
        agreementVC.delegate = self
        self.navigationController?.pushViewController(agreementVC, animated: false)
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        businessView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(37)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }

        managerView.snp.makeConstraints {
            $0.top.equalTo(businessView.snp.bottom).offset(24)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }

        lbl_business.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }

        lbl_manager.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }

        lbl_agreement.snp.makeConstraints {
            $0.top.equalTo(managerView.snp.bottom).offset(24)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }

        agreeView.snp.makeConstraints {
            $0.top.equalTo(lbl_agreement.snp.bottom).offset(10)
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

    private func makeButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(hex: "#4E505B"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.layer.borderColor = UIColor(hex: "#B5B8C2").cgColor
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }

    private func makeLabel(text: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = text.localized
        lbl.font = UIFont(name: "Pretendard-Regular", size: 14)
        lbl.textColor = UIColor(hex: "#4E505B")
        return lbl
    }

    private func makeTextField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder.localized
        tf.textColor = UIColor(hex: "#B5B8C2")
        tf.font = UIFont(name: "Pretendard-Regular", size: 14)
        return tf
    }

    private func setupTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.text = "signup_business".localized
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        titleLabel.textColor = UIColor.black // 폰트 색상 설정
        self.navigationItem.titleView = titleLabel
    }

//    @objc private func buttonTapped() {
//        let webViewController = KakaoZipCodeVC()
//        webViewController.modalPresentationStyle = .fullScreen
//        self.present(webViewController, animated: true, completion: nil)
//    }

    @objc private func checkButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            agreeButtons.append(sender)
            validateForm()
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

    @objc private func submitButtonTapped() {
        let member = Member(id: tf_manager_id.text ?? "", auth: 1, regi_date: nil)
        let business = Business(
            license: tf_num.text ?? "test", memberId: tf_manager_id.text ?? "",
            password: tf_manager_pwd.text ?? "", business_name: tf_name.text ?? "",
            address1: tf_address.text ?? "", address2: tf_address_detail.text ?? "",
            licenseFile: tf_license.text ?? "", managerName: tf_manager_name.text ?? "",
            tel: tf_manager_phone.text ?? "", email: tf_manager_email.text ?? "", imagePath: ""
        )
        viewModel.updateMemberBusiness(memberBusinessDto: MemberBusinessDto(member: member, business: business)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseString):

                    User.shared.id = member.id
                    User.shared.name = business.business_name
                    self?.navigationController?.popViewController(animated: false)
                    print( "Success: \(responseString)")
                case .failure(let error):
                    print( "Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension BusinessSignUpVC: UITextFieldDelegate, AgreementVCDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 키보드를 숨깁니다.
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tf_manager_id {
            let allowedCharacters = CharacterSet.lowercaseLetters.union(.decimalDigits)
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
        }

        let currentText = (textField.text as NSString?) ?? ""
        let updatedText = currentText.replacingCharacters(in: range, with: string)

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

    func validatePasswords(updatedPwd: String, updatedPwdCheck: String) {
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

    // 폼 유효성 검사 및 제출 버튼 활성화/비활성화
    private func validateForm() {
        let name = tf_name.text ?? ""
        let license = tf_num.text ?? ""
        let address = tf_address.text ?? ""
        let managerId = tf_manager_id.text ?? ""
        let managerPwd = tf_manager_pwd.text ?? ""
        let managerPwdCheck = tf_manager_pwd_check.text ?? ""

        // 각 입력 필드의 값을 출력
        print("Name isValid: \(isValidInput(name))")
        print("License isValid: \(isValidInput(license))")
        print("License isValid: \(license)")
        print("Manager ID isValid: \(isValidInput(managerId))")
        print("Manager Password isValid: \(isValidInput(managerPwd))")
        print("Manager Password Check isValid: \(isValidInput(managerPwdCheck))")
        print("Is Checked Password: \(isCheckedPassword)")
        print("Is ID Checked: \(isIdChecked)")
        print("Is All Agreed: \(isAllAgreed)")

        let isFormValid = isValidInput(name) &&
            isValidInput(license) &&
            isValidInput(managerId) &&
            isValidInput(managerPwd) &&
            isValidInput(managerPwdCheck) &&
            isCheckedPassword &&
            isIdChecked && isAllAgreed

        btn_submit.isEnabled = isFormValid
        btn_submit.alpha = isFormValid ? 1.0 : 0.5 // 비활성화 시 시각적 피드백을 주기 위해 투명도 조절
        print("isFormValid: \(isFormValid)")
    }

}
