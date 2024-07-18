//
//  BoardCell.swift
//  ByahtColor
//
//  Created by jaem on 4/19/24.
//

import UIKit
import SnapKit
import AlamofireImage
import Alamofire

class TalkReadTableCell: UITableViewCell, UIScrollViewDelegate {
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "icon_profile2")
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 17.5
        image.clipsToBounds = true
        return image
    }()
    private let nicknameLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()

    private let dateLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = UIColor(hex: "#BCBDC0")
        return label
    }()

    private let titleLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.numberOfLines = 0
        return label
    }()

    private let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        return pageControl
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "context"
        label.textColor = UIColor(hex: "#535358")
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "like_icon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private let likeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#535358")
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    private let commentButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.setImage(UIImage(named: "icon_comment"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#535358")
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()
    private let bottomLayer: UIView = {
        let layer = UIView()
        layer.backgroundColor = UIColor(hex: "#F7F7F7")
        return layer
    }()

    private var currentPage: Int = 0
    private var likeCounter = 0 // 게시물
    private var likeFlag = false
    private var likeCount = 0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        imageScrollView.delegate = self

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()  // 뷰가 자신의 크기를 다시 계산하도록 함
    }

    private func setupViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageScrollView)
        contentView.addSubview(pageControl)
        contentView.addSubview(contentLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(likeLabel)
        contentView.addSubview(commentButton)
        contentView.addSubview(commentLabel)
        contentView.addSubview(bottomLayer)

        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(35)
        }

        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }

        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom).offset(5)
            make.leading.equalTo(nicknameLabel)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        imageScrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width)
        }

        // 페이지 컨트로 레이아웃 설정
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        likeButton.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(10)
            $0.leading.equalTo(profileImageView.snp.leading)
            $0.width.height.equalTo(24)
            $0.bottom.equalToSuperview().inset(10)
        }

        likeLabel.snp.makeConstraints {
            $0.centerY.equalTo(likeButton)
            $0.leading.equalTo(likeButton.snp.trailing).offset(2)
        }

        commentButton.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(10)
            $0.leading.equalTo(likeLabel.snp.trailing).offset(10)
            $0.width.height.equalTo(24)
        }

        commentLabel.snp.makeConstraints {
            $0.centerY.equalTo(commentButton)
            $0.leading.equalTo(commentButton.snp.trailing).offset(5)
        }

        bottomLayer.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(10)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(5)
        }

    }

    // 데이터 입력
    func configure(with board: Talk) {
        let url = "\(Bundle.main.TEST_URL)/profile\( String(describing: board.profileImage) )"
        profileImageView.loadImage(from: url, resizedToWidth: 35)
        profileImageView.contentMode = .scaleAspectFit
        nicknameLabel.text = board.nickname
        dateLabel.text = CustomFunction().formatDate(board.regi_date ?? "")
        titleLabel.text = board.title
        contentLabel.text = board.content
        commentLabel.text = board.comment_count?.toString()
        likeLabel.text = board.like_count?.toString()

        if board.imageList?.isEmpty == false {
            setImage(imageList: board.imageList!)
        } else { modifyContraint() }

        let isLiked = board.isLiked ?? false
        if isLiked {
            likeButton.setImage(UIImage(named: "like_icon2"), for: .normal)
            likeButton.isSelected = true
        } else {
            likeButton.setImage(UIImage(named: "like_icon"), for: .normal)
        }
        likeButton.tag = board.no ?? 0
        likeButton.addTarget(self, action: #selector(button1Tapped), for: .touchUpInside)

    }

    // 이미지뷰 세팅 함수
    private func setImage(imageList: [String]) {
        var lastImageView: UIImageView?
        pageControl.numberOfPages = imageList.count

        for resource in imageList {
            let imageView = UIImageView()
            let widthSize = UIScreen.main.bounds.width
            let url = "\(Bundle.main.TEST_URL)/board\( resource )"
            imageView.loadImage(from: url, resizedToWidth: widthSize)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageScrollView.addSubview(imageView)

            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(imageScrollView.snp.height)

                if let lastImageView = lastImageView {
                    make.leading.equalTo(lastImageView.snp.trailing) // 이전 이미지 뷰와의 간격
                } else {
                    make.leading.equalTo(imageScrollView.snp.leading) // 첫 이미지 뷰의 시작 위치
                }
                lastImageView = imageView
            }
        }

        if let lastImageView = lastImageView {
            lastImageView.snp.makeConstraints { make in
                make.trailing.equalTo(imageScrollView.snp.trailing) // 마지막 이미지 뷰와 스크롤 뷰 끝 간의 간격
            }
        }

    }

    private func modifyContraint() {
        imageScrollView.snp.remakeConstraints {
            $0.width.height.equalTo(0)
        }

        // 페이지 컨트로 레이아웃 설정
        pageControl.snp.remakeConstraints { make in
            make.width.height.equalTo(0)
        }

        contentLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    // 좋아요 눌렸을 때 호출될 메서드
    @objc private func button1Tapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let likeRequestDto = BoardLikeDto(user_id: User.shared.id ?? "", board_id: sender.tag)
        // 상태에 따른 이미지 변경
        if sender.isSelected {
            sender.setImage(UIImage(named: "like_icon2"), for: .normal)
            likeCounter += 1
            likeLabel.text = "\(likeCounter)"
            sendLikeRequest(likeRequestDto: likeRequestDto)
        } else {
            sender.setImage(UIImage(named: "like_icon"), for: .normal)
            likeCounter -= 1
            likeLabel.text = "\(likeCounter)"
            sendUnlikeRequest(likeRequestDto: likeRequestDto)
        }
    }

    private func sendUnlikeRequest(likeRequestDto: BoardLikeDto) {
        let url = "\(Bundle.main.TEST_URL)/board/like"
        AF.request(url, method: .delete, parameters: likeRequestDto, encoder: JSONParameterEncoder.default)
            .response { response in
                switch response.result {
                case .success(let data):
                    log(vc: "TalkReadTC", message: "sendUnlikeRequest request successful")

                case .failure(let error):
                    log(vc: "TalkReadTC", message: "sendUnlikeRequest Error : \(error)")
                }
            }
    }

    private func sendLikeRequest(likeRequestDto: BoardLikeDto) {
        let url = "\(Bundle.main.TEST_URL)/board/like"
        AF.request(url, method: .post, parameters: likeRequestDto, encoder: JSONParameterEncoder.default)
            .response { response in
                switch response.result {
                case .success(let data):
                    log(vc: "TalkReadTC", message: "sendLikeRequest request successful")

                case .failure(let error):
                    log(vc: "TalkReadTC", message: "sendLikeRequest Error : \(error)")
                }
            }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
