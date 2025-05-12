//
//  BasicFileCell.swift
//  ByahtColor
//
//  Created by jaem on 7/23/24.
//

import Foundation
import UIKit
import SendbirdChatSDK
import SnapKit

open class BasicFileCell: UITableViewCell {

    
    public lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView(image: UIImage(named: "icon_profile2"))
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 16
        profileImageView.clipsToBounds = true
        return profileImageView
    }()

    public lazy var messageLabel: UILabel = {
        let messageLabel: UILabel = UILabel()
        messageLabel.textColor = .label
        messageLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        messageLabel.numberOfLines = 2
        return messageLabel
    }()

    public lazy var previewImageView: UIImageView = {
        let previewImageView = UIImageView()
        previewImageView.backgroundColor = .secondarySystemBackground
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.layer.cornerRadius = 10
        previewImageView.clipsToBounds = true
        return previewImageView
    }()

    private lazy var messageBox: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F4F5F8")
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
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
    
    private lazy var viewModel = BusinessViewModel()

    private var sender = ""
    private var id = ""
    private let maxWidth = UIScreen.main.bounds.width * 0.6
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(messageBox)
        contentView.addSubview(timeLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(icon)
        messageBox.addSubview(previewImageView)
        messageBox.addSubview(messageLabel)
        
        dateLabel.snp.makeConstraints {
            if dateLabel.isHidden {
                $0.top.equalToSuperview()
            } else {
                $0.top.equalToSuperview().offset(16)
            }
            $0.leading.trailing.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel).offset(10)
            make.leading.equalToSuperview()
            make.width.height.equalTo(32)
        }

        messageBox.snp.makeConstraints { make in
            make.top.equalTo(dateLabel).offset(10)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.width.lessThanOrEqualTo(maxWidth)
            make.bottom.equalTo(contentView).offset(-10)
        }

        previewImageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(messageBox).inset(10)
            make.leading.equalTo(messageBox).offset(10)
            make.width.height.equalTo(55)
        }

        messageLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(previewImageView.snp.trailing).offset(10)
            make.trailing.equalTo(messageBox).offset(-10)
        }
        
        // 메시지 길이에 따라 유동적으로 크기 조정
        messageLabel.setContentHuggingPriority(.required, for: .horizontal)
        messageLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

    }


    public override func prepareForReuse() {
        super.prepareForReuse()

        profileImageView.isHidden = false
        messageLabel.text = nil
        timeLabel.text = nil
        dateLabel.isHidden = true
        dateLabel.text = nil
        icon.image = nil
    }

    private func remakeConstraint(){
        // profileImageView constraints
        profileImageView.isHidden = true
        messageLabel.textAlignment = .right
        messageLabel.textColor = .white
        messageBox.backgroundColor = UIColor(hex: "#009BF2")
        messageBox.snp.remakeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.leading.greaterThanOrEqualToSuperview().offset(100) // 최소 너비 제한
            make.bottom.equalTo(contentView).offset(-10)
        }
        
        previewImageView.snp.remakeConstraints { make in
            make.top.bottom.equalTo(messageBox).inset(10)
            make.leading.equalTo(messageBox).offset(10)
            make.width.height.equalTo(55)
        }
        
        messageLabel.snp.remakeConstraints { make in
            make.top.equalTo(messageBox).offset(10)
            make.bottom.equalTo(messageBox).offset(-10)
            make.trailing.equalTo(messageBox).offset(-10)
            make.leading.equalTo(previewImageView.snp.trailing).offset(10)
        }
        
    }
    
    open func configure(with message: FileMessage) {
        if let sender = message.sender {
            if sender.nickname == User.shared.nickname ?? "" {
                remakeConstraint()
            }
        }
        
        if let imageURL = imageURL(for: message) {
            previewImageView.kf.setImage(with: imageURL)
        }else{
            previewImageView.removeFromSuperview()
        }

    }

    private func imageURL(for message: FileMessage) -> URL? {
        if let thumbnailURLString = message.thumbnails?.first?.url {
            return URL(string: thumbnailURLString)
        } else if message.type.hasPrefix("image") {
            return URL(string: message.url)
        }

        return nil
    }

}
