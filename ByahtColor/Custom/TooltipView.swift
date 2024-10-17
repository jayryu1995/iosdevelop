//
//  TooltipView.swift
//  ByahtColor
//
//  Created by jaem on 9/25/24.
//

import UIKit

class TooltipView: UIView {

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        return label
    }()
    
    private let arrowHeight: CGFloat = 10
    private let arrowWidth: CGFloat = 20

    init(message: String) {
        super.init(frame: .zero)
        self.messageLabel.text = message
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .clear
        
        let contentView = UIView()
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        self.addSubview(contentView)
        contentView.addSubview(messageLabel)
        
        // SnapKit constraints
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: arrowHeight, right: 0))
        }
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        }
    }

    override func draw(_ rect: CGRect) {
        // 삼각형 그리기
        let path = UIBezierPath()
        let startPoint = CGPoint(x: (self.bounds.width - arrowWidth) / 2, y: self.bounds.height - arrowHeight)
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: startPoint.x + arrowWidth, y: startPoint.y))
        path.addLine(to: CGPoint(x: startPoint.x + arrowWidth / 2, y: startPoint.y + arrowHeight))
        path.close()

        UIColor.black.setFill()
        path.fill()
    }
}
