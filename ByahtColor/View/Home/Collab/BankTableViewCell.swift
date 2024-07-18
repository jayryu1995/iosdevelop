//
//  BankTableViewCell.swift
//  ByahtColor
//
//  Created by jaem on 2024/03/06.
//

import UIKit
import SnapKit
import AlamofireImage

class BankTableViewCell: UITableViewCell {

    var label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 셀 레이아웃 설정
        backgroundColor = .white

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

}
