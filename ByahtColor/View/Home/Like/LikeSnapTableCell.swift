//
//  LikeSnapTableCell.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/24.
//

import UIKit
import SnapKit
import Alamofire
import AlamofireImage

class LikeSnapTableCell: UITableViewCell {
    weak var delegate: LikeSnapTableViewCellDelegate?
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
        stackView.spacing = 10

        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(300)
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
                make.width.equalToSuperview().dividedBy(2).offset(-5)
                make.height.equalToSuperview()
            }
            let imageView = UIImageView()
            // URL 문자열을 URL 객체로 변환
            let path: String = list[i].imageList?.first ?? ""
            let url = "\(Bundle.main.TEST_URL)/image\( path )"
            print("path : \(path)")

            imageView.loadImage(from: url, resizedToWidth: widthSize)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 4
            imageView.clipsToBounds = true

            collectionCell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.7)
            }

            let deleteButton = UIButton()
            deleteButton.setImage(UIImage(named: "icon_close"), for: .normal)
            deleteButton.setTitleColor(.red, for: .normal)
            deleteButton.isHidden = true
            deleteButton.tag = list[i].no! // SnapDto의 고유한 값으로 태그 설정
            deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
            addSubview(deleteButton)
            deleteButton.snp.makeConstraints { make in
                // 삭제 버튼 위치 설정
                make.top.equalTo(imageView.snp.top)
                make.trailing.equalTo(imageView.snp.trailing)
                make.width.height.equalTo(60)
            }

        }

    }

    @objc func deleteButtonTapped(_ sender: UIButton) {
        delegate?.didTapDeleteButton(forCell: self)
    }

    @objc private func collectionCellTapped(_ sender: UITapGestureRecognizer) {

        let index = sender.view?.tag ?? -1
        print("sender : \(index)")
        if index >= 0 {
            delegate?.didTapCell(self, withNo: index)
        }
    }

}
protocol LikeSnapTableViewCellDelegate: AnyObject {
    func didTapCell(_ cell: LikeSnapTableCell, withNo no: Int)

    func didTapDeleteButton(forCell cell: LikeSnapTableCell)

}
