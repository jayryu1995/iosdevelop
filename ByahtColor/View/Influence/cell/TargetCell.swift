//
//  TargetCell.swift
//  ByahtColor
//
//  Created by jaem on 7/11/24.
//

import SnapKit
import UIKit

class TargetCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F4F5F8")
        return view
    }()

    private let targetLabel: UILabel = {
        let label = UILabel()
        label.text = "business_profile_target".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.textColor = .black
        return label
    }()
    private let targetView = UIView()
    private var genderView = UIView()
    private var categoryView = UIView()
    private var ageView = UIView()
    private var selectedGender: [String] = []
    private var selectedCategory: [String] = []
    private var selectedAge: [String] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(targetLabel)
        containerView.addSubview(targetView)

    }

    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        targetLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }

        targetView.snp.makeConstraints {
            $0.top.equalTo(targetLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }

    func configure(with data: [String]) {
        // 카테고리 나이 성별 순
        if data.isEmpty == false {
            self.selectedCategory = data[0].components(separatedBy: ",")
            self.selectedAge = data[1].components(separatedBy: ",")
            self.selectedGender = data[2].components(separatedBy: ",")
        }

        makeTargetStackView()
    }

    func addBottomRadius() {
        containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        containerView.layer.cornerRadius = 8
    }

    private func makeTargetStackView() {

            let label = UILabel()
            label.text = "influence_profile_target".localized
            label.font = UIFont(name: "Pretendard-Medium", size: 16)

            let label2 = UILabel()
            label2.text = "influence_profile_target2".localized
            label2.font = UIFont(name: "Pretendard-Medium", size: 16)

            let label3 = UILabel()
            label3.text = "influence_profile_target3".localized
            label3.font = UIFont(name: "Pretendard-Medium", size: 16)

            let categories = ["categories_beauty".localized, "categories_fasion".localized, "categories_daily".localized, "categories_travel".localized, "categories_baby".localized, "categories_food".localized, "categories_etc".localized]
            let ages = ["ages_10".localized, "ages_20".localized, "ages_30".localized, "ages_40".localized, "ages_50".localized]
            let genders = ["gender_male".localized, "gender_female".localized]
            categoryView = createCategoryView(titles: categories, selected: selectedCategory)
            ageView = createCategoryView(titles: ages, selected: selectedAge)
            genderView = createCategoryView(titles: genders, selected: selectedGender)

            targetView.addSubview(label)
            targetView.addSubview(label2)
            targetView.addSubview(label3)
            targetView.addSubview(categoryView)
            targetView.addSubview(ageView)
            targetView.addSubview(genderView)

            label.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.height.equalTo(24)
            }

            categoryView.snp.makeConstraints {
                $0.top.equalTo(label.snp.bottom).offset(8)
                $0.leading.trailing.equalToSuperview()
            }

            label2.snp.makeConstraints {
                $0.top.equalTo(categoryView.snp.bottom).offset(16)
                $0.leading.equalToSuperview()
                $0.height.equalTo(24)
            }

            ageView.snp.makeConstraints {
                $0.top.equalTo(label2.snp.bottom).offset(8)
                $0.leading.trailing.equalToSuperview()
            }

            label3.snp.makeConstraints {
                $0.top.equalTo(ageView.snp.bottom).offset(16)
                $0.leading.equalToSuperview()
                $0.height.equalTo(24)
            }

            genderView.snp.makeConstraints {
                $0.top.equalTo(label3.snp.bottom).offset(8)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }

    private func createCategoryView(titles: [String], selected: [String]) -> UIView {
            let view = UIView()
            let maxWidth = UIScreen.main.bounds.width - 80
            var currentRowView = UIView()
            var currentRowWidth: CGFloat = 0
            var rowIndex = 0
            for (index, title) in titles.enumerated() {

                let button = UIButton()
                if selected.contains(index.toString()) {
                    button.setTitleColor(.white, for: .normal)
                    button.backgroundColor = .black
                } else {
                    button.setTitleColor(UIColor(hex: "#4E505B"), for: .normal)
                    button.backgroundColor = .white
                }
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
                button.layer.cornerRadius = 16
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
                button.titleEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
                button.titleLabel?.adjustsFontSizeToFitWidth = true
                button.titleLabel?.minimumScaleFactor = 0.5
                button.titleLabel?.lineBreakMode = .byTruncatingTail

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
}
