//
//  DiscountDetailCell.swift
//  ByahtColor
//
//  Created by jaem on 5/17/24.
//

import UIKit
import SnapKit
import AlamofireImage
import Alamofire

class UserDiscountDetailCell: UITableViewCell, UIScrollViewDelegate {
    // 이미지 스크롤 뷰
    private let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "title"
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "context"
        label.textColor = UIColor(hex: "#4E505B")
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    private let dDayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true // 사용자 상호작용을 활성화합니다.
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = UIColor(hex: "#535358")
        return label
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        return pageControl
    }()

    let linkLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Liên kết shopee"
        label.isUserInteractionEnabled = true // 사용자 상호작용을 활성화합니다.
        label.textColor = UIColor(hex: "#935DFF")
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    private let ivPin: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "icon_pin"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private var linkUrl: String = ""
    private var currentPage: Int = 0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .white
        imageScrollView.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        linkLabel.addGestureRecognizer(tapGesture)

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(imageScrollView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dDayLabel)
        contentView.addSubview(pageControl)
        contentView.addSubview(linkLabel)
        contentView.addSubview(ivPin)

        imageScrollView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width)
        }

        ivPin.snp.makeConstraints {
            $0.top.trailing.equalTo(imageScrollView).inset(20)
            $0.width.height.equalTo(20)
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

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }

        linkLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }

        dDayLabel.snp.makeConstraints {
            $0.top.equalTo(linkLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }

    }

    // 이미지 배열 설정
    func setImages(_ imageList: [String]) {
        var lastImageView: UIImageView?
        pageControl.numberOfPages = imageList.count
        for resource in imageList {
            let imageView = UIImageView()
            let widthSize = UIScreen.main.bounds.width
            let url = "\(Bundle.main.TEST_URL)\( resource )"
            imageView.loadImage(from: url, resizedToWidth: widthSize)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.backgroundColor = .black
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

    func setText(it: DiscountDto) {
        titleLabel.text = it.title
        contentLabel.text = it.content
        linkUrl = it.link ?? ""
        print(it.link)
        if it.end_date != nil {
            updateDDayLabel(endDateString: it.end_date!)
        }
    }

    private func updateDDayLabel(endDateString: String) {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]

            if let endDate = formatter.date(from: endDateString) {
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: Date())
                let endDay = calendar.startOfDay(for: endDate)

                let components = calendar.dateComponents([.day], from: today, to: endDay)
                if let dayCount = components.day {
                    if dayCount > 0 {
                        // 미래 날짜
                        dDayLabel.text = "D-\(dayCount)"
                    } else if dayCount < 0 {
                        // 과거 날짜
                        dDayLabel.text = "D+\(-dayCount)"
                    } else {
                        // 오늘 날짜
                        dDayLabel.text = "D-Day"
                    }
                }
            } else {
                dDayLabel.text = "Invalid date format"
            }
        }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        let currentPage = Int(round(contentOffsetX / scrollView.bounds.size.width))
        if self.currentPage != currentPage {
            self.currentPage = currentPage
            pageControl.currentPage = currentPage
        }
    }

    // UILabel 탭 이벤트 처리기
    @objc private func labelTapped() {
        if let url = URL(string: linkUrl) {
            print(linkUrl)
            UIApplication.shared.open(url)
        }
    }
}
