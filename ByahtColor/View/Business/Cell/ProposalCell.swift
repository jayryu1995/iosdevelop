//
//  ProposalCell.swift
//  ByahtColor
//
//  Created by jaem on 8/20/24.
//

import Foundation
import UIKit
import SnapKit

class ProposalCell: UITableViewCell {
    weak var delegate: ProposalCellDelegate?
    var imageTag = 0
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

    func setupImageViews(list: [InfluenceProfileDto], row: Int) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        let widthSize = UIScreen.main.bounds.width / 2 - 5
        let cellHeight = (widthSize) * 1.3
        list.enumerated().forEach { (index, item) in
            guard index < 2 else { return }
            
            let collectionCell = UIView()
            collectionCell.isUserInteractionEnabled = true
            stackView.addArrangedSubview(collectionCell)
            collectionCell.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalTo(widthSize)
                make.height.equalTo(cellHeight)
            }
            
            let imageView = GradientImageView(frame: .zero)
            if row == 0 {
                imageView.tag = index + row
            }else{
                imageView.tag = index + (row*2)
            }
            
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(collectionCellTapped))
            imageView.addGestureRecognizer(tapGesture)
            imageView.isUserInteractionEnabled = true
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 4
            collectionCell.addSubview(imageView)

            if let resource = item.imagePath {
                let str = resource.split(separator: ".").last ?? ""
                if str == "jpg" {
                    let url = "\(Bundle.main.TEST_URL)/img\(resource)"
                    imageView.loadImage(from: url)
                } else {
                    let path = "\(Bundle.main.TEST_URL)\(resource)"
                    CustomFunction().loadVideoThumbnail(imageView: imageView, path: path)
                }
            } else {
                imageView.image = UIImage(named: "sample_image")
            }

            let label = UILabel()
            label.text = item.name
            label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
            label.textColor = .white

            let iconView = UIStackView()
            iconView.axis = .horizontal
            iconView.distribution = .equalSpacing
            iconView.spacing = 8

            item.snsList?.forEach { it in
                var icon: UIImageView?
                switch it.sns {
                case 0: icon = UIImageView(image: UIImage(named: "tiktok"))
                case 1: icon = UIImageView(image: UIImage(named: "instagram"))
                case 2: icon = UIImageView(image: UIImage(named: "facebook"))
                case 3: icon = UIImageView(image: UIImage(named: "naver"))
                case 4: icon = UIImageView(image: UIImage(named: "youtube"))
                default: break
                }

                if let icon = icon {
                    icon.contentMode = .scaleAspectFit
                    icon.isUserInteractionEnabled = true
                    iconView.addArrangedSubview(icon)
                }
            }

            imageView.addSubview(iconView)
            imageView.addSubview(label)
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(cellHeight)
            }

            iconView.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().offset(-16)
                $0.height.equalTo(20)
                $0.width.lessThanOrEqualToSuperview()
            }

            label.snp.makeConstraints {
                $0.bottom.equalTo(iconView.snp.top).offset(-8)
                $0.leading.trailing.equalToSuperview().inset(16)
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
        if let imageView = sender.view as? UIImageView {
            let index = imageView.tag
            print(index)
            delegate?.didTapCell(self, withNo: index)
        }
    }

}

protocol ProposalCellDelegate: AnyObject {
    func didTapCell(_ cell: ProposalCell, withNo no: Int)
}
