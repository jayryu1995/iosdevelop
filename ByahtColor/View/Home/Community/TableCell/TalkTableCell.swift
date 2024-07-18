//
//  TalkTC.swift
//  ByahtColor
//
//  Created by jaem on 6/11/24.
//

import Foundation
import SnapKit
import UIKit

class TalkTableCell: UITableViewCell, UIScrollViewDelegate {
    private let nicknameLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        label.textColor = UIColor(hex: "#B5B8C2")
        return label
    }()

    private let dateLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        label.textColor = UIColor(hex: "#B5B8C2")
        return label
    }()

    private let titleLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.numberOfLines = 1
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor(hex: "#4E505B")
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.baselineAdjustment = .none
        return label
    }()

    private let likeIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "like_icon"))
        icon.contentMode = .scaleAspectFit
        return icon
    }()

    private let likeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#4E505B")
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        return label
    }()

    private let commentIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "icon_comment"))
        icon.contentMode = .scaleAspectFit
        return icon
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#4E505B")
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        return label
    }()

    private let bottomLayer: UIView = {
        let layer = UIView()
        layer.backgroundColor = UIColor(hex: "#F7F7F7")
        return layer
    }()

    private let image = UIImageView()
    private let iconPin: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "icon_pin2"))
        icon.contentMode = .scaleAspectFit
        return icon
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()  // 뷰가 자신의 크기를 다시 계산하도록 함
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }

    private func setupViews() {
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(likeIcon)
        contentView.addSubview(likeLabel)
        contentView.addSubview(commentIcon)
        contentView.addSubview(commentLabel)
        contentView.addSubview(bottomLayer)
        contentView.addSubview(image)
        contentView.addSubview(iconPin)

        iconPin.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(20)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(20)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
        }

        likeIcon.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(5)
            $0.width.height.equalTo(12)
            $0.leading.equalToSuperview()
        }

        likeLabel.snp.makeConstraints {
            $0.centerY.equalTo(likeIcon.snp.centerY)
            $0.height.equalTo(14)
            $0.leading.equalTo(likeIcon.snp.trailing).offset(4)
        }

        commentIcon.snp.makeConstraints {
            $0.top.bottom.equalTo(likeIcon)
            $0.width.height.equalTo(12)
            $0.leading.equalTo(likeLabel.snp.trailing).offset(4)
        }

        commentLabel.snp.makeConstraints {
            $0.centerY.equalTo(likeIcon.snp.centerY)
            $0.height.equalTo(14)
            $0.leading.equalTo(commentIcon.snp.trailing).offset(4)
        }

        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(likeIcon.snp.centerY)
            $0.height.equalTo(14)
            $0.leading.equalTo(commentLabel.snp.trailing).offset(4)
        }

        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(likeIcon.snp.centerY)
            $0.height.equalTo(14)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(4)
            $0.bottom.equalToSuperview().inset(16)
        }

        let imageSideLength = (UIScreen.main.bounds.width - 40) / 4
        image.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(nicknameLabel.snp.bottom)
            $0.width.height.equalTo(imageSideLength)
        }

        bottomLayer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    // 데이터 입력
    func configure(with talk: Talk) {
        titleLabel.text = talk.title ?? ""
        contentLabel.text = talk.content ?? ""
        nicknameLabel.text = talk.nickname ?? ""
        likeLabel.text = "\(talk.like_count ?? 0)"
        commentLabel.text = "\(talk.comment_count ?? 0)"

        let date = CustomFunction().formatDate(talk.regi_date ?? "")
        dateLabel.text = "| \(date) |"

        removeImage()
        updateNotification(notification: talk.notification)
    }

    func setImage(imagePath: String) {
        image.isHidden = false
        image.contentMode = .scaleAspectFill
        let url = "\(Bundle.main.TEST_URL)/board\(imagePath)"
        image.loadImage(from: url, resizedToWidth: 480)
        print(url)
        titleLabel.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview()
            $0.height.equalTo(20)
            $0.trailing.equalTo(image.snp.leading).offset(-10)
        }

        contentLabel.snp.remakeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(image.snp.leading).offset(-10)
        }
    }

    private func updateNotification(notification: Bool) {
        iconPin.isHidden = !notification
        if notification {
            titleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(16)
                $0.leading.equalTo(iconPin.snp.trailing)
                $0.height.equalTo(20)
            }
        } else {
            titleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(16)
                $0.leading.equalToSuperview()
                $0.height.equalTo(20)
            }
        }
    }

    // 이미지뷰 제거 함수
    private func removeImage() {
        image.isHidden = true
        titleLabel.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(20)
        }

        contentLabel.snp.remakeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
