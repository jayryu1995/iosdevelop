//
//  McnChatsListCell.swift
//  ByahtColor
//
//  Created by jaem on 9/30/24.
//

import Kingfisher
import UIKit
import SendbirdChatSDK
import SnapKit
class McnChannelListCell: UITableViewCell {

    private let profileImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "sample_image"))
        image.clipsToBounds = true
        image.layer.cornerRadius = 2
        image.contentMode = .scaleAspectFill
        return image
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = .black
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = .black
        return label
    }()

    private let notificationView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FF2929")
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private let icon = {
        let icon = UIImageView(image: UIImage(named: "arrow_right"))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    
    private var taskIdentifier: UUID?
    
    var name = ""
    var influenceId = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        taskIdentifier = nil // 기존 taskIdentifier 초기화
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.isUserInteractionEnabled = true
        contentView.addSubview(profileImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(notificationView)
        contentView.addSubview(icon)
    }

    private func setupConstraints() {
        profileImage.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(53)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.top.bottom.equalToSuperview().inset(18)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.top)
            $0.bottom.equalTo(profileImage.snp.centerY)
            $0.leading.equalTo(profileImage.snp.trailing).offset(16)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.centerY)
            $0.bottom.equalTo(profileImage.snp.bottom)
            $0.leading.equalTo(profileImage.snp.trailing).offset(16)
            $0.trailing.equalTo(notificationView.snp.leading).inset(16)
        }

        icon.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
        
        notificationView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(icon.snp.leading).offset(-8)
            $0.width.height.equalTo(8)
        }
    }

    open func configure(with influence: InfluenceProfileDto, count: Int, unReadMessage: Bool) {
        let taskID = UUID()
        self.taskIdentifier = taskID
        self.nameLabel.text = influence.name ?? ""
        self.influenceId = influence.memberId ?? ""
        self.contentLabel.text = "\(count) 브랜드에서 제안"
        print(unReadMessage)
        if unReadMessage {
            notificationView.isHidden = false
        }else{
            notificationView.isHidden = true
        }
        if let image = influence.video, image.contains(".jpg"){
            let url = URL(string: image)
            self.profileImage.kf.setImage(with: url)
        }else if let image = influence.imagePath{
            let url = URL(string: image)
            self.profileImage.kf.setImage(with: url)
        }
        
    }

  
}

