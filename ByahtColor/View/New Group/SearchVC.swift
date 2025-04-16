//
//  SearchVC.swift
//  ByahtColor
//
//  Created by jaem on 4/15/25.
//

import Foundation
import UIKit
import SnapKit

class SearchVC : UIViewController {
    
    lazy private var label = {
        let view = UILabel()
        view.text = "가입한 기업을 위한 EVENT"
        view.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        view.textColor = UIColor(red: 0.938, green: 0.213, blue: 0.608, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    lazy private var label2 = {
        let view = UILabel()
        view.text = "내가 원하는 인플루언서, 더 있을까?\n문의 주시면 딱 맞는 포트폴리오 보내드릴게요."
        view.font = UIFont(name: "Pretendard-Medium", size: 16)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    lazy private var label3 = {
        let view = UILabel()
        view.text = "담당자 이메일을 입력해주세요."
        view.font = UIFont(name: "Pretendard-Regular", size: 14)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    lazy private var label4 = {
        let view = UILabel()
        view.text = "등록한 이메일로 크리에이터 정보를 \n빠르게 받아보실 수 있어요!🥳"
        view.font = UIFont(name: "Pretendard-Regular", size: 14)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    lazy private var icon = {
        let view = UIImageView(image: UIImage(named: "mail"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy private var backgroundImage = {
        let view = UIImageView(image: UIImage(named: "search_background"))
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy private var textField = {
        let view = UITextField()
        view.placeholder = "이메일 주소 입력"
        view.attributedPlaceholder = NSAttributedString(
                string: "이메일 주소 입력",
                attributes: [
                    .foregroundColor: UIColor(hex: "#B5B8C2"),
                    .font: UIFont.systemFont(ofSize: 16)
                ]
            )
        return view
    }()

    lazy private var radiusView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hex: "#B5B8C2").cgColor
        view.backgroundColor = .white
        return view
    }()
    
    lazy private var radiusButton = {
        let view = UIButton()
        view.layer.cornerRadius = 26
        view.backgroundColor = UIColor(hex: "#D3D4DA")
        view.setTitle("등록하기", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        view.isEnabled = false
        return view
    }()
    
    lazy private var starIcon = {
        let view = UIImageView(image: UIImage(named: "search_star"))
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    override func viewDidLoad(){
        
        hideKeyboard()
        view.addSubview(backgroundImage)
        view.addSubview(starIcon)
        view.addSubview(label)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(icon)
        view.addSubview(radiusButton)
        setupEmailView()
        setupConstraints()
    }
    
    private func setupEmailView(){
        view.addSubview(radiusView)
        radiusView.addSubview(textField)
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        textField.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupConstraints(){
        backgroundImage.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        starIcon.snp.makeConstraints{
            $0.top.equalTo(label.snp.top)
            $0.trailing.equalTo(label.snp.trailing)
            $0.width.equalTo(62)
            $0.height.equalTo(70)
        }
        
        icon.snp.makeConstraints {
            $0.width.equalTo(170)
            $0.height.equalTo(120)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.centerY)
        }
        
        label2.snp.makeConstraints{
            $0.bottom.equalTo(icon.snp.top).offset(-24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        label.snp.makeConstraints{
            $0.bottom.equalTo(label2.snp.top).offset(-24)
            $0.centerX.equalToSuperview()
        }
        
        label3.snp.makeConstraints{
            $0.top.equalTo(icon.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        radiusView.snp.makeConstraints{
            $0.top.equalTo(label3.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
        
        radiusButton.snp.makeConstraints{
            $0.top.equalTo(radiusView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
        
        label4.snp.makeConstraints{
            $0.top.equalTo(radiusButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let isEmpty = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        radiusButton.isEnabled = !isEmpty
        radiusButton.backgroundColor = isEmpty ? UIColor(hex: "#D3D4DA") : UIColor.black
    }
    
    @objc private func setRadiusButton(){
        print("button on!")
    }
}
