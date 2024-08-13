//
//  InfluenceFilterVC.swift
//  ByahtColor
//
//  Created by jaem on 8/2/24.
//

import UIKit
import SnapKit

class InfluenceFilterVC: UIViewController {
    weak var delegate: InfluenceFilterVCDelegate?

    let titleLabel = UILabel()

    private let containLabel: UILabel = {
       let label = UILabel()
        label.text = "add_sns_platform".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let containLabel2: UILabel = {
       let label = UILabel()
        label.text = "influence_profile_write_category".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let containLabel3: UILabel = {
       let label = UILabel()
        label.text = "influence_profile_write_nation".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("collabVC_filter_update".localized, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.backgroundColor = UIColor.black
        button.setImage(UIImage(named: "icon_search"), for: .normal)
        button.layer.cornerRadius = 4
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()

    // 선택된 버튼들을 저장할 배열
    private var categoryButtons: [UIButton] = []
    private var ageButtons: [UIButton] = []
    private var genderButtons: [UIButton] = []
    private var nationButtons: [UIButton] = []
    private var categoryView = UIView()
    private var snsView = UIView()
    private var nationView = UIView()
    private let containerView = UIView()
    private var selectedCategory: [String] = []
    private var selectedSns: [String] = []
    private var selectedNation: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupUI()
        setupConstraints()

    }

    private func setupUI() {
        setTitleLabel()

        view.addSubview(containerView)

        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        view.addSubview(selectButton)
        setFilterView()
    }

    private func setFilterView() {
        containerView.addSubview(containLabel)
        containerView.addSubview(containLabel2)
        containerView.addSubview(containLabel3)
        snsView = createCategoryView(titles: Globals.shared.sns, type: 0)
        categoryView = createCategoryView(titles: Globals.shared.categories, type: 1)

        let nations = [ "nation_ko".localized,
                        "nation_vi".localized,
                        "categories_etc".localized]
        nationView = createCategoryView(titles: nations, type: 2)
        containerView.addSubview(snsView)
        containerView.addSubview(categoryView)
        containerView.addSubview(nationView)

    }

    private func setupConstraints() {

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        containLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        snsView.snp.makeConstraints {
            $0.top.equalTo(containLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }

        containLabel2.snp.makeConstraints {
            $0.top.equalTo(snsView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }

        categoryView.snp.makeConstraints {
            $0.top.equalTo(containLabel2.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }

        containLabel3.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }

        nationView.snp.makeConstraints {
            $0.top.equalTo(containLabel3.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        selectButton.snp.makeConstraints {

            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-48)
        }
    }

    private func setTitleLabel() {
        titleLabel.text = "Filter"
        titleLabel.font = UIFont(name: "Pretendard-Medium", size: 17)
        view.addSubview(titleLabel)

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
                button.addTarget(self, action: #selector(snsButtonTapped), for: .touchUpInside)
                categoryButtons.append(button)
            } else if type == 1 {
                button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
                ageButtons.append(button)
            } else if type == 2 {
                button.addTarget(self, action: #selector(nationButtonTapped), for: .touchUpInside)
                genderButtons.append(button)
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

    @objc private func categoryButtonTapped(_ sender: UIButton) {
        let selector = sender.tag.toString()

        if sender.isSelected {
            // 버튼이 이미 선택된 상태라면, 선택 해제
            sender.isSelected = false
            sender.backgroundColor = .white
            sender.setTitleColor(UIColor(hex: "#4E505B"), for: .normal)
            if let index = selectedCategory.firstIndex(of: selector) {
                selectedCategory.remove(at: index)
            }
        } else {
            // 선택된 버튼이 두 개 미만인 경우에만 선택
            sender.isSelected = true
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            selectedCategory.append(selector)
        }
    }

    @objc private func snsButtonTapped(_ sender: UIButton) {
        let selector = sender.tag.toString()

        if sender.isSelected {
            // 버튼이 이미 선택된 상태라면, 선택 해제
            sender.isSelected = false
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            if let index = selectedSns.firstIndex(of: selector) {
                selectedSns.remove(at: index)
            }
        } else {
            // 선택된 버튼이 두 개 미만인 경우에만 선택
            sender.isSelected = true
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            selectedSns.append(selector)
        }
    }

    @objc private func nationButtonTapped(_ sender: UIButton) {
        let selector = sender.tag.toString()

        if sender.isSelected {
            // 버튼이 이미 선택된 상태라면, 선택 해제
            sender.isSelected = false
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            if let index = selectedNation.firstIndex(of: selector) {
                selectedNation.remove(at: index)
            }
        } else {
            // 선택된 버튼이 두 개 미만인 경우에만 선택
            sender.isSelected = true
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            selectedNation.append(selector)
        }
    }

    @objc private func selectButtonTapped() {
        delegate?.didTapButton(SnsArray: selectedSns, CategoryArray2: selectedCategory, NationArray3: selectedNation)
        dismiss(animated: true)
    }
}

protocol InfluenceFilterVCDelegate: AnyObject {
    func didTapButton(SnsArray array: [String], CategoryArray2 array2: [String], NationArray3 array3: [String])
}
