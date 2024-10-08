//
//  InfluenceReportVC.swift
//  ByahtColor
//
//  Created by jaem on 7/4/24.
//

import Foundation
import UIKit
import SnapKit

class InfluenceReportVC: UIViewController {
    private let imageView: GradientImageView = {
        let iv = GradientImageView(frame: .zero)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor(hex: "#E5E6EA").cgColor
        iv.isUserInteractionEnabled = true
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Bold", size: 24)
        return label
    }()

    private let icon_facebook: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "facebook"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let icon_instagram: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "instagram"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let icon_tiktok: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "tiktok"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let icon_naver: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "naver"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let icon_yotube: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "youtube"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Bold", size: 14)
        label.numberOfLines = 2

        return label
    }()

    private let targetLabel: UILabel = {
        let label = UILabel()
        label.text = "business_profile_target".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.textColor = .black
        return label
    }()

    private let payLabel: UILabel = {
        let label = UILabel()
        label.text = "business_profile_pay".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.textColor = .black
        return label
    }()

    private let reportView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F4F5F8")
        view.layer.cornerRadius = 8
        return view
    }()

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let iconView = UIStackView()
    private var targetView = UIView()
    private let viewModel = BusinessViewModel()
    private var genderView = UIView()
    private var categoryView = UIView()
    private var ageView = UIView()
    private var payStackView = UIStackView()
    private var payArray: [Pay] = []
    private var selectedGender: [String] = []
    private var selectedCategory: [String] = []
    private var selectedAge: [String] = []
    var businessId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false

        setupProfile()
        setupBackButton()

    }

    private func setupProfile() {
        if let id = businessId {
            viewModel.getBusinessProfile(id: id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        print("data.businessName : \(data.business_name)")
                        self?.navigationItem.title = "Brands"
                        self?.nameLabel.text = data.business_name ?? ""
                        self?.payArray = data.payDtos ?? []
                        self?.infoLabel.text = "\(data.intro ?? "")"
                        self?.selectedGender = data.gender?.components(separatedBy: ",") ?? []
                        self?.selectedAge = data.age?.components(separatedBy: ",") ?? []
                        self?.selectedCategory = data.category?.components(separatedBy: ",") ?? []

                        let path = "\(Bundle.main.TEST_URL)/business\( data.imagePath ?? "" )"
                        print("path : \(path)")
                        self?.loadImageFromURL(path) { [weak self] image in
                            DispatchQueue.main.async {
                                if let image = image {
                                    self?.imageView.image = image
                                }
                            }
                        }
                        self?.setupUI()
                        self?.setupConstraints()

                    case .failure(let error):
                        print("통신 에러 : \(error)")
                        self?.setupUI()
                        self?.setupConstraints()
                    }
                }
            }
        }
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.showsHorizontalScrollIndicator = false
        setupTempletView()
        setupReportView()
    }

    private func setupReportView() {
        contentView.addSubview(reportView)
        reportView.addSubview(targetLabel)
        reportView.addSubview(payLabel)
        payStackView = makePayStackView(index: payArray)
        makeTargetStackView()
        reportView.addSubview(payStackView)
        reportView.addSubview(targetView)

    }

    private func setupTempletView() {
        contentView.addSubview(imageView)
        imageView.addSubview(nameLabel)
        imageView.addSubview(infoLabel)
        iconView.axis = .horizontal
        iconView.distribution = .equalSpacing
        iconView.spacing = 8
        iconView.isHidden = true
        iconView.addArrangedSubview(icon_instagram)
        iconView.addArrangedSubview(icon_facebook)
        iconView.addArrangedSubview(icon_tiktok)
        iconView.addArrangedSubview(icon_naver)
        iconView.addArrangedSubview(icon_yotube)
        imageView.addSubview(iconView)
        icon_instagram.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }

        icon_tiktok.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }

        icon_facebook.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }

        icon_naver.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }

        icon_naver.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.greaterThanOrEqualTo(scrollView).priority(.low)
        }

        // Templet
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(imageView.snp.width).multipliedBy(350.0 / 350.0)
        }

        iconView.snp.makeConstraints {
            $0.bottom.equalTo(infoLabel.snp.top).offset(-8)
            $0.leading.equalToSuperview().offset(20)
        }

        nameLabel.snp.makeConstraints {
            $0.bottom.equalTo(iconView.snp.top).offset(-8)
            $0.leading.equalToSuperview().offset(20)
        }

        infoLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }

        // 보고서
        reportView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }

        payLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }

        payStackView.snp.makeConstraints {
            $0.top.equalTo(payLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        targetLabel.snp.makeConstraints {
            $0.top.equalTo(payStackView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }

        targetView.snp.makeConstraints {
            $0.top.equalTo(targetLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }

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

        categoryView = createCategoryView(titles: Globals.shared.categories, selected: selectedCategory)
        ageView = createCategoryView(titles: Globals.shared.ages, selected: selectedAge)
        genderView = createCategoryView(titles: Globals.shared.genders, selected: selectedGender)

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

    private func makePayStackView(index: [Pay]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .equalSpacing

        index.forEach { i in
            let view = UIView()
            stackView.addArrangedSubview(view)
            view.snp.makeConstraints {
                $0.height.equalTo(42)
            }
            var icon: UIImageView
            if i.sns == 0 {
                icon = UIImageView(image: UIImage(named: "tiktok"))
            } else if i.sns == 1 {
                icon = UIImageView(image: UIImage(named: "instagram"))
            } else if i.sns == 2 {
                icon = UIImageView(image: UIImage(named: "facebook"))
            } else if i.sns == 3 {
                icon = UIImageView(image: UIImage(named: "naver"))
            } else {
                icon = UIImageView(image: UIImage(named: "youtube"))
            }

            let lbl = UILabel()
            lbl.text = i.cash ?? ""
            lbl.font = UIFont(name: "Pretendard-Medium", size: 16)

            var type = ""
            if i.type == 1 {
                type = "influence_profile_photo".localized
            } else {
                type = "influence_profile_video".localized
            }

            let lbl2 = UILabel()
            lbl2.text = "\(i.negotiable! ? "influence_profile_negotiable".localized : "influence_profile_non_negotiable".localized) | \(type)"
            lbl2.font = UIFont(name: "Pretendard-Regular", size: 12)
            lbl2.textColor = UIColor(hex: "#4E505B")

            view.addSubview(icon)
            view.addSubview(lbl)
            view.addSubview(lbl2)

            icon.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
                $0.width.height.equalTo(20)
            }

            lbl.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalTo(icon.snp.trailing).offset(4)
            }

            lbl2.snp.makeConstraints {
                $0.top.equalTo(icon.snp.bottom).offset(4)
                $0.leading.equalToSuperview()
            }
        }

        return stackView
    }

    @objc private func buttonTapped() {
        let vc = BusinessProfileWriteVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
