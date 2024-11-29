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

class BusinessSignUpVC: UIViewController, UIScrollViewDelegate,UIDocumentPickerDelegate {
    lazy private var lbl_business: UILabel = {
        let lbl = UILabel()
        lbl.text = "signup_business_info".localized
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
        label.text = "1 / 3"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()
    lazy private var bodyTitle: UILabel = {
        let label = UILabel()
        let fullText = "signup_info".localized
        let highlightText = "signup_info_highlight".localized
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
    lazy private var lbl_name = makeLabel(text: "signup_business_name")
    lazy private var lbl_num = makeLabel(text: "signup_business_num")
    lazy private var lbl_license = makeLabel(text: "signup_business_license")

    // TextField
    lazy private var tf_name = makeTextField(placeholder: "signup_business_name_hint")
    lazy private var tf_num = makeTextField(placeholder: "signup_business_num_hint")
    lazy private var tf_license = makeTextField(placeholder: "signup_business_license_hint")

    // Button
    // lazy private var btn_address = makeButton(title: "주소검색")
    lazy private var btn_upload = makeButton(title: "첨부")
    lazy private var business: [(UILabel, UITextField, UIButton?)] = {
        return [ (lbl_name, tf_name, nil), (lbl_num, tf_num, nil), (lbl_license, tf_license, btn_upload)]
    }()
    
    lazy private var selectedFileUrl : String? = ""
    lazy private var scrollView = UIScrollView()
    lazy private var businessView = UIStackView()

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
        
        [tf_name, tf_num].forEach {
            $0.delegate = self
        }

        btn_upload.addTarget(self, action: #selector(handleUploadButtonTapped), for: .touchUpInside)
        setupBackButton()
        setupTitleLabel()
        setupScrollView()
        setupContentView()
        setupConstraints()
        setupGesture()
        validateForm()
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    private func setupScrollView() {
        scrollView.delegate = self
        view.addSubview(scrollView)
        businessView.axis = .vertical
        businessView.spacing = 8
        scrollView.addSubview(businessView)
        scrollView.addSubview(btn_submit)
    }

    private func setupContentView() {
        tf_num.keyboardType = .asciiCapableNumberPad
        tf_license.isEnabled = false
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

        businessView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }

        lbl_business.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }

        btn_submit.snp.makeConstraints {
            $0.top.equalTo(businessView.snp.bottom).offset(24)
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

//    @objc private func buttonTapped() {
//        let webViewController = KakaoZipCodeVC()
//        webViewController.modalPresentationStyle = .fullScreen
//        self.present(webViewController, animated: true, completion: nil)
//    }

    // 버튼 눌렀을 때 호출되는 메서드
    @objc private func handleUploadButtonTapped() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    @objc private func submitButtonTapped() {
        let vc = BusinessSignUpVC2()
        vc.businessObject = Business(license: tf_license.text, business_name: tf_name.text, licenseFile: selectedFileUrl)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BusinessSignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 키보드를 숨깁니다.
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        

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
        let name = tf_name.text ?? ""
        let license = tf_num.text ?? ""
        let file = tf_license.text ?? ""

        // 각 입력 필드의 값을 출력
        print("Name isValid: \(isValidInput(name))")
        print("License Number isValid: \(isValidInput(license))")
        print("License File isValid: \(file)")

        let isFormValid = isValidInput(name) &&
            isValidInput(license) &&
        isValidInput(file)

        btn_submit.isEnabled = isFormValid
        btn_submit.alpha = isFormValid ? 1.0 : 0.5 // 비활성화 시 시각적 피드백을 주기 위해 투명도 조절
        print("isFormValid: \(isFormValid)")
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // 선택된 파일 URL 가져오기
        guard let selectedFileURL = urls.first else {
            print("파일 선택이 취소되었습니다.")
            return
        }
        let accessGranted = selectedFileURL.startAccessingSecurityScopedResource()
        defer {
            if accessGranted {
                selectedFileURL.stopAccessingSecurityScopedResource()
            }
        }
        // 파일명 가져오기
        let fileName = selectedFileURL.lastPathComponent
        
        // 앱의 Documents 디렉토리 경로 가져오기
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsDirectory.appendingPathComponent(fileName)
        
        // 파일 복사
        do {
            // 이미 파일이 존재한다면 삭제
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            // 선택한 파일을 Documents 디렉토리로 복사
            try fileManager.copyItem(at: selectedFileURL, to: destinationURL)
            print("파일이 성공적으로 복사되었습니다: \(destinationURL)")
            
            // 복사된 파일 경로를 사용
            tf_license.text = fileName
            tf_license.textColor = UIColor.black // 파일명이 표시되었을 때 색상 변경
            selectedFileUrl = destinationURL.absoluteString // 앱 내부 파일 경로
            
            // 유효성 검사 업데이트
            validateForm()
        } catch {
            print("파일 복사 중 오류 발생: \(error.localizedDescription)")
        }
    }

    
    // 문서 선택 취소 시 호출
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("파일 선택이 취소되었습니다.")
    }
    
}
