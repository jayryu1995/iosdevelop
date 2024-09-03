//
//  AddSnsVC.swift
//  ByahtColor
//
//  Created by jaem on 6/24/24.
//

import Foundation
import UIKit
import SnapKit

class AddSnsVC: UIViewController {
    weak var delegate: AddSnsVCDelegate?
    let titleLabel = UILabel()
    private let viewLayer: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(hex: "#F7F7F7").cgColor
        view.layer.borderWidth = 1
        return view
    }()

    let linkLabel: UILabel = {
       let label = UILabel()
        label.text = "add_sns_link".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    let snsLabel: UILabel = {
       let label = UILabel()
        label.text = "add_sns_platform".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "add_sns_link_hint".localized
        tf.font = UIFont(name: "Pretendard-Regular", size: 14)
        tf.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 4
        tf.leftPadding()
        return tf
    }()

    let selectButton: UIButton = {
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
    private var viewModel = InfluenceViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setTitleLabel()

        view.addSubview(viewLayer)
        viewLayer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        setupUI()

    }

    private func setupUI() {
        let snsTags = Globals.shared.sns

        let snsButtons = createCategoryView(tags: snsTags)
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        view.addSubview(selectButton)
        view.addSubview(snsLabel)
        view.addSubview(snsButtons)
        view.addSubview(linkLabel)
        view.addSubview(textField)

        snsLabel.snp.makeConstraints {
            $0.top.equalTo(viewLayer.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        snsButtons.snp.makeConstraints {
            $0.top.equalTo(snsLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        linkLabel.snp.makeConstraints {
            $0.top.equalTo(snsButtons.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        textField.snp.makeConstraints {
            $0.top.equalTo(linkLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
        }

        selectButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
        }
    }

    private func setTitleLabel() {
        titleLabel.text = "add_sns_title".localized
        titleLabel.font = UIFont(name: "Pretendard-Medium", size: 14)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    // 이 함수는 태그 이름의 배열을 받아서 수평 스택뷰를 생성하고 반환합니다.
    private func createCategoryView(tags: [String]) -> UIView {
        let containerView = UIView()
        let maxWidth = UIScreen.main.bounds.width - 40
        var currentRowView = UIView()
        var currentRowWidth: CGFloat = 0
        var rowIndex = 0

        for tagName in tags {
            let tagButton = UIButton()
            tagButton.setTitle(tagName, for: .normal)
            tagButton.backgroundColor = .white
            tagButton.setTitleColor(UIColor(hex: "#4E505B"), for: .normal)
            tagButton.addTarget(self, action: #selector(snsButtonTapped), for: .touchUpInside)
            tagButton.isUserInteractionEnabled = true
            tagButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
            tagButton.layer.cornerRadius = 16
            tagButton.layer.borderWidth = 1
            tagButton.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
            tagButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 5, bottom: 6, right: 5)

            snsButtons.append(tagButton)

            // Calculate button size
            tagButton.sizeToFit()
            let buttonWidth = tagButton.frame.width + tagButton.contentEdgeInsets.left + tagButton.contentEdgeInsets.right
            if currentRowWidth + buttonWidth + 8 > maxWidth {
                // Add the current row view to the container view
                containerView.addSubview(currentRowView)
                currentRowView.snp.makeConstraints { make in
                    make.top.equalTo(containerView).offset(rowIndex * (Int(32) + 8))
                    make.left.equalTo(containerView)
                    make.right.lessThanOrEqualTo(containerView)
                    make.height.equalTo(32)
                }

                // Start a new row
                currentRowView = UIView()
                currentRowWidth = 0
                rowIndex += 1
            }

            // Add the button to the current row view
            currentRowView.addSubview(tagButton)
            tagButton.snp.makeConstraints { make in
                make.left.equalTo(currentRowView).offset(currentRowWidth)
                make.centerY.equalTo(currentRowView)
                make.width.equalTo(buttonWidth)
                make.height.equalTo(32)
            }

            currentRowWidth += buttonWidth + 8
        }

        if !currentRowView.subviews.isEmpty {
            containerView.addSubview(currentRowView)
            currentRowView.snp.makeConstraints { make in
                make.top.equalTo(containerView).offset(rowIndex * 40)
                make.left.equalTo(containerView)
                make.right.lessThanOrEqualTo(containerView)
                make.height.equalTo(32)
                make.bottom.equalToSuperview().offset(-8) // 마지막 줄일 경우
            }
        }

        return containerView
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

        var type = 0
        switch selectedSns {
        case "TikTok".localized: type = 0
        case "Instagram".localized: type = 1
        case "Facebook".localized: type = 2
        case "Naver".localized: type = 3
        case "Youtube".localized: type = 4
        default: type = 0
        }

        let sns = Sns(sns: type, link: textField.text ?? "")
        delegate?.didTapButton(self, getSns: sns)
        dismiss(animated: true)
    }

    private func validateForm() -> Bool {
        // 각 필드의 유효성 검사
        if selectedSns.isEmpty {
            showAlert(message: "add_sns_message1".localized)
            return false
        }
        if textField.text?.isEmpty ?? true {
            showAlert(message: "add_sns_message2".localized)
            return false
        }
        if !isValidURL(textField.text ?? "") {
            showAlert(message: "add_sns_message3".localized)
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
}

protocol AddSnsVCDelegate: AnyObject {
    func didTapButton(_ snsVC: AddSnsVC, getSns: Sns)
}
