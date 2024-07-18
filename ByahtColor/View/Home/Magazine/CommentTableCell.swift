//
//  CommentTableCell.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/19.
//

import Foundation
import UIKit
import SnapKit
import Alamofire
import AlamofireImage

class CommentTableCell: UITableViewCell, UIScrollViewDelegate {

    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = UIColor.black
        return label
    }()
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = UIColor(hex: "#535358")
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = UIColor(hex: "#BCBDC0")
        return label
    }()
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "like_icon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_comment"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    let likeIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "icon_heart4")
        icon.contentMode = .scaleAspectFit
        icon.isHidden = true
        return icon
    }()

    let likeLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.isHidden = true
        return label
    }()

    let profileIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "icon_profile2")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()

    private var likeFlag = false
    private var likeCount = 0
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(24)
        }

        commentButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel.snp.centerY)
            make.trailing.equalTo(likeButton.snp.leading).offset(-5)
            make.width.height.equalTo(24)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
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

    func setData(comment: MagazineCommentVO) {
        self.contentLabel.text = comment.content ?? ""
        self.nicknameLabel.text = comment.nickname ?? ""
        self.likeButton.tag = comment.no ?? 0
        likeFlag = comment.isLiked ?? false
        if likeFlag {
            self.likeButton.setImage(UIImage(named: "icon_heart2"), for: .normal)
        }

        let url = "\(Bundle.main.TEST_URL)/profile\( comment.imageUrl ?? "" )"
        profileIcon.loadImage(from: url, resizedToWidth: 24)

        self.likeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        let date = comment.regi_date ?? ""
        self.dateLabel.text = CustomFunction().formatDate(date)

        likeCount = comment.like_count ?? 0
        if likeCount > 0 {
            self.likeLabel.isHidden = false
            self.likeLabel.text = "\(likeCount)"
            self.likeIcon.isHidden = false
        }

    }

    @objc func buttonTapped(_ sender: UIButton) {
        likeFlag = !likeFlag
        if likeFlag {
            // 좋아요를 요청
            updateLikeRequest(no: sender.tag)
            self.likeLabel.text = String(likeCount + 1)
            self.likeButton.setImage(UIImage(named: "icon_heart2"), for: .normal)
        } else {
            // 좋아요를 해제
            updateUnLikeRequest(no: sender.tag)
            self.likeLabel.text = String(likeCount - 1)
            self.likeButton.setImage(UIImage(named: "like_icon"), for: .normal)
        }

    }

    private func updateLikeRequest(no: Int?) {
        let url = "\(Bundle.main.TEST_URL)/magazine/comment/like"

        // 요청에 필요한 파라미터 설정
        let parameters: [String: Any] = ["comment_id": no ?? 0, "user_id": User.shared.id ?? ""]

        AF.request(url, method: .post, parameters: parameters)
            .response { [weak self] response in
                switch response.result {
                case .success(let data):
                    // 요청 성공 처리
                    print("Like request successful")
                case .failure(let error):
                    // 요청 실패 처리
                    print("Error in like request: \(error)")
                }
            }
    }

    private func updateUnLikeRequest(no: Int?) {
        let url = "\(Bundle.main.TEST_URL)/magazine/comment/like"

        // 요청에 필요한 파라미터 설정
        let parameters: [String: Any] = ["comment_id": no ?? 0, "user_id": User.shared.id ?? ""]

        AF.request(url, method: .delete, parameters: parameters)
            .response { [weak self] response in
                switch response.result {
                case .success(let data):
                    // 요청 성공 처리
                    print("Like request successful")
                case .failure(let error):
                    // 요청 실패 처리
                    print("Error in like request: \(error)")
                }
            }
    }
}
