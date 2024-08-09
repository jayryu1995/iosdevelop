//
//  PayCell.swift
//  ByahtColor
//
//  Created by jaem on 7/10/24.
//

import UIKit
import SnapKit
class PayCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F4F5F8")
        return view
    }()
    private let payLabel: UILabel = {
        let label = UILabel()
        label.text = "business_profile_pay".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.textColor = .black
        return label
    }()

    private var payStackView = UIStackView()

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
        containerView.addSubview(payLabel)
        containerView.addSubview(payStackView)

        payStackView.axis = .vertical
        payStackView.spacing = 16
        payStackView.distribution = .equalSpacing
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        payLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }

        payStackView.snp.makeConstraints {
            $0.top.equalTo(payLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }

    private func makePayStackView(index: [Pay]) -> [UIView] {
            var views: [UIView] = []

            index.forEach { i in
                let view = UIView()
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

                views.append(view)
            }

            return views
        }

    func configure(with payArray: [Pay]) {
        // 기존의 모든 서브뷰를 제거
        payStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // 새로운 서브뷰 추가
        let newViews = makePayStackView(index: payArray)
        newViews.forEach { payStackView.addArrangedSubview($0) }
    }

    func addTopRadius() {
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 상단 좌우 코너에만 반경을 적용
        containerView.layer.cornerRadius = 8

     //   self.layoutIfNeeded()
    }

}
