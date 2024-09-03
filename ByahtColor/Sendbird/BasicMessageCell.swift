import Foundation
import UIKit
import SendbirdChatSDK
import SnapKit

protocol BasicMessageCellDelegate: AnyObject {
    func didTapCell(_ cell: BasicMessageCell, withProfile profile: InfluenceProfileDto)
}

open class BasicMessageCell: UITableViewCell {
    weak var delegate: BasicMessageCellDelegate?
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_profile2"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
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
    
    private lazy var viewModel = BusinessViewModel()

    private var sender = ""
    private var id = ""
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        contentView.isUserInteractionEnabled = true
        contentView.addSubview(dateLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(messageBox)
        contentView.addSubview(timeLabel)
        contentView.addSubview(icon)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.isHidden = false
        
        messageBox.text = nil
        timeLabel.text = nil
        dateLabel.isHidden = true
        dateLabel.text = nil
        icon.image = nil

        icon.snp.removeConstraints()
        timeLabel.snp.removeConstraints()
        messageBox.snp.removeConstraints()
        

        sender = ""
        id = ""
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
            // UITapGestureRecognizer 추가
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
            self.profileImageView.addGestureRecognizer(tapGesture)
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

    // 이미지가 탭되었을 때 호출되는 메서드
    @objc private func imageTapped(_ Sender: UIButton) {
        if let auth = User.shared.auth{
            if auth < 1 {
                print("인플루언서 계정")
            }else{
                print("기업 계정")
                
                viewModel.findInfluenceById(id:id) { [weak self] result in
                    switch result {
                    case .success(let profile):
                        if let strongSelf = self {
                            strongSelf.delegate?.didTapCell(strongSelf, withProfile: profile)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }

                
            }
        }
        
    }
    
    open func configure(with message: BaseMessage) {
        sender = message.sender?.nickname ?? ""
        messageBox.text = message.message
        timeLabel.text = Date.sbu_from(message.createdAt).sbu_toString(format: .hhmma, localizedFormat: false)
        
        if message.sender?.nickname != User.shared.name {
            if let id = message.sender?.userId{
                self.id = id
            }
            if let url = message.sender?.profileURL, !url.isEmpty {
                profileImageView.loadProfileImage(from: url) { [weak self] image in
                    // 현재 셀이 해당 taskID를 가지고 있는지 확인
                    self?.profileImageView.image = image
                }
            } else {
                profileImageView.image = UIImage(named: "icon_profile2") // 기본 이미지 설정
            }
        }
        // setNeedsUpdateConstraints()
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
