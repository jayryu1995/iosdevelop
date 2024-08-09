//
//  SnapDetailTableViewCell.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/23.
//

import UIKit
import SnapKit
import AlamofireImage
import Alamofire

protocol CollabDetailTableViewCellDelegate: AnyObject {
    func didCopyText(message: String)
}
class CollabDetailTableViewCell: UITableViewCell, UIScrollViewDelegate {
    weak var delegate: CollabDetailTableViewCellDelegate?
    var snapId: String?
    var postNo: Int?
    var likeFlag = false
    var like_count: Int?
    var get_isLiked: Bool?
    var followFlag: Bool = false
    // 이미지 스크롤 뷰
    let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    // 두 개의 버튼
    let button1: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "like_icon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        button.layer.cornerRadius = 6
        button.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        return button
    }()

    var onButtonTapped: (() -> Void)?

    let profileIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_profile2")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "collab_detail_title".localized
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()

    let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "collab_detail_context".localized
        label.textColor = UIColor(hex: "#4E505B")
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    let subtitleLabel1: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "collab_detail_subtitle".localized
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    let subtitleLabel2: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "collab_detail_subtitle2".localized
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(hex: "#4E505B")
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    let linkLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "collab_detail_link".localized
        label.isUserInteractionEnabled = true // 사용자 상호작용을 활성화합니다.
        label.textColor = UIColor(hex: "#935DFF")
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    let codeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Shopee Voucher : "
        label.isUserInteractionEnabled = true // 사용자 상호작용을 활성화합니다.
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    let codeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(hex: "#935DFF"), for: .normal)
        button.layer.borderColor = UIColor(hex: "#935DFFB2").cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.setBackgroundColor(UIColor(hex: "#935DFF1A"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        return button
    }()

    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        return pageControl
    }()

    var onButton2Tapped: (() -> Void)?
    // 두 개의 라벨
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Label 1"
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        return label
    }()

    private var linkUrl = ""
    // 현재 페이지를 나타내는 변수
    var currentPage: Int = 0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        imageScrollView.delegate = self
        backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        linkLabel.addGestureRecognizer(tapGesture)
        button1.addTarget(self, action: #selector(button1Tapped), for: .touchUpInside)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        contentView.addSubview(imageScrollView)
        contentView.addSubview(button1)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(profileIcon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(linkLabel)
        contentView.addSubview(subtitleLabel1)
        contentView.addSubview(subtitleLabel2)
        contentView.addSubview(codeButton)
        contentView.addSubview(codeLabel)
        contentView.addSubview(pageControl)
        codeButton.addTarget(self, action: #selector(copyTextToClipboard), for: .touchUpInside)
        profileIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(40)
        }

        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileIcon.snp.centerY)
            $0.leading.equalTo(profileIcon.snp.trailing).offset(10)
        }

        imageScrollView.snp.makeConstraints {
            $0.top.equalTo(profileIcon.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width)
        }

        // 페이지 컨트로 레이아웃 설정
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }

        subtitleLabel1.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel1.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }

        subtitleLabel2.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }

        infoLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel2.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }

        linkLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }

        codeLabel.snp.makeConstraints {
            $0.top.equalTo(linkLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }

        codeButton.snp.makeConstraints {
            $0.top.equalTo(linkLabel.snp.bottom).offset(10)
            $0.leading.equalTo(codeLabel.snp.trailing).offset(10)
            $0.height.equalTo(codeLabel.snp.height)
            $0.width.equalTo(codeLabel.snp.width)
        }

        // 버튼 1 레이아웃 설정
        button1.snp.makeConstraints { make in
            make.top.equalTo(codeLabel.snp.bottom).offset(10)
            make.width.equalTo(50)
            make.height.equalTo(24)
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-150)
        }

    }

    // 이미지 배열 설정
    func setImages(_ imageList: [String]) {
        var lastImageView: UIImageView?
        pageControl.numberOfPages = imageList.count
        for resource in imageList {
            let imageView = UIImageView()
            let widthSize = UIScreen.main.bounds.width
            let url = "\(Bundle.main.TEST_URL)/image\( resource )"
            imageView.loadImage(from: url)
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

    func setText(snap: CollabDto) {
        snapId = snap.id ?? ""

        nicknameLabel.text = snap.nickname
        titleLabel.text = snap.title
        contentLabel.text = snap.content
        infoLabel.text = snap.info
        linkUrl = snap.link ?? ""
        if snap.application_state ?? 0 < 2 {
            codeLabel.isHidden = true
            codeButton.isHidden = true
        } else {
            codeButton.setTitle(snap.coupon_code, for: .normal)
        }
        like_count = snap.like_count ?? 0
        likeFlag = snap.isLiked ?? false

        if likeFlag {
            button1.setImage(UIImage(named: "like_icon2"), for: .normal)
            get_isLiked = true
        }

        if let like_count = like_count {
            button1.setTitle("\(like_count)", for: .normal)
        }

        self.setPostNo(snap.no ?? 0)

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        let currentPage = Int(round(contentOffsetX / scrollView.bounds.size.width))
        if self.currentPage != currentPage {
            self.currentPage = currentPage
            pageControl.currentPage = currentPage
        }
    }

    // button1이 눌렸을 때 호출될 메서드
    @objc private func button1Tapped() {
        guard let postNo = self.postNo, let userId = User.shared.id else {
            print("필요한 정보가 없습니다.")
            return
        }

        let user_id = User.shared.id ?? ""

        let likeDto = LikeDto(user_id: user_id, snap_id: postNo)

        if likeFlag {
            // 좋아요를 취소하는 경우
            sendUnlikeRequest(likeRequestDto: likeDto)
            likeFlag = !likeFlag
            button1.setImage(UIImage(named: "like_icon"), for: .normal)
            if var like_count = like_count {
                if like_count != 0 {
                    like_count -= 1
                }
                button1.setTitle("\(like_count)", for: .normal)
            }
        } else {
            // 좋아요를 요청하는 경우
            sendLikeRequest(likeRequestDto: likeDto)
            if var like_count = like_count {
                if get_isLiked != true {
                    like_count += 1
                }
                button1.setTitle("\(like_count)", for: .normal)
            }
            likeFlag = !likeFlag
            button1.setImage(UIImage(named: "like_icon2"), for: .normal)
        }
    }

    private func sendLikeRequest(likeRequestDto: LikeDto) {
        let url = "\(Bundle.main.TEST_URL)/snap/like"
        AF.request(url, method: .post, parameters: likeRequestDto, encoder: JSONParameterEncoder.default)
            .response { [weak self] response in
                switch response.result {
                case .success(let data):
                    // 요청 성공 처리
                    log(vc: "CollabDetailCell", message: "sendLikeRequest Success")
                case .failure(let error):
                    // 요청 실패 처리
                    log(vc: "CollabDetailCell", message: "sendLikeRequest Fail : \(error)")
                }
            }
    }

    private func sendUnlikeRequest(likeRequestDto: LikeDto) {
        let url = "\(Bundle.main.TEST_URL)/snap/like"
        AF.request(url, method: .delete, parameters: likeRequestDto, encoder: JSONParameterEncoder.default)
            .response { [weak self] response in
                switch response.result {
                case .success(let data):
                    // 요청 성공 처리
                    log(vc: "CollabDetailCell", message: "sendUnlikeRequest Success")

                case .failure(let error):
                    // 요청 실패 처리
                    log(vc: "CollabDetailCell", message: "sendUnlikeRequest Error : \(error)")
                }
            }
    }

    func setPostNo(_ no: Int) {
        self.postNo = no
    }

    // UILabel 탭 이벤트 처리기
    @objc private func labelTapped() {
        if let url = URL(string: linkUrl) {
            UIApplication.shared.open(url)
        }
    }

    @objc func copyTextToClipboard(_ sender: UIButton) {
        if let titleText = sender.title(for: .normal) {
                UIPasteboard.general.string = titleText
                print("Before calling delegate")
                delegate?.didCopyText(message: "복사되었습니다")
                print("After calling delegate")
            }
    }

}
