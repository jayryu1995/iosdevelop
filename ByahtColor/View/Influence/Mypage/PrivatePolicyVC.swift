//
//  PrivatePolicyVC.swift
//  ByahtColor
//
//  Created by jaem on 4/14/25.
//

import Foundation
import UIKit
import SnapKit

class PrivatePolicyVC : UIViewController {
    
    lazy private var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = true  // 세로 스크롤 표시 (원하면 false로)
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceVertical = true  // 스크롤 범위 안이어도 위아래로 바운스 허용
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var label = {
        let view = UILabel()
        view.font = UIFont(name: "Pretendard-Regular", size: 14)
        view.numberOfLines = 0
        view.text = "agree_1_1".localized
        return view
    }()
    
    lazy private var label2: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Pretendard-Regular", size: 14)
        view.numberOfLines = 0

        let text = "policy_label".localized
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont(name: "Pretendard-Regular", size: 14) as Any
        ]
        view.attributedText = NSAttributedString(string: text, attributes: attributes)

        return view
    }()
    
    override func viewDidLoad(){
        setupBackButton()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(label)
        contentView.addSubview(label2)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(label2Tapped))
        label2.isUserInteractionEnabled = true
        label2.addGestureRecognizer(tapGesture)
        setupConstraints()
    }
    
    @objc private func label2Tapped() {
        let logoutVC = LogoutVC() // 여기서 LogoutVC는 실제로 있는 뷰컨트롤러 이름
        self.navigationController?.pushViewController(logoutVC, animated: false)
    }
    
    private func setupConstraints(){
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width) // 🔥 이게 핵심: 가로 길이 고정
        }

        label.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        label2.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(64)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-25) // 🔥 마지막 요소는 bottom을 설정해야 scrollView가 정확히 인식함
        }
    }
}
