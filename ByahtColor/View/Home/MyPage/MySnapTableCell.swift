//
//  MySnapTableCell.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/25.
//

import UIKit
import SnapKit
import Alamofire
import AlamofireImage

class MySnapTableCell: UITableViewCell {
    weak var delegate: MySnapTableCellViewCellDelegate?
    var snapList: [CollabDto] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 셀 레이아웃 설정
        backgroundColor = .white

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupImageViews(list: [CollabDto]) {
        snapList = list
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 1

        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview()

        }
        let imageSideLength = (UIScreen.main.bounds.width - 3) / 3 // 화면 너비에 따라 이미지 크기 계산
        let imageHeight = imageSideLength * 1.4
        // list 배열의 각 요소에 대해 이미지 뷰를 생성하고 스택뷰에 추가
        for i in 0..<list.count { // 배열의 크기를 초과하지 않도록 하며, 최대 2개의 이미지만 추가
            let collectionCell  = UIView()
            collectionCell.tag = list[i].no!
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(collectionCellTapped))
            collectionCell.addGestureRecognizer(tapGesture)
            collectionCell.isUserInteractionEnabled = true
            stackView.addArrangedSubview(collectionCell)
            collectionCell.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalTo(imageSideLength)
                make.height.equalToSuperview().offset(-1) // 위아래 간격
            }
            let imageView = UIImageView()
            // URL 문자열을 URL 객체로 변환
            let path: String = list[i].imageList?.first ?? ""
            let url = "\(Bundle.main.TEST_URL)/image\( path )"

            imageView.loadImage(from: url, resizedToWidth: imageSideLength)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            collectionCell.addSubview(imageView)

            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalTo(imageSideLength)
                make.height.equalToSuperview()
            }

        }

    }

    @objc private func collectionCellTapped(_ sender: UITapGestureRecognizer) {

        let index = sender.view?.tag ?? -1
        print("sender : \(index)")
        if index >= 0 {
            delegate?.didTapCell(self, withNo: index)
        }
    }

}
protocol MySnapTableCellViewCellDelegate: AnyObject {
    func didTapCell(_ cell: MySnapTableCell, withNo no: Int)

}
