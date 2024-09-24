//
//  BusinessThirdOnboardingVC.swift
//  ByahtColor
//
//  Created by jaem on 9/9/24.
//

import UIKit
import SnapKit

class BusinessThirdOnboardingVC: UIViewController {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "business_onboarding_third_label".localized
        label.textColor = UIColor(hex: "#009BF2")
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let label2: UILabel = {
        let label = UILabel()
        label.text = "business_onboarding_third_label2".localized
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let textView: UITextView = {
        let tv = UITextView()
        tv.textColor = .white
        tv.text = "onboarding_third_label3".localized
        tv.font = UIFont(name: "Pretendard-Regular", size: 14)
        tv.backgroundColor = UIColor(hex: "#009BF2")
        tv.layer.cornerRadius = 16
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tv.isEditable = false
        tv.textAlignment = .right
        tv.alpha = 0
        tv.sizeToFit()
        tv.transform = CGAffineTransform(translationX: 0, y: 50)
        return tv
    }()

    private let textView2: UITextView = {
        let tv = UITextView()
        tv.textColor = .white
        tv.text = "onboarding_third_label4".localized
        tv.font = UIFont(name: "Pretendard-Regular", size: 14)
        tv.backgroundColor = UIColor(hex: "#009BF2")
        tv.layer.cornerRadius = 16
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tv.isEditable = false
        tv.textAlignment = .right
        tv.sizeToFit()
        tv.alpha = 0
        tv.transform = CGAffineTransform(translationX: 0, y: 50)
        return tv
    }()

    private let textView3: UITextView = {
        let tv = UITextView()
        tv.textColor = .white
        tv.text = "onboarding_third_label5".localized
        tv.font = UIFont(name: "Pretendard-Regular", size: 14)
        tv.backgroundColor = UIColor(hex: "#009BF2")
        tv.layer.cornerRadius = 16
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tv.isEditable = false
        tv.textAlignment = .right
        tv.sizeToFit()
        tv.alpha = 0
        tv.transform = CGAffineTransform(translationX: 0, y: 50)
        return tv
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        animateTextViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.addSubview(label)
        view.addSubview(label2)
        view.addSubview(textView)
        view.addSubview(textView2)
        view.addSubview(textView3)
    }

    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview()
        }

        label2.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }

        // 텍스트 뷰의 동적 크기 조정을 위해 임시 프레임 설정
        let textViewSize = textView.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat.greatestFiniteMagnitude))
        textView.snp.makeConstraints { make in
            make.top.equalTo(label2.snp.bottom).offset(62)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(textViewSize.width)
            make.height.equalTo(textViewSize.height)
        }

        // 텍스트 뷰의 동적 크기 조정을 위해 임시 프레임 설정
        let textViewSize2 = textView2.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat.greatestFiniteMagnitude))
        textView2.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(textViewSize2.width)
            make.height.equalTo(textViewSize2.height)
        }

        // 텍스트 뷰의 동적 크기 조정을 위해 임시 프레임 설정
        let textViewSize3 = textView3.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat.greatestFiniteMagnitude))
        textView3.snp.makeConstraints { make in
            make.top.equalTo(textView2.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(textViewSize3.width)
            make.height.equalTo(textViewSize3.height)
        }
    }

    private func animateTextViews() {
        // 첫 번째 텍스트 뷰 애니메이션
        UIView.animate(withDuration: 0.3, delay: 0.4, options: [], animations: {
            self.textView.alpha = 1
            self.textView.transform = .identity // 원래 위치로 이동
        }, completion: { _ in
            // 두 번째 텍스트 뷰 애니메이션
            UIView.animate(withDuration: 0.3, delay: 0.4, options: [], animations: {
                self.textView2.alpha = 1
                self.textView2.transform = .identity // 원래 위치로 이동
            }, completion: { _ in
                // 세 번째 텍스트 뷰 애니메이션
                UIView.animate(withDuration: 0.3, delay: 0.4, options: [], animations: {
                    self.textView3.alpha = 1
                    self.textView3.transform = .identity // 원래 위치로 이동
                }, completion: nil)
            })
        })
    }
}
