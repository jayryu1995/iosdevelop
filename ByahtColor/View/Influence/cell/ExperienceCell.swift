//
//  InfluenceExperienceCell.swift
//  ByahtColor
//
//  Created by jaem on 7/11/24.
//

import Foundation
import UIKit
import SnapKit

class ExperienceCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F4F5F8")
        view.layer.cornerRadius = 8
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "influence_profile_subtitle1".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        return stackView
    }()

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
        containerView.addSubview(titleLabel)
        containerView.addSubview(stackView)

    }

    private func setupConstraints() {

        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }

    func configure(with experiences: [Experience]) {
        // 기존 스택뷰의 모든 서브뷰를 제거
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // 반복문을 통해 각 경험 항목을 스택뷰에 추가

        for experience in experiences {
            let experienceView = createExperienceView(for: experience)
            stackView.addArrangedSubview(experienceView)
        }
    }

    private func createExperienceView(for experience: Experience) -> UIView {
        let view = UIView()

        let iconImageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            switch experience.sns {
            case 0:
                iv.image = UIImage(named: "tiktok")
            case 1:
                iv.image = UIImage(named: "instagram")
            case 2:
                iv.image = UIImage(named: "facebook")
            default:
                iv.image = UIImage(named: "naver")
            }
            return iv
        }()

        let contentLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "Pretendard-Medium", size: 16)
            label.text = experience.contents
            return label
        }()

        let businessLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "Pretendard-Regular", size: 12)
            label.textColor = UIColor(hex: "#4E505B")
            label.text = experience.business
            return label
        }()

        view.addSubview(iconImageView)
        view.addSubview(contentLabel)
        view.addSubview(businessLabel)

        iconImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(20)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8)
        }

        businessLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }

        return view
    }
}
