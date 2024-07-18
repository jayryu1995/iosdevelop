//
//  MainView.swift
//  ByahtColor
//
//  Created by jaem on 2023/12/20.
//

import Foundation
import SnapKit
import Alamofire

class NicknameView: UIViewController, UITextViewDelegate {

    private let textLabel = UILabel()
    private let textView = UITextView()
    private let logoImageView = UIImageView()
    private let submitButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 탭 제스처 인식기 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        configureView()
        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustTextViewContentInset()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureView() {
        view.backgroundColor = .white
        configureLogoImageView()
        configureTextLabel()
        configureTextView()
        configuresubmitButton()
    }

    private func configuresubmitButton() {
        submitButton.setTitle("Hoàn thành", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.backgroundColor = UIColor(hex: "#C8C8C8")
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.2)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
        }
    }

    private func configureLogoImageView() {
        logoImageView.image = UIImage(named: "logo2")
        let barButtonItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.leftBarButtonItem = barButtonItem
    }

    private func configureTextLabel() {
        textLabel.text = "Nhập nickname của bạn"
        textLabel.numberOfLines = 2
        textLabel.font = UIFont(name: "Pretendard-SemiBold", size: 28)
        view.addSubview(textLabel)
    }

    private func configureTextView() {
        textView.delegate = self
        textView.backgroundColor = UIColor(hex: "#F4F5F8")
        textView.layer.cornerRadius = 10
        textView.text = "Nhập vào đây"
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        textView.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        textView.textColor = UIColor(hex: "#4E505B")
        view.addSubview(textView)
    }

    private func setupConstraints() {
        textLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.6)
            make.leading.equalToSuperview().offset(20)

        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.text == "Nhập nickname của bạn" && textView.textColor == UIColor(hex: "#4E505B") {
            textView.text = nil
            textView.textColor = UIColor.black // 사용자가 입력을 시작할 때의 색상
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Nhập nickname của bạn"
            textView.textColor = UIColor(hex: "#4E505B")
            submitButton.isEnabled = false
            submitButton.backgroundColor = UIColor(hex: "#C8C8C8") // 비활성화 상태의 색상

        } else {
            submitButton.isEnabled = true
            submitButton.backgroundColor = .black// 활성화 상태의 색상
        }
    }

    func adjustTextViewContentInset() {
        let textViewSize = textView.bounds.size
        let textSize = textView.sizeThatFits(CGSize(width: textViewSize.width, height: CGFloat.greatestFiniteMagnitude))
        let topBottomInset = (textViewSize.height - textSize.height) / 2.0
        textView.contentInset = UIEdgeInsets(top: max(0, topBottomInset), left: 0, bottom: 0, right: 0)
    }

    // UITextViewDelegate 메소드
    func textViewDidChange(_ textView: UITextView) {
        adjustTextViewContentInset()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 엔터 키 감지
        if text == "\n" {
            textView.resignFirstResponder() // 키보드 숨기기
            return false // 라인 브레이크 추가 방지
        }

        // 현재 텍스트와 변경될 텍스트를 결합
        let currentText = textView.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // 입력 가능한 최대 문자 길이를 10으로 제한
        return updatedText.count <= 14
    }

    // 탭 제스처 핸들러
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }

    // submitButton
    @objc private func submitButtonTapped() {

        User.shared.updateNickName(nickname: textView.text)
        let url = Bundle.main.TEST_URL + "/join"
        AF.request(url, method: .post, parameters: User.shared, encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success:
                let vc = TabBarViewController()
                self.navigationController?.pushViewController(vc, animated: true)

            case .failure(let error):
                self.log(message: "submitButtonTapped error : \(error)")
            }
        }
    }
}
