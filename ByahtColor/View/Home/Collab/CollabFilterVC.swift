//
//  SnapFilterVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/22.
//

import UIKit
import SnapKit
import Alamofire
class CollabFilterVC: UIViewController {
    weak var delegate: CollabFilterVCDelegate?
    let titleLabel = UILabel()
    private let viewLayer: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(hex: "#F7F7F7").cgColor
        view.layer.borderWidth = 1
        return view
    }()

    let containLabel: UILabel = {
       let label = UILabel()
        label.text = "business_profile_subtitle1".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    let containLabel2: UILabel = {
       let label = UILabel()
        label.text = "add_sns_platform".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    let selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("collabVC_filter_update".localized, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.backgroundColor = UIColor.black
        button.setImage(UIImage(named: "icon_search"), for: .normal)
        button.layer.cornerRadius = 4
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()

    private var styleFilterViewContainer = UIView()
    private var snsFilterViewContainer = UIView()

    // 선택된 버튼들을 저장할 배열
    private var selectedButtons = [String]()
    private var selectedSns = [String]()

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

        setFilterView()
        setSelectButton()
    }

    private func setSelectButton() {
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        view.addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-48)
        }
    }

    private func setFilterView() {
        let styleTags = ["Beauty", "Fashion", "Travel", "Etc"]
        styleFilterViewContainer = createCategoryView(titles: styleTags, type: 0)
        view.addSubview(styleFilterViewContainer)
        view.addSubview(containLabel)

        containLabel.snp.makeConstraints {
            $0.top.equalTo(viewLayer.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }

        styleFilterViewContainer.snp.makeConstraints {
            $0.top.equalTo(containLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        let snsTags = ["TikTok".localized, "Instagram".localized, "Facebook".localized, "Shopee".localized, "Naver".localized, "Youtube".localized]
        snsFilterViewContainer = createCategoryView(titles: snsTags, type: 1)
        view.addSubview(containLabel2)
        view.addSubview(snsFilterViewContainer)

        containLabel2.snp.makeConstraints {
            $0.top.equalTo(styleFilterViewContainer.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }

        snsFilterViewContainer.snp.makeConstraints {
            $0.top.equalTo(containLabel2.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            // $0.bottom.equalToSuperview()
        }
    }

    private func createCategoryView(titles: [String], type: Int) -> UIView {
        let view = UIView()
        let maxWidth = UIScreen.main.bounds.width - 40
        var currentRowView = UIView()
        var currentRowWidth: CGFloat = 0
        var rowIndex = 0
        for (index, title) in titles.enumerated() {
            let button = UIButton()
            button.setTitleColor(UIColor(hex: "#4E505B"), for: .normal)
            button.backgroundColor = .white
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
            button.layer.cornerRadius = 16
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
            button.titleEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.5
            button.titleLabel?.lineBreakMode = .byTruncatingTail
            button.tag = index

            if type == 0 {
                button.addTarget(self, action: #selector(tagButtonTapped), for: .touchUpInside)
            } else if type == 1 {
                button.addTarget(self, action: #selector(snsButtonTapped), for: .touchUpInside)
            }

            let buttonWidth: CGFloat = max(48, (title as NSString).size(withAttributes: [.font: UIFont(name: "Pretendard-Regular", size: 14)!]).width + 16) // 16 for padding

            if currentRowWidth + buttonWidth + 4 > maxWidth { // 4 for spacing
                view.addSubview(currentRowView)

                currentRowView.snp.makeConstraints { make in
                    make.top.equalTo(view).offset(rowIndex * 36) // Adjust the top offset for each row
                    make.left.equalTo(view)
                    make.right.equalTo(view)
                    make.height.equalTo(36)

                }

                currentRowView = UIView()
                currentRowWidth = 0
                rowIndex += 1
            }

            currentRowView.addSubview(button)
            button.snp.makeConstraints { make in
                make.left.equalTo(currentRowView).offset(currentRowWidth)
                make.centerY.equalTo(currentRowView)
                make.width.equalTo(buttonWidth)
                make.height.equalTo(32)
            }

            currentRowWidth += buttonWidth + 4
        }

        if !currentRowView.subviews.isEmpty {
            view.addSubview(currentRowView)
            currentRowView.snp.makeConstraints { make in
                make.top.equalTo(view).offset(rowIndex * 36) // Adjust the top offset for each row
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.height.equalTo(36)
                make.bottom.equalToSuperview()
            }
        }

        return view
    }

    private func setTitleLabel() {
        titleLabel.text = "Filter"
        titleLabel.font = UIFont(name: "Pretendard-Medium", size: 17)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(27)
        }
    }

    @objc func tagButtonTapped(_ sender: UIButton) {
        let filter = sender.titleLabel?.text ?? ""
        if sender.isSelected {
            // 버튼이 이미 선택된 상태라면, 선택 해제
            sender.isSelected = false
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            if let index = selectedButtons.firstIndex(of: filter) {
                selectedButtons.remove(at: index)
            }
        } else {
            // 버튼이 선택되지 않은 상태라면
            if selectedButtons.count < 2 {
                // 선택된 버튼이 두 개 미만인 경우에만 선택
                sender.isSelected = true
                sender.backgroundColor = .black
                sender.setTitleColor(.white, for: .normal)
                selectedButtons.append(filter)
            }
        }
    }

    @objc func snsButtonTapped(_ sender: UIButton) {
        let filter = sender.titleLabel?.text ?? ""
        if sender.isSelected {
            // 버튼이 이미 선택된 상태라면, 선택 해제
            sender.isSelected = false
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            if let index = selectedSns.firstIndex(of: filter) {
                selectedSns.remove(at: index)
            }
        } else {

            // 선택된 버튼이 두 개 미만인 경우에만 선택
            sender.isSelected = true
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            selectedSns.append(filter)

        }
    }

    @objc private func selectButtonTapped() {
        delegate?.didTapButton(self, WithArray: selectedButtons, WithArray2: selectedSns)
        dismiss(animated: true)
    }
}

protocol CollabFilterVCDelegate: AnyObject {
    func didTapButton(_ snapVC: CollabFilterVC, WithArray array: [String], WithArray2 array2: [String])
}
