//
//  SearchVC.swift
//  ByahtColor
//
//  Created by jaem on 4/15/25.
//  Refactored by ChatGPT on 4/29/25.
//

import UIKit
import SnapKit
import KakaoSDKTalk
class SearchVC: UIViewController {
    
    // MARK: – UI Properties
    
    private lazy var label: UILabel = {
        let view = UILabel()
        view.text = "business_search_label".localized
        view.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        view.textColor = UIColor(hex: "#136CF3")
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var label2: UILabel = {
        let view = UILabel()
        view.text = "business_search_label2".localized
        view.font = UIFont(name: "Pretendard-Medium", size: 16)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var icon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_post"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var radiusButton: UIView = {
        // 1) 컨테이너 뷰
        let container = UIView()
        container.backgroundColor = .black
        container.layer.cornerRadius = 26
        container.isUserInteractionEnabled = true

        // 2) 아이콘과 레이블
        let iconView = UIImageView(image: UIImage(named: "kakaotalk"))
        iconView.contentMode = .scaleAspectFit
        iconView.snp.makeConstraints {
            $0.width.height.equalTo(24)  // 24×24 고정
        }

        let label = UILabel()
        label.text = "business_search_button".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = .white

        // 3) 스택뷰 생성
        let hStack = UIStackView(arrangedSubviews: [iconView, label])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 8

        // 4) 컨테이너에 스택뷰 추가 및 제약
        container.addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.center.equalToSuperview()           // 컨테이너 안에서 완전 중앙 정렬
            $0.leading.greaterThanOrEqualToSuperview().inset(16) // 좌우 최소 여백
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }

        // 5) 컨테이너 높이 고정
        container.snp.makeConstraints {
            $0.height.equalTo(52)
        }

        // 6) 탭 제스처 연결
        let tap = UITapGestureRecognizer(target: self, action: #selector(setRadiusButton))
        container.addGestureRecognizer(tap)

        return container
    }()
    
    // MARK: – Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        setupAppearance()
        setupLayout()
        
    }
    
}

// MARK: – Appearance (add subviews & initial setup)

private extension SearchVC {
    func setupAppearance() {
        
        view.addSubview(label)
        view.addSubview(label2)
        view.addSubview(icon)
        view.addSubview(radiusButton)
    }
}

// MARK: – Layout (SnapKit constraints)

private extension SearchVC {
    func setupLayout() {
       
        
        icon.snp.makeConstraints {
            $0.width.equalTo(125)
            $0.height.equalTo(120)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(-10)
        }
        
        label2.snp.makeConstraints {
            $0.bottom.equalTo(icon.snp.top).offset(-24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        label.snp.makeConstraints {
            $0.bottom.equalTo(label2.snp.top).offset(-24)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        radiusButton.snp.makeConstraints {
            $0.top.equalTo(icon.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
        
    }
}

// MARK: – Actions (targets & handlers)

private extension SearchVC {
    @objc func setRadiusButton() {
        let channelId = "_xnjqxhn"
        let appURL = URL(string: "kakaoplus://plusfriend/home/\(channelId)")!
        let webURL = URL(string: "https://pf.kakao.com/\(channelId)")!
        
        if UIApplication.shared.canOpenURL(appURL) {
            // 카카오톡 설치됨 → 앱으로 바로 이동
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            // 설치 안 됨 → 웹 브라우저로 이동
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
}
