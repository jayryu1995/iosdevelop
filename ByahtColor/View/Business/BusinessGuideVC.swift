//
//  BusinessGuideVC.swift
//  ByahtColor
//
//  Created by jaem on 7/30/24.
//

import Foundation

import UIKit
import SnapKit
class BusinessGuideVC: UIViewController {

    private let containImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "background_label"))
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    private let label = {
        let label = UILabel()
        label.text = "business_sample_chat".localized
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.numberOfLines = 0
        return label
    }()

    private let icon: UIImageView = {
        let image = UIImageView(image: UIImage(named: "chat_button"))
        image.contentMode = .scaleAspectFit
        return image
    }()

    var onDismiss: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        setupUI()
        setupConstraints()
        setupTapGesture()
    }

    private func setupUI() {
        view.addSubview(containImage)
        containImage.addSubview(label)
        view.addSubview(icon)

    }

    private func setupConstraints() {
        containImage.snp.makeConstraints {
            $0.width.equalTo(264)
            $0.height.equalTo(83)
            $0.bottom.equalTo(icon.snp.top).offset(-10)
            $0.trailing.equalToSuperview().inset(32)
        }

        label.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(20)
        }

        icon.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(69)
            $0.width.height.equalTo(80)
        }

    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        dismiss(animated: false) { [weak self] in
            self?.onDismiss?()
        }
    }
}
