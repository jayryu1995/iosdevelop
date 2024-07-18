//
//  MyPageVC.swift
//  ByahtColor
//
//  Created by jaem on 3/28/24.
//

import Foundation
import Alamofire
import UIKit
import SnapKit
import FBSDKLoginKit
import FBSDKCoreKit

class MyPageVC: UIViewController {

    private let btnCollab: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Tình trạng đăng ký"
        config.baseForegroundColor = .white // 타이틀 색상
        config.image = UIImage(named: "icon_hand") // 이미지 설정
        config.imagePlacement = .leading // 이미지를 타이틀의 앞(왼쪽)에 위치
        config.imagePadding = 8 // 이미지와 타이틀 사이의 간격
        config.background.cornerRadius = 4
        config.background.backgroundColor = .black // 버튼 배경 색상 설정

        let button = UIButton(configuration: config, primaryAction: nil)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 16)

        return button
    }()

    private let btnAccount: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Account"
        config.baseForegroundColor = .black // 타이틀 색상
        config.image = UIImage(named: "icon_setting") // 이미지 설정
        config.imagePlacement = .leading // 이미지를 타이틀의 앞(왼쪽)에 위치
        config.imagePadding = 8 // 이미지와 타이틀 사이의 간격
        config.background.cornerRadius = 4
        config.background.strokeColor = UIColor(hex: "#F7F7F7")
        config.background.backgroundColor = .white // 버튼 배경 색상 설정

        let button = UIButton(configuration: config, primaryAction: nil)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 16)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setButtons()
    }

    private func setButtons() {
        // btnCollab 설정
        btnCollab.addTarget(self, action: #selector(collabButtonTapped), for: .touchUpInside)
        view.addSubview(btnCollab)

        // btnAccount 설정
        btnAccount.addTarget(self, action: #selector(accountButtonTapped), for: .touchUpInside)
        view.addSubview(btnAccount)

        btnCollab.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-50)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(64)
        }

        btnAccount.snp.makeConstraints {
            $0.top.equalTo(btnCollab.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(64)
        }
    }

    @objc func collabButtonTapped() {
        let vc = ApplicationStateVC()
        self.navigationController?.pushViewController(vc, animated: false)

    }

    @objc func accountButtonTapped() {
        let vc = MyAccountVC()
        self.navigationController?.pushViewController(vc, animated: false)

    }
}
