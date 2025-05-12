//
//  GroupCannelListCell.swift
//  ByahtColor
//
//  Created by jaem on 7/23/24.
//

import UIKit
import SendbirdChatSDK
import SnapKit
import Kingfisher
open class GroupChannelListCell: UITableViewCell {

    private let profileImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "icon_profile2"))
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
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
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = .black
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = UIColor(hex: "#B5B8C2")
        return label
    }()

    private let notificationView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FF2929")
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private var taskIdentifier: UUID?
    var name = ""
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()

        DispatchQueue.main.async {
            self.profileImage.image = UIImage(named: "icon_profile2")
        }
        name = ""
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
        contentView.addSubview(timeLabel)
        contentView.addSubview(notificationView)
    }

    private func setupConstraints() {
        profileImage.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.top.bottom.equalToSuperview().inset(18)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.top)
            $0.bottom.equalTo(profileImage.snp.centerY)
            $0.leading.equalTo(profileImage.snp.trailing).offset(16)
        }

        timeLabel.snp.makeConstraints {
            $0.bottom.equalTo(nameLabel.snp.bottom)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(8)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.centerY)
            $0.bottom.equalTo(profileImage.snp.bottom)
            $0.leading.equalTo(profileImage.snp.trailing).offset(16)
            $0.trailing.equalTo(notificationView.snp.leading).inset(16)
        }

        notificationView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(8)
        }
    }

    open func configure(with channel: GroupChannel) {
        
        let taskID = UUID()
        self.taskIdentifier = taskID
        
        channel.members.forEach { it in
            if it.nickname != User.shared.nickname {
                self.nameLabel.text = it.nickname
                self.name = it.nickname
                self.profileImage.isUserInteractionEnabled = true
                
                if let path = it.profileURL, !path.isEmpty {
                    let url = URL(string: path)
                    DispatchQueue.main.async {
                        self.profileImage.kf.setImage(
                            with: url,
                            placeholder: UIImage(named: "icon_profile2"), // 기본 이미지를 설정하지 않음
                            options: nil,
                            completionHandler: { result in
                                switch result {
                                case .success(_):
                                    // 성공적으로 이미지를 로드했을 경우
                                    break
                                case .failure(_):
                                    // 이미지를 가져오지 못한 경우 이미지 제거
                                    break
                                }
                            }
                        )
                    }

                    
                }
            }
        }

        self.contentLabel.text = channel.lastMessage?.message
        let timeDifference = calculateTimeDifference(from: channel.lastMessage?.createdAt ?? 0)
        self.timeLabel.text = timeDifference
        self.notificationView.isHidden = channel.unreadMessageCount == 0
    }

    
    



}

extension UITableView {
    public func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    public func registerNib<T: UITableViewCell>(_: T.Type) {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)

        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }

        return cell
    }
}

// MARK: - ReusableView

public protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    public static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView { }

// MARK: - NibLoadableView

protocol NibLoadableView: AnyObject {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UITableViewCell: NibLoadableView { }
