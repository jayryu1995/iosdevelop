//
//  MyFollowVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/25.
//

import UIKit
import SnapKit

class MyPostsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }

    private func setupView() {
        let stackView = createStackView()
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }

        let commentView = createItemView(iconName: "icon_comment", labelText: "댓글 단 글 보기")
        commentView.isHidden = true
        let personalColorView = createItemView(iconName: "icon_personal", labelText: "Thử test màu sắc cá nhân của mình nào")

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(personalColorViewTapped))
        personalColorView.addGestureRecognizer(tapGesture)
        personalColorView.isUserInteractionEnabled = true

        stackView.addArrangedSubview(commentView)
        stackView.addArrangedSubview(personalColorView)

        [commentView, personalColorView].forEach { view in
            view.snp.makeConstraints {
                $0.height.equalTo(30)
            }
        }
    }

    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }

    private func createItemView(iconName: String, labelText: String) -> UIView {
        let containerView = UIView()

        // 레이어 뷰 설정
        let layerView = UIView()
        layerView.layer.cornerRadius = 10
        layerView.layer.borderWidth = 1
        layerView.layer.borderColor = UIColor(hex: "#F7F7F7").cgColor
        layerView.backgroundColor = .white

        let iconImageView = UIImageView(image: UIImage(named: iconName))
        iconImageView.contentMode = .scaleAspectFit

        let label = UILabel()
        label.text = labelText
        label.font = UIFont(name: "Pretendard-Regular", size: 16)

        containerView.addSubview(iconImageView)
        containerView.addSubview(label)
        containerView.addSubview(layerView)

        layerView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }

        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
        }

        label.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }

        return containerView
    }

    @objc private func personalColorViewTapped() {
        let vc = TestResultView3()
        vc.seasonTon = User.shared.color ?? "Spring Light"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
