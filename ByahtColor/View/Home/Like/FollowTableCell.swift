//
//  FollowTableCell.swift
//  ByahtColor
//
//  Created by jaem on 2024/02/02.
//

import UIKit
import SnapKit
import Alamofire
import AlamofireImage

class FollowTableCell: UITableViewCell {
    var onButtonTapped: (() -> Void)?
    private let profileIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_profile2"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nickname: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#535358")
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        return label
    }()

    private let profileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow_right"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 셀 레이아웃 설정
        backgroundColor = .white

        setupViews()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(profileIcon)
        contentView.addSubview(nickname)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(profileButton)

        profileIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(40)
        }

        nickname.snp.makeConstraints {
            $0.top.equalTo(profileIcon.snp.top)
            $0.leading.equalTo(profileIcon.snp.trailing).offset(10)
        }

        bodyLabel.snp.makeConstraints {
            $0.bottom.equalTo(profileIcon.snp.bottom).offset(10)
            $0.leading.equalTo(nickname.snp.leading)
        }

        profileButton.snp.makeConstraints {
            $0.centerY.equalTo(profileIcon.snp.centerY)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(40)
        }
    }

    func loadSnapData(user: UserDto) {
        print("user nickname : \(user.nickname)")
        nickname.text = user.nickname
        let height = user.height ?? 0
        let weight = user.weight ?? 0
        bodyLabel.text = "\(height)cm . \(weight)kg"
        let url = "\(Bundle.main.TEST_URL)/image\(user.image_path ?? "")"
        profileIcon.loadImage(from: url, resizedToWidth: 40)
        profileButton.addTarget(self, action: #selector(collectionCellTapped), for: .touchUpInside)
    }

    @objc private func collectionCellTapped(_ sender: UIButton) {

        onButtonTapped?()
    }

}
