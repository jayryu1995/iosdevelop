//
//  SecondOnboardingVC.swift
//  ByahtColor
//
//  Created by jaem on 7/30/24.
//

import UIKit
import SnapKit
import FLAnimatedImage

class SecondOnboardingVC: UIViewController {

    private let imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "onboarding_second_label".localized
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        label.textAlignment = .center
        return label
    }()

    private let label2: UILabel = {
        let label = UILabel()
        label.text = "onboarding_second_label2".localized
        label.textColor = UIColor(hex: "#009BF2")
        label.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupUI()
        setupConstraints()
        playGifVideo()
    }

    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(label2)
    }

    private func playGifVideo() {
        if let gifDataAsset = NSDataAsset(name: "onboarding") {
            let animatedImage = FLAnimatedImage(animatedGIFData: gifDataAsset.data)
            imageView.animatedImage = animatedImage
        } else {
            print("GIF 데이터를 불러오지 못했습니다.")
        }
    }

    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        label2.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(202)
        }
    }
}
