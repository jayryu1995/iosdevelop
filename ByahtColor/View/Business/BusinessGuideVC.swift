//
//  BusinessSample2VC.swift
//  ByahtColor
//
//  Created by jaem on 7/30/24.
//

import Foundation

import UIKit
import SnapKit
class BusinessSampleVC: UIViewController {

    private let containView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private let label = {
        let label = UILabel()
        label.text = "business_sample_label".localized
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.numberOfLines = 0
        return label
    }()

    private let icon: UIImageView = {
        let image = UIImageView(image: UIImage(named: "swipe_guide_icon"))
        image.contentMode = .scaleAspectFit
        return image
    }()

    private let icon2: UIImageView = {
        let image = UIImageView(image: UIImage(named: "swipe_guide_icon2"))
        image.contentMode = .scaleAspectFit
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupUI()
        setupConstraints()
        setupTapGesture()
    }

    private func setupUI() {
        view.addSubview(containView)
        containView.addSubview(label)
        view.addSubview(icon)
        view.addSubview(icon2)

    }

    private func setupConstraints() {
        containView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(52)
        }

        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }

        icon.snp.makeConstraints {
            $0.bottom.equalTo(containView.snp.top).offset(-20)
            $0.width.equalTo(130)
            $0.height.equalTo(80)
            $0.centerX.equalToSuperview()
        }

        icon2.snp.makeConstraints {
            $0.top.equalTo(containView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(130)
            $0.height.equalTo(80)
        }
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        UserDefaults.standard.setValue(1, forKey: "sample")
        dismiss(animated: true, completion: nil)
    }
}
