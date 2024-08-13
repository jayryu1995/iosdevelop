//
//  GroupCannelListCell.swift
//  ByahtColor
//
//  Created by jaem on 7/23/24.
//

import UIKit
import SendbirdChatSDK
import SnapKit
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

    var name = ""
    private var taskIdentifier: UUID?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = UIImage(named: "icon_profile2")
        taskIdentifier = nil // 기존 taskIdentifier 초기화
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
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
        var currentProfileURL: String?
        let taskID = UUID()
        self.taskIdentifier = taskID

        channel.members.forEach { it in
            if it.nickname != User.shared.name {
                nameLabel.text = it.nickname
                name = it.nickname
                if let url = it.profileURL, !url.isEmpty {
                    currentProfileURL = url
                    profileImage.image = UIImage(named: "icon_profile2") // 기본 이미지 설정
                    profileImage.loadProfileImage(from: url) { [weak self] image in
                        guard let self = self, self.taskIdentifier == taskID else { return }
                        // 현재 셀이 해당 taskID를 가지고 있는지 확인
                        self.profileImage.image = image
                    }
                }
            }
        }

        contentLabel.text = channel.lastMessage?.message
        let timeDifference = calculateTimeDifference(from: channel.lastMessage?.createdAt ?? 0)
        timeLabel.text = timeDifference

        notificationView.isHidden = channel.unreadMessageCount == 0
    }

    // 시간 차이 계산 메서드 추가
    func calculateTimeDifference(from milliseconds: Int64) -> String {
        let messageDate = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
        let currentDate = Date()

        let difference = currentDate.timeIntervalSince(messageDate)

        let minutesDifference = Int(difference / 60)
        let hoursDifference = Int(difference / 3600)
        let daysDifference = Int(difference / (3600 * 24))

        if daysDifference > 0 {
            return "\(daysDifference)일 전"
        } else if hoursDifference > 0 {
            return "\(hoursDifference)시간 전"
        } else {
            return "\(minutesDifference)분 전"
        }
    }
}

// open class GroupChannelListCell: UITableViewCell {
//
//    private let profileImage: UIImageView = {
//        let image = UIImageView(image: UIImage(named: "icon_profile2"))
//        image.layer.cornerRadius = 20
//        image.clipsToBounds = true
//        return image
//    }()
//
//    private let nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "Pretendard-Medium", size: 16)
//        label.textColor = .black
//        return label
//    }()
//
//    private let contentLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "Pretendard-Regular", size: 14)
//        label.textColor = .black
//        return label
//    }()
//
//    private let timeLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "Pretendard-Regular", size: 14)
//        label.textColor = UIColor(hex: "#B5B8C2")
//        return label
//    }()
//
//    private let notificationView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(hex: "#FF2929")
//        view.layer.cornerRadius = 4
//        view.clipsToBounds = true
//        return view
//    }()
//
//    var name = ""
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupUI()
//        setupConstraints()
//    }
//
//    open override func prepareForReuse() {
//        super.prepareForReuse()
//        profileImage.image = UIImage(named: "icon_profile2")
//    }
//
//    required public init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupUI() {
//        contentView.addSubview(profileImage)
//        contentView.addSubview(nameLabel)
//        contentView.addSubview(contentLabel)
//        contentView.addSubview(timeLabel)
//        contentView.addSubview(notificationView)
//    }
//
//    private func setupConstraints() {
//        profileImage.snp.makeConstraints {
//            $0.width.height.equalTo(40)
//            $0.centerY.equalToSuperview()
//            $0.leading.equalToSuperview().offset(20)
//            $0.top.bottom.equalToSuperview().inset(18)
//        }
//
//        nameLabel.snp.makeConstraints {
//            $0.top.equalTo(profileImage.snp.top)
//            $0.bottom.equalTo(profileImage.snp.centerY)
//            $0.leading.equalTo(profileImage.snp.trailing).offset(16)
//        }
//
//        timeLabel.snp.makeConstraints {
//            $0.bottom.equalTo(nameLabel.snp.bottom)
//            $0.leading.equalTo(nameLabel.snp.trailing).offset(8)
//        }
//
//        contentLabel.snp.makeConstraints {
//            $0.top.equalTo(profileImage.snp.centerY)
//            $0.bottom.equalTo(profileImage.snp.bottom)
//            $0.leading.equalTo(profileImage.snp.trailing).offset(16)
//            $0.trailing.equalTo(notificationView.snp.leading).inset(16)
//        }
//
//        notificationView.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.trailing.equalToSuperview().inset(20)
//            $0.width.height.equalTo(8)
//        }
//    }
//
//    open func configure(with channel: GroupChannel) {
//        var currentProfileURL: String? // 현재 셀의 URL을 저장
//            channel.members.forEach { it in
//                if it.nickname != User.shared.name {
//                    nameLabel.text = it.nickname
//                    name = it.nickname
//                    if let url = it.profileURL {
//                        currentProfileURL = url
//                        profileImage.image = UIImage(named: "icon_profile2") // 기본 이미지 설정
//                        if url.isEmpty == false {
//                            profileImage.loadProfileImage(from: url) { [weak self] image in
//                                guard let self = self else { return }
//                                // 셀이 재사용되었는지 확인
//                                if url == currentProfileURL {
//                                    self.profileImage.image = image
//                                }
//                            }
//                        }
//
//                    }
//                }
//            }
//
//        contentLabel.text = channel.lastMessage?.message
//        let timeDifference = calculateTimeDifference(from: channel.lastMessage?.createdAt ?? 0)
//        timeLabel.text = timeDifference
//
//        if channel.unreadMessageCount == 0 {
//            notificationView.isHidden = true
//        } else {
//            notificationView.isHidden = false
//        }
//
//    }
//
//    // 시간 차이 계산 메서드 추가
//    func calculateTimeDifference(from milliseconds: Int64) -> String {
//        let messageDate = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
//        let currentDate = Date()
//
//        let difference = currentDate.timeIntervalSince(messageDate)
//
//        let minutesDifference = Int(difference / 60)
//        let hoursDifference = Int(difference / 3600)
//        let daysDifference = Int(difference / (3600 * 24))
//
//        if daysDifference > 0 {
//            return "\(daysDifference)일 전"
//        } else if hoursDifference > 0 {
//            return "\(hoursDifference)시간 전"
//        } else {
//            return "\(minutesDifference)분 전"
//        }
//    }
// }

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
