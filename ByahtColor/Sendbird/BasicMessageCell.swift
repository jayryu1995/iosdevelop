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
    private lazy var messageLabel: UILabel = {
        let messageLabel: UILabel = UILabel()
        messageLabel.textColor = .label
        messageLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        messageLabel.numberOfLines = 0
        return messageLabel
    }()

    private lazy var previewImageView: UIImageView = {
        let previewImageView = UIImageView()
        previewImageView.backgroundColor = .secondarySystemBackground
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.layer.cornerRadius = 10
        previewImageView.clipsToBounds = true
        return previewImageView
    }()

 
    private lazy var messageBox: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal // 가로 방향으로 정렬
        stackView.alignment = .top // 위쪽 정렬
        stackView.distribution = .fill // 내용물에 맞게 크기 조정
        stackView.spacing = 10 // 내부 뷰 간격
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 16
        stackView.backgroundColor = UIColor(hex: "#F4F5F8")
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        return stackView
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
    
    private let maxWidth = UIScreen.main.bounds.width * 0.6
    private lazy var viewModel = BusinessViewModel()
    private var imageUrl = ""
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
        
        messageBox.addArrangedSubview(previewImageView) // StackView에 추가
        messageBox.addArrangedSubview(messageLabel)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.isHidden = false
        previewImageView.isHidden = true
        timeLabel.isHidden = false
        icon.isHidden = false
        messageLabel.text = nil
        timeLabel.text = nil
        dateLabel.isHidden = true
        dateLabel.text = nil
        icon.image = nil
        messageLabel.numberOfLines = 0
        
        icon.snp.removeConstraints()
        timeLabel.snp.removeConstraints()
        messageBox.snp.removeConstraints()
        previewImageView.snp.removeConstraints()
        messageLabel.snp.removeConstraints()
        
        
        imageUrl = ""
        sender = ""
        id = ""
    }
    
    open override func updateConstraints() {
        super.updateConstraints()

        
        let me = User.shared.name

        if sender == me {
            profileImageView.isHidden = true
            messageBox.backgroundColor = UIColor(hex: "#009BF2")
            messageLabel.textColor = .white

            dateLabel.snp.remakeConstraints {
                if dateLabel.isHidden {
                    $0.top.equalToSuperview()
                } else {
                    $0.top.equalToSuperview().offset(16)
                }
                $0.leading.trailing.equalToSuperview()
            }

            if imageUrl != "" {
                // previewImageView가 표시되는 경우
                previewImageView.isHidden = false
                previewImageView.snp.remakeConstraints { make in
                    make.width.height.equalTo(55) // 미리보기 이미지 크기
                }
                
                messageLabel.snp.remakeConstraints{ make in
                    make.centerY.equalToSuperview()
                }
                
                // StackView 자체 제약 조건 설정
                messageBox.snp.remakeConstraints { make in
                    make.top.equalTo(dateLabel.snp.bottom).offset(8)
                    make.trailing.equalToSuperview().offset(-10)
                    make.bottom.lessThanOrEqualToSuperview()
                    make.width.lessThanOrEqualTo(maxWidth) // 최대 너비 제한
                }
            } else {
                // previewImageView가 숨겨지는 경우
                previewImageView.isHidden = true
                previewImageView.snp.remakeConstraints { make in
                    make.width.height.equalTo(0) // 크기를 0으로 설정
                }
                
                // StackView 자체 제약 조건 설정
                messageBox.snp.remakeConstraints { make in
                    make.top.equalTo(dateLabel.snp.bottom).offset(8)
                    make.trailing.equalToSuperview().offset(-10)
                    make.bottom.lessThanOrEqualToSuperview().offset(-8)
                    make.width.lessThanOrEqualTo(maxWidth) // 최대 너비 제한
                }
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
            messageBox.backgroundColor = UIColor(hex: "#F4F5F8")
            messageLabel.textColor = .black

            dateLabel.snp.remakeConstraints {
                if dateLabel.isHidden {
                    $0.top.equalToSuperview()
                } else {
                    $0.top.equalToSuperview().offset(16)
                }
                $0.leading.trailing.equalToSuperview()
            }

            profileImageView.snp.remakeConstraints {
                $0.top.equalTo(dateLabel.snp.bottom).offset(8)
                $0.width.height.equalTo(32)
                $0.leading.equalToSuperview()
            }
            
            if imageUrl != "" {
                messageBox.snp.remakeConstraints {
                    $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
                    $0.top.equalTo(profileImageView.snp.top)
                    $0.bottom.equalToSuperview()
                    $0.width.lessThanOrEqualTo(maxWidth)
                }
                // previewImageView가 표시되는 경우
                previewImageView.isHidden = false
                previewImageView.snp.remakeConstraints { make in
                    make.width.height.equalTo(55) // 미리보기 이미지 크기
                }
                
                messageLabel.snp.remakeConstraints{ make in
                    make.centerY.equalToSuperview()
                }
            } else {
                messageBox.snp.remakeConstraints {
                    $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
                    $0.top.equalTo(profileImageView.snp.top)
                    $0.bottom.equalToSuperview().offset(-8)
                    $0.width.lessThanOrEqualTo(maxWidth)
                }
                
                // previewImageView가 숨겨지는 경우
                previewImageView.isHidden = true
                previewImageView.snp.remakeConstraints { make in
                    make.width.height.equalTo(0) // 크기를 0으로 설정
                }
                
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
        messageLabel.text = message.message
        timeLabel.text = Date.sbu_from(message.createdAt).sbu_toString(format: .hhmma)
        
        if let customType = message.customType {
            if customType == "campaignImage_with_text"{
                messageLabel.numberOfLines = 2
                let url = URL(string:message.data)
                imageUrl = message.data
                DispatchQueue.main.async {
                    self.previewImageView.kf.setImage(with: url)
                    self.previewImageView.isHidden = false
                }
            }
        }
        
        if message.sender?.nickname != User.shared.name {
            if let id = message.sender?.userId{
                self.id = id
            }
            if let urlString = message.sender?.profileURL {
                //let url = URL(string: urlString)
                let url =
                URL(string: "https://glowb-input.s3.ap-southeast-1.amazonaws.com/img/profile/influence/000004.3e9d93f92b8d4926a4f171ea43d27779.1501.jpg")
                DispatchQueue.main.async {
                    
                    self.profileImageView.kf.setImage(
                        with: url,
                        placeholder: UIImage(named: "icon_profile2"),
                        options: [.onFailureImage(UIImage(named: "icon_profile2"))]
                    )
                }
                
            } else {
                profileImageView.image = UIImage(named: "icon_profile2") // 기본 이미지 설정
            }
        }
         setNeedsUpdateConstraints()
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
    
    open func hideTime(){
        timeLabel.isHidden = true
        icon.isHidden = true
        
        setNeedsUpdateConstraints()
    }

}
