//
//  BusinessFirstOnboardingVC.swift
//  ByahtColor
//
//  Created by jaem on 9/9/24.
//

import UIKit
import SnapKit

class BusinessFirstOnboardingVC: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "image_onboarding")
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "business_onboarding_first_label".localized
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let label2: UILabel = {
        let label = UILabel()
        label.text = "business_onboarding_first_label2".localized
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(label2)
    }

    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(33)
            make.height.equalTo(21)
        }

        label2.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(62)
        }
        
        let imageWidth = 224
        let imageHeight = 484
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-77)
            make.top.equalTo(label2.snp.bottom).offset(38)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.9)
            make.height.equalTo(imageView.snp.width).multipliedBy(CGFloat(imageHeight) / CGFloat(imageWidth))
        }

    }
}
