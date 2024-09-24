//
//  BusinessSecondOnboardingVC.swift
//  ByahtColor
//
//  Created by jaem on 9/9/24.
//

import Foundation
import UIKit
import SnapKit
import FLAnimatedImage

class BusinessSecondOnboardingVC: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "business_onboarding"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "business_onboarding_second_label".localized
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        label.textAlignment = .center
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
    }


    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(33)
        }

        imageView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(54)
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalToSuperview()
        }
    }
}
