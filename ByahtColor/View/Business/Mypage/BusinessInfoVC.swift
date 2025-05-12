//
//  BusinessInfoVC.swift
//  ByahtColor
//
//  Created by jaem on 12/17/24.
//

import Foundation
import UIKit
import SnapKit

class BusinessInfoVC: UIViewController {
    
    // Label
    lazy private var titleLabel = {
        let label = UILabel()
        label.text = "signup_business_info".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    lazy private var subTitleLabel = {
        let label = UILabel()
        label.text = "change_info_message".localized
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = UIColor(hex: "#4E505B")
        return label
    }()
    lazy private var titleLabel2 = {
        let label = UILabel()
        label.text = "signup2_info_highlight".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    lazy private var businessNameLabel = {
        let label = UILabel()
        label.text = "signup_business_name".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    lazy private var licenseNumLabel = {
        let label = UILabel()
        label.text = "signup_business_num".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    lazy private var licenseLabel = {
        let label = UILabel()
        label.text = "signup_business_license".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    lazy private var accountLabel: UILabel = {
        let label = UILabel()
        let text = "change_account".localized
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        label.attributedText = attributedString
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = UIColor(hex: "#4E505B")
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAccountLabelTap))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    lazy private var businessNameLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = UIColor(hex: "#4E505B")
        return label
    }()
    lazy private var licenseNumLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = UIColor(hex: "#4E505B")
        return label
    }()
    lazy private var licenseLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = UIColor(hex: "#4E505B")
        return label
    }()
    

    lazy private var lbl_manager_email = makeLabel(text: "signup_manager_email")
    //    lazy private var lbl_manager_name = makeLabel(text: "signup_manager_name")
    //    lazy private var lbl_manager_phone = makeLabel(text: "signup_manager_phone")
    
    // TextField
    lazy private var tf_manager_email = makeTextField(placeholder: "signup_manager_email_hint")
    //    lazy private var tf_manager_name = makeTextField(placeholder: "signup_manager_name_hint")
    //    lazy private var tf_manager_phone = makeTextField(placeholder: "signup_manager_phone_hint")

    // Button
    lazy private var submitButton = {
        let button = UIButton()
        button.setTitle("저장하기".localized, for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()
    lazy private var managers: [(UILabel, UITextField)] = {
        return [
            (lbl_manager_email, tf_manager_email)
        ]
    }()
    lazy private var businessView = UIStackView()
    lazy private var managerView = UIStackView()
    
    // ViewModel
    lazy private var viewModel = BusinessViewModel()
    
    // loadingPage
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        view.backgroundColor = .white
        self.navigationItem.title = "회사정보 수정".localized
        setupProfile()
        setupBackButton()
        setupUI()
        setupContentView()
        setupConstraints()
        
    }
    
    private func setupProfile() {
        if let id = User.shared.id {
            viewModel.getBusinessMypageInfo(id: id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        
                        self?.businessNameLabel2.text = data.businessName
                        self?.licenseNumLabel2.text = data.license
                        self?.licenseLabel2.text = "\(data.memberId ?? "").pdf"
                        //self?.tf_manager_name.text = data.managerName
                        self?.tf_manager_email.text = data.email
                        //self?.tf_manager_phone.text = data.tel
                        
                    case .failure(let error):
                        print("통신 에러 : \(error)")
                        
                    }
                }
            }
        }
    }
    
    private func setupUI() {
        // 스피너 초기화 및 설정
        activityIndicator = UIActivityIndicatorView(style: .large)
        [tf_manager_email].forEach {
            $0.delegate = self
        }
        // 기업정보
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(businessView)
        
        // 담당자정보
        view.addSubview(titleLabel2)
        view.addSubview(managerView)
        
        // 계정상태변경
        view.addSubview(accountLabel)
        
        // 저장버튼
        view.addSubview(submitButton)
        view.addSubview(activityIndicator)
        
    }
    
    private func setupContentView() {
        
        // 기업정보
        businessView.axis = .vertical
        businessView.spacing = 8
      
        let businessName = makeContainer(label: businessNameLabel,label2: businessNameLabel2)
        let businessLicenseNum = makeContainer(label: licenseNumLabel,label2: licenseNumLabel2)
        let businessLicense = makeContainer(label: licenseLabel,label2: licenseLabel2)
        businessView.addArrangedSubview(businessName)
        businessView.addArrangedSubview(businessLicenseNum)
        businessView.addArrangedSubview(businessLicense)
        
        // 담당자 정보
        managerView.axis = .vertical
        managerView.spacing = 8
        //tf_manager_phone.keyboardType = .asciiCapableNumberPad
        
        for (label, textField) in managers {
            let containerView = makeContainerView(withLabel: label, textField: textField, button: nil)
            managerView.addArrangedSubview(containerView)
            containerView.snp.makeConstraints {
                $0.height.equalTo(48)
                $0.leading.trailing.equalToSuperview()
            }
        
        }
    }
    
    private func makeContainer(label: UILabel,label2: UILabel) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 4
        containerView.backgroundColor = UIColor(hex: "#F4F5F8")
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
        stackView.addArrangedSubview(label2)
       
        containerView.addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.leading.equalTo(label.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }

        return containerView
    }

    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        subTitleLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        businessView.snp.makeConstraints{
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
     
        titleLabel2.snp.makeConstraints{
            $0.top.equalTo(businessView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        managerView.snp.makeConstraints{
            $0.top.equalTo(titleLabel2.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        submitButton.snp.makeConstraints{
            $0.top.equalTo(managerView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
    
        accountLabel.snp.makeConstraints{
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.centerX.equalToSuperview()
        }
        
        // activityIndicator 위치 설정
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview() // 화면 중앙
            $0.edges.equalToSuperview()
        }
    }
    
}

extension BusinessInfoVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 제한할 텍스트 길이
        let maxLength = 20
        // 새로운 텍스트 길이 계산
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
      
        return newString.length <= maxLength
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

    // 터치 이벤트 핸들러
    @objc private func handleAccountLabelTap() {
        print("Account label tapped")
        let vc = BusinessAccountVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // ButtonTapped
    @objc private func submitButtonTapped() {
        print("submit button tapped")
        
        // 필수 입력 항목 검사
        guard let businessName = businessNameLabel2.text, !businessName.isEmpty,
              let license = licenseNumLabel2.text, !license.isEmpty,
//              let managerName = tf_manager_name.text, !managerName.isEmpty,
//              let tel = tf_manager_phone.text, !tel.isEmpty,
              let email = tf_manager_email.text, !email.isEmpty else {
            self.showAlert(title: "error_input".localized, message: "error_input_message".localized)
            return
        }
        
        // DTO 생성
        let dto = BusinessMyPageDto(memberId: User.shared.id ?? "",
                                    businessName: businessName,
                                    license: license,
                                    managerName: nil,
                                    tel: nil,
                                    email: email)
        
        // 통신 호출
        viewModel.updateMypageInfo(dto: dto) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.navigationController?.popViewController(animated: false)
                    
                case .failure(let error):
                    print("통신 에러 : \(error)")
                    self.showAlert(title: "Error", message: "An error has occurred.")
                }
            }
        }
    }

}
