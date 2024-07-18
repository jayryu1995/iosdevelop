//
//  AddExperienceVC.swift
//  ByahtColor
//
//  Created by jaem on 6/24/24.
//

import Foundation
import UIKit
import SnapKit
import DropDown

class AddExperienceVC: UIViewController {
    weak var delegate: AddExperienceVCDelegate?
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let viewLayer: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(hex: "#F7F7F7").cgColor
        view.layer.borderWidth = 1
        return view
    }()
    private let businessLabel: UILabel = {
        let label = UILabel()
        label.text = "add_experience_business".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let businessField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "add_experience_business_hint".localized
        tf.font = UIFont(name: "Pretendard-Regular", size: 14)
        tf.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 4
        tf.leftPadding()
        return tf
    }()

    private let snsLabel: UILabel = {
        let label = UILabel()
        label.text = "add_sns_platform".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.text = "add_experience_content".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let contentsField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "add_experience_content_hint".localized
        tf.font = UIFont(name: "Pretendard-Regular", size: 14)
        tf.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 4
        tf.leftPadding()
        return tf
    }()

    private let linkLabel: UILabel = {
        let label = UILabel()
        label.text = "add_experience_link".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let linkField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "add_experience_link_hint".localized
        tf.font = UIFont(name: "Pretendard-Regular", size: 14)
        tf.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 4
        tf.leftPadding()
        return tf
    }()

    private let selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("add".localized, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.backgroundColor = UIColor.black
        button.setImage(UIImage(named: "icon_search"), for: .normal)
        button.layer.cornerRadius = 4
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()

    // 선택된 버튼들을 저장할 배열
    private var snsButtons: [UIButton] = []
    private var selectedSns: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setTitleLabel()
        setupScrollView()
        setupUI()
        setupKeyboardObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.width.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupUI() {
        let snsTags = ["TikTok", "Instagram", "Facebook", "Naver"]
        let snsButtons = createHorizontalStackView(tags: snsTags)
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)

        contentView.addSubview(selectButton)
        contentView.addSubview(snsLabel)
        contentView.addSubview(snsButtons)
        contentView.addSubview(contentsLabel)
        contentView.addSubview(linkLabel)
        contentView.addSubview(linkField)
        contentView.addSubview(contentsField)
        contentView.addSubview(businessLabel)
        contentView.addSubview(businessField)

        businessLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        businessField.snp.makeConstraints {
            $0.top.equalTo(businessLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }

        snsLabel.snp.makeConstraints {
            $0.top.equalTo(businessField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        snsButtons.snp.makeConstraints {
            $0.top.equalTo(snsLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(20)
        }

        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(snsButtons.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }

        contentsField.snp.makeConstraints {
            $0.top.equalTo(contentsLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }

        linkLabel.snp.makeConstraints {
            $0.top.equalTo(contentsField.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }

        linkField.snp.makeConstraints {
            $0.top.equalTo(linkLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }

        selectButton.snp.makeConstraints {
            $0.top.equalTo(linkField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }

    private func setTitleLabel() {
        titleLabel.text = "add_experience_title".localized
        titleLabel.font = UIFont(name: "Pretendard-Medium", size: 14)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }

        view.addSubview(viewLayer)
        viewLayer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    // 이 함수는 태그 이름의 배열을 받아서 수평 스택뷰를 생성하고 반환합니다.
    private func createHorizontalStackView(tags: [String]) -> UIStackView {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 8
        horizontalStackView.isUserInteractionEnabled = true

        for tagName in tags {
            let tagButton = UIButton()
            tagButton.setTitle(tagName, for: .normal)
            tagButton.backgroundColor = .white
            tagButton.setTitleColor(UIColor(hex: "#4E505B"), for: .normal)
            tagButton.addTarget(self, action: #selector(snsButtonTapped), for: .touchUpInside)
            snsButtons.append(tagButton)
            tagButton.sizeToFit()
            tagButton.isUserInteractionEnabled = true
            tagButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
            tagButton.layer.cornerRadius = 16
            tagButton.layer.borderWidth = 1
            tagButton.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor

            // 텍스트의 inset 설정
            tagButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)

            horizontalStackView.addArrangedSubview(tagButton)

            tagButton.snp.makeConstraints { make in
                make.width.greaterThanOrEqualTo(60)
                make.height.equalTo(32)
            }
        }

        return horizontalStackView
    }

    @objc func snsButtonTapped(_ sender: UIButton) {
        let filter = sender.titleLabel?.text ?? ""

        // 모든 버튼을 비활성화
        for button in snsButtons {
            button.isSelected = false
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
        }

        // 현재 눌린 버튼만 활성화
        sender.isSelected = true
        sender.backgroundColor = .black
        sender.setTitleColor(.white, for: .normal)

        // 선택된 SNS 업데이트
        selectedSns = filter
    }

    @objc private func selectButtonTapped() {
        guard validateForm() else { return }

        var sns = 0
        switch selectedSns {
        case "TikTok": sns = 0
        case "Instagram": sns = 1
        case "Facebook": sns = 2
        case "Naver": sns = 3
        default: sns = 0
        }

        delegate?.didTapButton(
            self,
            getData: Experience(sns: sns, contents: contentsField.text ?? "", business: businessField.text ?? "", link: linkField.text ?? ""))
        dismiss(animated: true)
    }

    private func validateForm() -> Bool {
        // 각 필드의 유효성 검사
        if businessField.text?.isEmpty ?? true {
            showAlert(message: "add_experience_message1".localized)
            return false
        }

        if selectedSns.isEmpty {
            showAlert(message: "add_experience_message2".localized)
            return false
        }

        if contentsField.text?.isEmpty ?? true {
            showAlert(message: "add_experience_message3".localized)
            return false
        }

        if linkField.text?.isEmpty ?? true {
            showAlert(message: "add_experience_message4".localized)
            return false
        }

        if !isValidURL(linkField.text ?? "") {
            showAlert(message: "add_experience_message5".localized)
                return false
            }

        // 모든 유효성 검사를 통과하면 true를 반환
        return true
    }

    // URL 형식 유효성 검사 함수
    private func isValidURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    // 경고 메시지를 표시하는 함수
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height

        // 현재 활성화된 텍스트 필드가 키보드에 의해 가려지지 않도록 스크롤 뷰의 인셋을 조정합니다.
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardHeight
        scrollView.contentInset = contentInset
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        // 키보드가 사라질 때 스크롤 뷰의 인셋을 원래대로 되돌립니다.
        scrollView.contentInset = .zero
    }
}

protocol AddExperienceVCDelegate: AnyObject {
    func didTapButton(_ VC: AddExperienceVC, getData: Experience)
}
