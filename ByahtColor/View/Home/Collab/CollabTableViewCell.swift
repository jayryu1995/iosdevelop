//
//  SnapTableViewCell.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/21.
//

import UIKit
import SnapKit
import AlamofireImage

class CollabTableViewCell: UITableViewCell {
    weak var delegate: CollabTableViewCellDelegate?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var snapList: [CollabDto] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 셀 레이아웃 설정
        backgroundColor = .white

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // 스크롤 뷰의 모든 이미지 뷰 제거
        contentView.subviews.forEach { $0.removeFromSuperview() }

    }

    func setupImageViews(list: [CollabDto]) {
        snapList = list
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
            let url = "\(Bundle.main.TEST_URL)/image\( list[i].imageList?.first ?? "" )"
            let imageView = UIImageView()
            imageView.loadImage(from: url, resizedToWidth: widthSize)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 4
            imageView.clipsToBounds = true

            collectionCell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(collectionCell.snp.width)
            }

            if list[i].state == false {
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

            let tagView = UILabel()
            tagView.text = list[i].title
            tagView.font = UIFont(name: "Pretendard-Regular", size: 12)
            tagView.textColor = UIColor(hex: "#535358")
            tagView.numberOfLines = 2
            collectionCell.addSubview(tagView)
            tagView.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).offset(5)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(30)
            }

            let likeCountView = UILabel()
            likeCountView.text = "\(list[i].like_count ?? 0)"
            likeCountView.font = UIFont(name: "Pretendard-Regular", size: 12)
            collectionCell.addSubview(likeCountView)
            likeCountView.snp.makeConstraints { make in
                make.top.equalTo(tagView.snp.bottom).offset(5)
                make.trailing.equalToSuperview()
            }

            let heartIcon = UIImageView(image: UIImage(named: "like_icon"))
            heartIcon.contentMode = .scaleAspectFit
            collectionCell.addSubview(heartIcon)
            heartIcon.snp.makeConstraints { make in
                make.top.equalTo(likeCountView.snp.top)
                make.trailing.equalTo(likeCountView.snp.leading)
                make.width.height.equalTo(16)
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

}
protocol CollabTableViewCellDelegate: AnyObject {
    func didTapCell(_ cell: CollabTableViewCell, withNo no: Int)
}
