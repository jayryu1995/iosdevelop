import Foundation
import UIKit
import SendbirdChatSDK
import SnapKit

open class BasicMessageCell: UITableViewCell {

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_profile2"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var messageBox: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Pretendard-Regular", size: 14)
        tv.layer.cornerRadius = 16
        tv.isScrollEnabled = false
        tv.backgroundColor = UIColor(hex: "#009BF2")
        tv.clipsToBounds = true
        tv.isEditable = false
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return tv
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 10)
        label.textColor = UIColor(hex: "#B5B8C2")
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = UIColor(hex: "#B5B8C2")
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private lazy var icon: UIImageView = {
        let image = UIImageView(image: UIImage(named: "icon_chat_check1"))
        image.contentMode = .scaleAspectFit
        return image
    }()

    private var sender = ""

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(messageBox)
        contentView.addSubview(timeLabel)
        contentView.addSubview(icon)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.isHidden = false
        profileImageView.image = UIImage(named: "icon_profile2")
        messageBox.text = nil
        timeLabel.text = nil
        dateLabel.isHidden = true
        dateLabel.text = nil
        icon.image = nil

        icon.snp.removeConstraints()
        timeLabel.snp.removeConstraints()
        messageBox.snp.removeConstraints()
        profileImageView.snp.removeConstraints()

        sender = ""
    }

    open override func updateConstraints() {
        super.updateConstraints()

        let maxWidth = UIScreen.main.bounds.width * 0.6
        let me = User.shared.name

        if sender == me {
            profileImageView.isHidden = true
            messageBox.backgroundColor = UIColor(hex: "#009BF2")
            messageBox.textColor = .white

            dateLabel.snp.remakeConstraints {
                if dateLabel.isHidden {
                    $0.top.equalToSuperview()
                } else {
                    $0.top.equalToSuperview().offset(16)
                }
                $0.leading.trailing.equalToSuperview()
            }

            messageBox.snp.remakeConstraints {
                $0.trailing.equalToSuperview().offset(-20)
                $0.top.equalTo(dateLabel.snp.bottom).offset(16)
                $0.bottom.equalToSuperview()
                $0.width.lessThanOrEqualTo(maxWidth)
            }

            timeLabel.snp.remakeConstraints {
                $0.trailing.equalTo(messageBox.snp.leading).offset(-4)
                $0.bottom.equalTo(messageBox.snp.bottom)
            }

            icon.snp.remakeConstraints {
                $0.trailing.equalTo(timeLabel.snp.leading).offset(-4)
                $0.bottom.equalTo(messageBox.snp.bottom)
                $0.width.height.equalTo(16)
            }

        } else {
            profileImageView.isHidden = false
            profileImageView.image = UIImage(named: "icon_profile2")
            messageBox.backgroundColor = UIColor(hex: "#F4F5F8")
            messageBox.textColor = .black

            dateLabel.snp.remakeConstraints {
                if dateLabel.isHidden {
                    $0.top.equalToSuperview()
                } else {
                    $0.top.equalToSuperview().offset(16)
                }
                $0.leading.trailing.equalToSuperview()
            }

            profileImageView.snp.remakeConstraints {
                $0.top.equalTo(dateLabel.snp.bottom).offset(16)
                $0.width.height.equalTo(32)
                $0.leading.equalToSuperview().offset(20)
            }

            messageBox.snp.remakeConstraints {
                $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
                $0.top.equalTo(profileImageView.snp.top)
                $0.bottom.equalToSuperview()
                $0.width.lessThanOrEqualTo(maxWidth)
            }

            timeLabel.snp.remakeConstraints {
                $0.leading.equalTo(messageBox.snp.trailing).offset(4)
                $0.bottom.equalTo(messageBox.snp.bottom)
            }

            icon.snp.remakeConstraints {
                $0.leading.equalTo(timeLabel.snp.trailing).offset(4)
                $0.bottom.equalTo(messageBox.snp.bottom)
                $0.width.height.equalTo(16)
            }
        }

    }

    open func configure(with message: BaseMessage) {
        sender = message.sender?.nickname ?? ""
        messageBox.text = message.message
        timeLabel.text = Date.sbu_from(message.createdAt).sbu_toString(format: .hhmma)

        if message.sender?.nickname != User.shared.name {
            print("message.sender?.profileURL : \(message.sender?.profileURL)")
            print("message.sender?.nickname : \(message.sender?.nickname)")
            if let url = message.sender?.profileURL, !url.isEmpty {
                let currentProfileURL = url

                profileImageView.loadProfileImage(from: url) { [weak self] image in
                    // 현재 셀이 해당 taskID를 가지고 있는지 확인
                    self?.profileImageView.image = image
                }
            } else {
                profileImageView.image = UIImage(named: "icon_profile2") // 기본 이미지 설정
            }
        }
        setNeedsUpdateConstraints()
    }

    private func confingImage(url: String) {
        print(url)
        profileImageView.loadImage(from: url)
    }

    open func checked(check: Bool) {
        if check {
            icon.image = UIImage(named: "icon_chat_check2")
        } else {
            icon.image = UIImage(named: "icon_chat_check1")
        }

        setNeedsUpdateConstraints()
    }

    open func addHeader(date: String) {
        dateLabel.isHidden = false
        dateLabel.text = date
        setNeedsUpdateConstraints()
    }

}
