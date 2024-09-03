//
//  AddPayVC.swift
//  ByahtColor
//
//  Created by jaem on 6/24/24.
//

import Foundation
import UIKit
import SnapKit
import DropDown

class AddPayVC: UIViewController {
    weak var delegate: AddPayVCDelegate?
    private let titleLabel = UILabel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let viewLayer: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(hex: "#F7F7F7").cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let snsLabel: UILabel = {
       let label = UILabel()
        label.text = "add_sns_platform".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let contentsLabel: UILabel = {
       let label = UILabel()
        label.text = "add_pay_contents".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let payLabel: UILabel = {
       let label = UILabel()
        label.text = "add_pay_hope".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let dropButton: UIButton = {
        let button = UIButton()
        button.setTitle("US ($)", for: .normal)
        button.setBackgroundColor(.white, for: .normal)
        button.setImage(UIImage(named: "arrow_down"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        button.setTitleColor(UIColor(hex: "#4E505B"), for: .normal)
        // Set content alignment
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        return button
    }()

    private let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "add_pay_hope_hint".localized
        tf.font = UIFont(name: "Pretendard-Regular", size: 14)
        tf.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 4
        tf.keyboardType = .numberPad
        tf.leftPadding()
        return tf
    }()

    private let checkIcon = UIImageView(image: UIImage(named: "icon_inactive"))

    private let negotiableLabel: UILabel = {
        let label = UILabel()
        label.text = "add_pay_negotiable".localized
        label.textColor = UIColor(hex: "#4E505B")
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
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
    private var contentsButtons: [UIButton] = []
    private var selectedSns: String = ""
    private var selectedContents: String = ""
    private let dropdown = DropDown()
    private var active = false
    private var currency = "$"

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
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setTitleLabel()
        setupScrollView()

        setupUI()
        setupDropdown()

    }

        private func setupScrollView() {
            view.addSubview(scrollView)
            view.addSubview(selectButton)
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

        private func setupDropdown() {
            dropdown.anchorView = dropButton
            dropdown.dataSource = ["US ($)", "VN (₫)", "KOR (₩)"]
            dropdown.bottomOffset = CGPoint(x: 0, y: 32)
            dropdown.direction = .bottom
            dropdown.selectionAction = { [unowned self] (_: Int, item: String) in
                self.dropButton.setTitle(item, for: .normal)
                if item == "US ($)" {
                    currency = "$"
                } else if item == "VN (₫)" {
                    currency = "₫"
                } else {
                    currency = "₩"
                }
            }
        }

        private func setupUI() {
            contentView.isUserInteractionEnabled = true
            let snsTags = Globals.shared.sns
            let contentsTags = ["add_pay_contents_media".localized, "add_pay_contents_photo".localized]

            let snsButtons = createSNSView(tags: snsTags)
            snsButtons.isUserInteractionEnabled = true

            let contentsButtons = createCategoryView(tags: contentsTags, type: 2)

            dropButton.addTarget(self, action: #selector(showDropdown), for: .touchUpInside)

            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(activeTapped))
            checkIcon.addGestureRecognizer(tapGestureRecognizer)
            checkIcon.isUserInteractionEnabled = true
            selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
            contentView.addSubview(snsLabel)
            contentView.addSubview(snsButtons)
            contentView.addSubview(contentsLabel)
            contentView.addSubview(contentsButtons)
            contentView.addSubview(businessLabel)
            contentView.addSubview(businessField)
            contentView.addSubview(payLabel)
            contentView.addSubview(dropButton)
            contentView.addSubview(textField)
            contentView.addSubview(checkIcon)
            contentView.addSubview(negotiableLabel)

            businessLabel.snp.makeConstraints {
                $0.top.equalTo(contentView.snp.top).offset(24)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(0)
            }

            snsLabel.snp.makeConstraints {
                $0.top.equalTo(contentView.snp.top).offset(24)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(24)
            }

            snsButtons.snp.makeConstraints {
                $0.top.equalTo(snsLabel.snp.bottom).offset(8)
                $0.leading.trailing.equalToSuperview().inset(20)
            }

            contentsLabel.snp.makeConstraints {
                $0.top.equalTo(snsButtons.snp.bottom).offset(16)
                $0.leading.equalToSuperview().inset(20)
                $0.height.equalTo(24)
            }

            contentsButtons.snp.makeConstraints {
                $0.top.equalTo(contentsLabel.snp.bottom).offset(8)
                $0.leading.trailing.equalToSuperview().inset(20)
            }

            payLabel.snp.makeConstraints {
                $0.top.equalTo(contentsButtons.snp.bottom).offset(16)
                $0.leading.equalToSuperview().inset(20)
                $0.height.equalTo(24)
            }

            dropButton.snp.makeConstraints {
                $0.top.equalTo(payLabel.snp.bottom).offset(8)
                $0.leading.equalToSuperview().inset(20)
                $0.height.equalTo(32)
                $0.width.equalTo(69)
            }

            textField.snp.makeConstraints {
                $0.top.bottom.equalTo(dropButton)
                $0.leading.equalTo(dropButton.snp.trailing).offset(8)
                $0.trailing.equalToSuperview().inset(20)
            }

            checkIcon.snp.makeConstraints {
                $0.top.equalTo(dropButton.snp.bottom).offset(8)
                $0.width.height.equalTo(20)
                $0.leading.equalToSuperview().offset(20)

            }

            negotiableLabel.snp.makeConstraints {
                $0.top.bottom.equalTo(checkIcon)
                $0.leading.equalTo(checkIcon.snp.trailing).offset(8)
                $0.bottom.equalToSuperview()
            }

            selectButton.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(60)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-48)
            }
        }

        @objc private func showDropdown() {
            dropdown.show()
        }

        @objc private func activeTapped() {
            active = !active
            if active {
                checkIcon.image = UIImage(named: "icon_active")
            } else {
                checkIcon.image = UIImage(named: "icon_inactive")
            }
        }

        private func setTitleLabel() {
            titleLabel.text = "add_pay_title".localized
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

        private func createSNSView(tags: [String]) -> UIView {
            let containerView = UIView()
            containerView.isUserInteractionEnabled = true
            let maxWidth = UIScreen.main.bounds.width - 40
            var currentRowView = UIView()
            currentRowView.isUserInteractionEnabled = true
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

        private func createCategoryView(tags: [String], type: Int) -> UIView {

            let containerView = UIView()
            containerView.isUserInteractionEnabled = true
            let maxWidth = UIScreen.main.bounds.width - 40
            var currentRowView = UIView()
            currentRowView.isUserInteractionEnabled = true
            var currentRowWidth: CGFloat = 0
            var rowIndex = 0

            for tagName in tags {
                let tagButton = UIButton()
                tagButton.setTitle(tagName, for: .normal)
                tagButton.backgroundColor = .white
                tagButton.setTitleColor(UIColor(hex: "#4E505B"), for: .normal)
                tagButton.isUserInteractionEnabled = true
                tagButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
                tagButton.layer.cornerRadius = 16
                tagButton.layer.borderWidth = 1
                tagButton.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
                tagButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 5, bottom: 6, right: 5)
                if type == 1 {
                    tagButton.addTarget(self, action: #selector(snsButtonTapped), for: .touchUpInside)
                    snsButtons.append(tagButton)
                } else {
                    tagButton.addTarget(self, action: #selector(contentsButtonTapped), for: .touchUpInside)
                    contentsButtons.append(tagButton)
                }

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

        @objc private func snsButtonTapped(_ sender: UIButton) {
            let filter = sender.titleLabel?.text ?? ""

            print("touch")
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
            selectedSns = filter.localized
        }

        @objc func contentsButtonTapped(_ sender: UIButton) {
            let filter = sender.titleLabel?.text ?? ""

            // 모든 버튼을 비활성화
            for button in contentsButtons {
                button.isSelected = false
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
            }

            // 현재 눌린 버튼만 활성화
            sender.isSelected = true
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)

            // 선택된 SNS 업데이트
            selectedContents = filter
        }

        @objc private func selectButtonTapped() {
            guard validateForm() else { return }

            var sns = 0
            switch selectedSns {
            case "TikTok".localized: sns = 0
            case "Instagram".localized: sns = 1
            case "Facebook".localized: sns = 2
            case "Naver".localized: sns = 3
            case "Youtube".localized: sns = 4
            default: sns = 0
            }

            let media = "add_pay_contents_media".localized
            let photo = "add_pay_contents_photo".localized
            var type = 0
            switch selectedContents {
            case media: type = 0
            case photo: type = 1
            default: type = 0
            }

            let cash = "\(textField.text?.formattedWithCommas() ?? "") \(currency)"
            let pay = Pay(sns: sns, cash: cash, type: type, currency: currency, negotiable: active)
            delegate?.didTapButton(self, getData: pay)
            dismiss(animated: true)
        }

        private func validateForm() -> Bool {
            // 각 필드의 유효성 검사
            if selectedSns.isEmpty {
                showAlert(message: "add_pay_message1".localized)
                return false
            }
            if selectedContents.isEmpty {
                showAlert(message: "add_pay_message2".localized)
                return false
            }
            if textField.text?.isEmpty ?? true {
                showAlert(message: "add_pay_message3".localized)
                return false
            }

            // 모든 유효성 검사를 통과하면 true를 반환
            return true
        }

        // 경고 메시지를 표시하는 함수
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

     }

protocol AddPayVCDelegate: AnyObject {
    func didTapButton(_ VC: AddPayVC, getData: Pay)
}
