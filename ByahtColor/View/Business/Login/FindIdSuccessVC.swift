//
//  FindIdVC2.swift
//  ByahtColor
//
//  Created by jaem on 12/4/24.
//

import Foundation
import UIKit
import SnapKit

class FindIdSuccessVC: UIViewController {
    lazy private var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("로그인".localized, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()
    
    // 라벨 3개 추가
    private let label1: UILabel = {
        let label = UILabel()
        label.text = "아이디 확인"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let label2: UILabel = {
        let label = UILabel()
        label.text = "아래 아이디로 로그인해 주세요."
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(hex: "#4E505B")
        label.textAlignment = .left
        return label
    }()
    
    var label3: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 24)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "login_find_account".localized
        setupBackButton()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        // 기존 버튼 추가
        view.addSubview(button)
        
        // 라벨 추가
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        
        // 버튼 액션 추가
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        
        label1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(90)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        label2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(label1.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        label3.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(label2.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(label3.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
    }
    
    @objc private func submitButtonTapped() {
        // 버튼 동작 구현
        
    }
}

