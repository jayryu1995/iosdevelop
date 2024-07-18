//
//  CustomTableViewCell.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/17.
//

import Foundation
import UIKit
import SnapKit
import Alamofire
import AlamofireImage

class MagazineTableViewCell: UITableViewCell, UIScrollViewDelegate {

    // 이미지 스크롤 뷰
    private let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        return scrollView
    }()

    // 두 개의 버튼
    private let button1: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "like_icon"), for: .normal)
        button.layer.cornerRadius = 6
        button.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        button.backgroundColor = UIColor(hex: "#F7F7F7")
        return button
    }()

    private let button2: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_comment"), for: .normal)
        button.layer.cornerRadius = 6
        button.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        button.backgroundColor = UIColor(hex: "#F7F7F7")
        return button
    }()
    var onButton2Tapped: (() -> Void)?
    // 두 개의 라벨
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Label 1"
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        return label
    }()

    private let label2: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Label 1"
        label.textColor = UIColor(hex: "#4E505B")
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    // 더보기
    private let showMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("see more", for: .normal)
        button.setTitleColor(UIColor(hex: "#BCBDC0"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.titleLabel?.sizeToFit()

        return button
    }()
    private let pageControl = UIPageControl()
    var moreButtonTapped: (() -> Void)?

    // 현재 페이지를 나타내는 변수
    var currentPage: Int = 0
    var likeCounter = 0
    var commentCounter = 0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        imageScrollView.delegate = self
        setupUI()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // 스크롤 뷰의 모든 이미지 뷰 제거
        imageScrollView.subviews.forEach { $0.removeFromSuperview() }
        // 페이지 컨트롤 초기화
        pageControl.currentPage = 0
        // 기타 상태 초기화
        label.text = "Label 1"
        label2.text = "Label 2"
        // 더 필요한 초기화 코드 추가
    }

    private func setupUI() {

        contentView.addSubview(imageScrollView)
        contentView.addSubview(button1)
        contentView.addSubview(button2)
        contentView.addSubview(label)
        contentView.addSubview(label2)

        button1.addTarget(self, action: #selector(button1Tapped), for: .touchUpInside)
        button2.addTarget(self, action: #selector(button2Tapped), for: .touchUpInside)
        showMoreButton.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
        contentView.addSubview(showMoreButton)

        // 이미지 스크롤 뷰 레이아웃 설정
        imageScrollView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.leading.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
            make.centerX.equalToSuperview()
        }

        // 버튼 1 레이아웃 설정
        button1.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(15)
            make.width.equalTo(40)
            make.height.equalTo(24)
            make.leading.equalToSuperview().offset(20)
        }

        // 버튼 2 레이아웃 설정
        button2.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(15)
            make.width.equalTo(40)
            make.height.equalTo(24)
            make.leading.equalTo(button1.snp.trailing).offset(8)
        }

        // 라벨 레이아웃 설정
        label.snp.makeConstraints { make in
            make.top.equalTo(button1.snp.bottom).offset(10)
            make.leading.equalTo(contentView).offset(20)
        }

        label2.snp.makeConstraints { make in
            make.top.equalTo(button1.snp.bottom).offset(10)
            make.leading.equalTo(label.snp.trailing).offset(5)
            make.trailing.equalTo(contentView).offset(-20)
        }

        // 더보기 레이아웃 설정
        showMoreButton.snp.makeConstraints { make in
            make.top.equalTo(label2.snp.bottom)
            make.height.equalTo(10)
            make.width.equalTo(60)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)

        }

    }

    // 이미지 배열 설정
    func setImages(_ imageList: [String]) {

        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        contentView.addSubview(pageControl)
        // 페이지 컨트로 레이아웃 설정
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
        }

        var lastImageView: UIImageView?
        pageControl.currentPage = 0
        print("magazine count : \(imageList.count)")
        pageControl.numberOfPages = imageList.count
        for resource in imageList {
            let imageView = UIImageView()
            let url = "\(Bundle.main.TEST_URL)/magazine\(resource)"
            print(url)
            imageView.loadImage2(from: url, resizedToWidth: UIScreen.main.bounds.width)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 16
            imageView.clipsToBounds = true

            imageScrollView.addSubview(imageView)

            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.height.width.equalTo(contentView.snp.width)

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

    func setText(magazine: MagazineList) {
        let writer = magazine.writer
        let contents = magazine.content
        button2.setTitle(String(magazine.comment_count), for: .normal)
        likeCounter = magazine.like_count ?? 0
        commentCounter = magazine.comment_count ?? 0
        label.text = writer
        label2.text = contents
        button1.setTitle("\(likeCounter)", for: .normal)
        let isLiked = magazine.isLiked ?? false
        if isLiked {
            button1.setImage(UIImage(named: "like_icon2"), for: .normal)
        } else {
            button1.setImage(UIImage(named: "like_icon"), for: .normal)
        }
        button2.setTitle("\(commentCounter)", for: .normal)
        button1.tag = magazine.no
        button2.tag = magazine.no
        updateMoreButtonVisibility()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        let currentPage = Int(round(contentOffsetX / scrollView.bounds.size.width))
        if self.currentPage != currentPage {
            self.currentPage = currentPage
            pageControl.currentPage = currentPage
        }
    }

    @objc private func moreButtonAction() {
        label2.numberOfLines = label2.numberOfLines == 0 ? 2 : 0
        moreButtonTapped?()  // 클로저 실행
    }

    private func updateMoreButtonVisibility() {
        // 라벨의 최대 높이 계산 (2줄의 높이)
        label2.numberOfLines = 2
        let maxSize = CGSize(width: label2.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = label2.sizeThatFits(maxSize)

        // 라벨이 2줄보다 많은 텍스트를 포함하는 경우에만 더보기 버튼 표시
        showMoreButton.isHidden = requiredSize.height <= label2.font.lineHeight * 2
    }

    @objc func button1Tapped(_ sender: UIButton) {

        sender.isSelected = !sender.isSelected
        let likeRequestDto = MagazineLikeDto(user_id: User.shared.id ?? "", magazine_id: sender.tag)
        // 상태에 따른 이미지 변경
        if sender.isSelected {
            sender.setImage(UIImage(named: "like_icon2"), for: .normal)
            likeCounter += 1
            sender.setTitle("\(likeCounter)", for: .normal)
            sendLikeRequest(likeRequestDto: likeRequestDto)
        } else {
            sender.setImage(UIImage(named: "like_icon"), for: .normal)
            likeCounter -= 1
            sender.setTitle("\(likeCounter)", for: .normal)
            sendUnlikeRequest(likeRequestDto: likeRequestDto)
        }
    }

    @objc private func button2Tapped(_ sender: UIButton) {
        onButton2Tapped?()
    }

    private func sendUnlikeRequest(likeRequestDto: MagazineLikeDto) {
        let url = "\(Bundle.main.TEST_URL)/magazine/like"
        AF.request(url, method: .delete, parameters: likeRequestDto, encoder: JSONParameterEncoder.default)
            .response { response in
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

    private func sendLikeRequest(likeRequestDto: MagazineLikeDto) {
        let url = "\(Bundle.main.TEST_URL)/magazine/like"
        AF.request(url, method: .post, parameters: likeRequestDto, encoder: JSONParameterEncoder.default)
            .response { response in
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
