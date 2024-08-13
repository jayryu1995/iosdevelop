//
//  DiscountTableViewCell.swift
//  ByahtColor
//
//  Created by jaem on 5/16/24.
//

import UIKit
import SnapKit
import AlamofireImage

class UserDiscountTableViewCell: UITableViewCell {
    weak var delegate: UserDiscountTableViewCellDelegate?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let formatter = ISO8601DateFormatter()
    var discountList: [DiscountDto] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 셀 레이아웃 설정
        backgroundColor = .white
        formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul") // DateFormatter의 시간대를 한국 시간대로 설정
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // 스크롤 뷰의 모든 이미지 뷰 제거
        contentView.subviews.forEach { $0.removeFromSuperview() }

    }

    func setupImageViews(list: [DiscountDto]) {
        discountList = list

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10

        contentView.addSubview(stackView)
        let widthSize = UIScreen.main.bounds.width/2 - 5
        let cellHeight = (widthSize) * 1.4
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        // list 배열의 각 요소에 대해 이미지 뷰를 생성하고 스택뷰에 추가
        for i in 0..<list.count { // 배열의 크기를 초과하지 않도록 하며, 최대 2개의 이미지만 추가
            let collectionCell  = UIView()
            collectionCell.tag = list[i].no!
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(collectionCellTapped))
            collectionCell.addGestureRecognizer(tapGesture)
            collectionCell.isUserInteractionEnabled = true
            stackView.addArrangedSubview(collectionCell)

            let widthSize = UIScreen.main.bounds.width/2 - 5
            collectionCell.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalTo(widthSize)
                make.height.equalTo(widthSize)
            }

            // URL 문자열을 URL 객체로 변환
            let url = "\(Bundle.main.TEST_URL)\( list[i].imageList?.first ?? "" )"
            let imageView = UIImageView()

            imageView.loadImage(from: url)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 4
            imageView.clipsToBounds = true

            collectionCell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(collectionCell.snp.width)
            }

            let koreaTimeZone = TimeZone(identifier: "Asia/Seoul")
            var calendar = Calendar.current
            calendar.timeZone = koreaTimeZone!

            if let endDateString = list[i].end_date,
               let endDate = formatter.date(from: endDateString) {
                let today = calendar.startOfDay(for: Date())
                let endDay = calendar.startOfDay(for: endDate)

                if today > endDay {
                    let stateView = UIView()
                    stateView.backgroundColor = UIColor(hex: "#00000080")
                    imageView.addSubview(stateView)
                    stateView.snp.makeConstraints {
                        $0.edges.equalToSuperview()
                    }

                    let label = UILabel()
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 8 // 원하는 행간격 설정

                    let attributedString = NSMutableAttributedString(string: "Event\nHết hạn", attributes: [
                        .paragraphStyle: paragraphStyle,
                        .font: UIFont(name: "Pretendard-Medium", size: 16)!,
                        .foregroundColor: UIColor.white
                    ])
                    label.attributedText = attributedString
                    label.numberOfLines = 0
                    label.textAlignment = .center
                    stateView.addSubview(label)
                    label.snp.makeConstraints {
                        $0.edges.equalToSuperview()
                    }
                }
            } else {
                print("Invalid date format or nil end_date")
            }

            let titleLabel = UILabel()
            titleLabel.text = list[i].title
            titleLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
            titleLabel.textColor = UIColor(hex: "#535358")
            titleLabel.numberOfLines = 2

            collectionCell.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).offset(5)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(30)
            }

            let dDayLabel = UILabel()
            dDayLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
            dDayLabel.textColor = UIColor(hex: "#535358")

            updateDDayLabel(label: dDayLabel, startDateString: list[i].start_date!, endDateString: list[i].end_date!)

            collectionCell.addSubview(dDayLabel)
            dDayLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(30)
            }

            if list[i].notification {
                let ivPin = UIImageView(image: UIImage(named: "icon_pin"))
                ivPin.contentMode = .scaleAspectFit
                collectionCell.addSubview(ivPin)
                ivPin.snp.makeConstraints {
                    $0.top.trailing.equalToSuperview().inset(10)
                }
            }
        }

        if list.count == 1 {
            let placeholderView = UIView()
            stackView.addArrangedSubview(placeholderView)
            placeholderView.snp.makeConstraints { make in
                make.width.equalTo(widthSize)
                make.height.equalTo(cellHeight)
            }
        }

    }

    @objc private func collectionCellTapped(_ sender: UITapGestureRecognizer) {
        let index = sender.view?.tag ?? -1
        if index >= 0 {
            delegate?.didTapCell(self, withNo: index)
        }
    }

    private func updateDDayLabel(label: UILabel, startDateString: String, endDateString: String) {
        if let startDate = formatter.date(from: startDateString),
           let endDate = formatter.date(from: endDateString) {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

            let today = calendar.startOfDay(for: Date())
            let endDay = calendar.startOfDay(for: endDate)
            let startDay = calendar.startOfDay(for: startDate)

            // startDate가 오늘 이후인 경우
            if today < startDay {
                label.text = "Upcoming"
            } else {
                let components = calendar.dateComponents([.day], from: today, to: endDay)
                if let dayCount = components.day {
                    if dayCount > 0 {
                        // 미래 날짜
                        label.text = "D-\(dayCount)"
                    } else if dayCount == 0 {
                        // 오늘 날짜
                        label.text = "D-Day"
                    } else {
                        // 과거 날짜
                        label.text = ""
                    }
                }
            }
        } else {
            label.text = "Invalid date format"
        }
    }
}
protocol UserDiscountTableViewCellDelegate: AnyObject {
    func didTapCell(_ cell: UserDiscountTableViewCell, withNo no: Int)
}
