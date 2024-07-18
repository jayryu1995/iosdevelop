//
//  BusinessProfileHeaderCell.swift
//  ByahtColor
//
//  Created by jaem on 7/10/24.
//

import Foundation
import UIKit
import SnapKit

class ProfileHeaderCell: UITableViewCell {
    private let image: GradientImageView = {
        let iv = GradientImageView(frame: .zero)
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor(hex: "#E5E6EA").cgColor
        iv.layer.cornerRadius = 8
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Bold", size: 24)
        return label
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Bold", size: 14)
        label.numberOfLines = 2
        return label
    }()

    private let viewModel = BusinessViewModel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(image)
        image.addSubview(nameLabel)
        image.addSubview(infoLabel)

    }

    private func setupConstraints() {
        image.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
            $0.height.equalTo(image.snp.width).multipliedBy(350.0 / 350.0)
        }

        infoLabel.snp.makeConstraints {
            $0.bottom.equalTo(image.snp.bottom).offset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        nameLabel.snp.makeConstraints {
            $0.bottom.equalTo(infoLabel.snp.top).offset(-8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    func configure(with profile: BusinessDetailDto) {
        nameLabel.text = profile.business_name
        infoLabel.text = profile.intro
        if let imagePath = profile.imagePath {
            let url = "\(Bundle.main.TEST_URL)/business\(imagePath)"
            image.loadImage2(from: url)
        } else {
            image.image = nil
        }
    }

}
