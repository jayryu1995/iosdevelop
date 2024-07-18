//
//  BoardCommentTC.swift
//  ByahtColor
//
//  Created by jaem on 4/17/24.
//

import UIKit
import SnapKit
import AlamofireImage
import Alamofire

class BoardCommentTC: UITableViewCell, UIScrollViewDelegate {
    weak var delegate: BoardCommentCellDelegate?
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = UIColor.black
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = UIColor(hex: "#535358")
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = UIColor(hex: "#BCBDC0")
        return label
    }()

    private let likeButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_comment"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    private let likeIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "icon_heart4")
        icon.contentMode = .scaleAspectFit
        icon.isHidden = true
        return icon
    }()

    private let likeLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.isHidden = true
        return label
    }()

    private let profileIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "icon_profile2")
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 12
        return image
    }()

    private let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_more"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isHidden = true
        return button
    }()

    private var likeFlag = false
    private var likeCount = 0
    private let containerView = UIView()
    private var commentDto: BoardCommentVO?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor(hex: "#F7F7F7")
        setupUI()
        setContainView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()  // 뷰가 자신의 크기를 다시 계산하도록 함
    }

    private func setupUI() {
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(dateLabel)
        contentView.addSubview(profileIcon)
        contentView.addSubview(likeIcon)
        contentView.addSubview(likeLabel)
        contentView.addSubview(moreButton)

        profileIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(24)
        }

        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(profileIcon.snp.trailing).offset(10)
            make.centerY.equalTo(profileIcon.snp.centerY)
        }

        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(24)
        }

        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel.snp.centerY)
            make.trailing.equalTo(moreButton.snp.leading).offset(-20)
            make.width.height.equalTo(24)
        }

        commentButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel.snp.centerY)
            make.trailing.equalTo(likeButton.snp.leading).offset(-10)
            make.width.height.equalTo(24)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileIcon.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-10)
        }

        likeIcon.snp.makeConstraints {
            $0.leading.equalTo(dateLabel.snp.trailing).offset(10)
            $0.centerY.equalTo(dateLabel.snp.centerY)
        }

        likeLabel.snp.makeConstraints {
            $0.leading.equalTo(likeIcon.snp.trailing)
            $0.centerY.equalTo(dateLabel.snp.centerY)
        }

    }

    // 삭제 뷰
    private func setContainView() {
        let deleteButton = UIButton()
        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 16)
        deleteButton.backgroundColor = .white
        deleteButton.contentHorizontalAlignment = .left
        deleteButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.clipsToBounds = true
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

        // 컨테이너 뷰 설정
        containerView.addSubview(deleteButton)
        containerView.isHidden = true // 초기 상태는 숨김
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.top.equalTo(moreButton.snp.bottom).offset(10)
            $0.trailing.equalTo(moreButton.snp.trailing)
            $0.bottom.equalTo(deleteButton.snp.bottom) // 이 부분을 추가
        }

        deleteButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(44)
            $0.top.equalToSuperview()
        }

    }

    // 데이터 입력
    func setData(comment: BoardCommentVO) {
        self.commentDto = comment
        self.contentLabel.text = comment.content ?? ""
        self.nicknameLabel.text = comment.nickname ?? ""
        self.likeButton.tag = comment.no ?? 0
        self.likeFlag = comment.isLiked ?? false
        self.likeCount = comment.like_count ?? 0

        let url = "\(Bundle.main.TEST_URL)/image\( comment.imageUrl ?? "" )"
        let date = comment.regi_date ?? ""

        if let url = URL(string: url) { profileIcon.af.setImage(withURL: url) }
        self.likeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.dateLabel.text = CustomFunction().formatDate(date)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        if comment.writer_id == User.shared.id || User.shared.auth == 1 {
            moreButton.isHidden = false
        } else {
            moreButton.isHidden = true
            likeButton.snp.remakeConstraints {
                $0.centerY.equalTo(nicknameLabel.snp.centerY)
                $0.trailing.equalToSuperview().offset(-20)
                $0.width.height.equalTo(24)
            }
        }
        updateLikeButtonImage()
        updateLikeLabel()
        self.layoutIfNeeded()
    }

    // 좋아요 버튼 상태 업데이트
    private func updateLikeButtonImage() {
        self.likeButton.setImage(UIImage(named: likeFlag ? "icon_heart2" : "like_icon"), for: .normal)
    }

    // 좋아요 라벨 상태 업데이트
    private func updateLikeLabel() {
        self.likeLabel.isHidden = (likeCount <= 0)
        self.likeLabel.text = "\(likeCount)"
        self.likeIcon.isHidden = (likeCount <= 0)
    }

    // 좋아요 버튼 탭
    @objc func buttonTapped(_ sender: UIButton) {
        likeFlag.toggle()
        if likeFlag {
            // 좋아요를 요청
            updateLikeRequest(no: sender.tag)
            likeCount += 1

        } else {
            // 좋아요를 해제
            updateUnLikeRequest(no: sender.tag)
            likeCount -= 1
        }
        updateLikeButtonImage()
        updateLikeLabel()

    }

    // 좋아요 요청
    private func updateLikeRequest(no: Int?) {
        let url = "\(Bundle.main.TEST_URL)/board/comment/like"
        let parameters: [String: Any] = ["comment_id": no ?? 0, "user_id": User.shared.id ?? ""]
        AF.request(url, method: .post, parameters: parameters)
            .response { [weak self] response in
                switch response.result {
                case .success:
                    log(vc: "BoardCommentTC", message: "updateLikeRequest request successful")

                case .failure(let error):
                    log(vc: "BoardCommentTC", message: "updateLikeRequest request fail : \(error)")
                }
            }
    }

    // 좋아요 제거
    private func updateUnLikeRequest(no: Int?) {
        let url = "\(Bundle.main.TEST_URL)/board/comment/like"
        let parameters: [String: Any] = ["comment_id": no ?? 0, "user_id": User.shared.id ?? ""]
        AF.request(url, method: .delete, parameters: parameters)
            .response { [weak self] response in
                switch response.result {
                case .success:
                    log(vc: "BoardCommentTC", message: "updateLikeRequest request successful")

                case .failure(let error):
                    log(vc: "BoardCommentTC", message: "updateLikeRequest request fail : \(error)")
                }
            }
    }

    // 삭제
    @objc private func deleteButtonTapped() {
        let url = "\(Bundle.main.TEST_URL)/board/comment/delete" // 실제 요청할 서버의 URL로 변경해주세요.
        let board_no = commentDto?.board_no ?? 0
        let comment_no = commentDto?.no ?? 0
        let parameters: [String: Any] = [
            "board_no": board_no.toString(),
            "comment_no": comment_no.toString()
        ]
        AF.request(url, method: .post, parameters: parameters).response { response in
            switch response.result {
            case .success:
                log(vc: "BoardCommentTC", message: "deleteButtonTapped Success")
                DispatchQueue.main.async {
                    self.delegate?.didRequestDelete(self)
                }
            case .failure(let error):
                log(vc: "BoardCommentTC", message: "deleteButtonTapped error : \(error)")
            }
        }
    }

    // 더보기 버튼
    @objc private func moreButtonTapped() {
        containerView.isHidden = !containerView.isHidden
    }

}
protocol BoardCommentCellDelegate: AnyObject {
    func didRequestDelete(_ cell: BoardCommentTC)
}
