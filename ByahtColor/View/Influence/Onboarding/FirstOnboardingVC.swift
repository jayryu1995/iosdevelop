//
//  FirstOnboarding.swift
//  ByahtColor
//
//  Created by jaem on 7/30/24.
//

import UIKit
import SnapKit

class FirstOnboarding: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "example_image")
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "Welcome to the app!"
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        addSubview(imageView)
        addSubview(label)
    }

    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.width.equalTo(224)
            make.height.equalTo(imageView.snp.width).multipliedBy(484.0 / 224.0)
            make.bottom.equalToSuperview().offset(20)
        }
    }
}

