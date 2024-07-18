//
//  TestResultView2.swift
//  ByahtColor
//
//  Created by jaem on 2023/12/28.
//

import UIKit
import SnapKit

class TestResultView2: UIViewController {

    private let imageView = UIImageView()
    private let label = UILabel()
    private let subLabel = UILabel()
    private let nextButton = NextButton()
    var seasonTon = ""
    var receiveImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        view.backgroundColor = .white
        // 처음으로 버튼
        if receiveImage != nil {
            setupPopButton()
        } else {
            setupPopButton2()
        }
        self.navigationItem.title = "Personal Color"
    }

    private func setupViews() {
        setImageView()
        setLabels()
        setButton()

    }

    private func setButton() {
        nextButton.setTitle("Tiếp", for: .normal)
        nextButton.addTarget(self, action: #selector(buttonNextTapped), for: .touchUpInside)
        view.addSubview(nextButton)
    }

    private func setLabels() {
        switch seasonTon {
        case "spring":
            label.text = "Bạn là màu xuân nè"

        case "summer":
            label.text = "Bạn là màu hè nè"

        case "autumn":
            label.text = "Bạn là màu thu nè"

        case "winter":
            label.text = "Bạn là màu đông nè"

        default: print("TestResultView2 switch case Error!")

        }
        subLabel.text = "Cùng tìm hiểu về tông màu của bạn nào"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        label.textAlignment = .center

        subLabel.font = UIFont(name: "Pretendard-Regular", size: 20)
        subLabel.textAlignment = .center
        view.addSubview(label)
        view.addSubview(subLabel)

    }

    private func setImageView() {
        switch seasonTon {
        case "spring": imageView.image = UIImage(named: "icon7397")
        case "summer": imageView.image = UIImage(named: "icon7740")
        case "autumn": imageView.image = UIImage(named: "icon7738")
        case "winter": imageView.image = UIImage(named: "icon7739")
        default: print("TestResultView2 setImageView switch case Error!")
        }
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

    }

    @objc private func buttonNextTapped() {
        if self.receiveImage != nil {
            switch seasonTon {
            case "spring":
                let vc = CompareColorView3()
                vc.GETCOLOR = ColorPalettes.SPRINGCOLOR
                vc.seasonTon = seasonTon
                vc.receiveImage = receiveImage
                self.navigationController?.pushViewController(vc, animated: true)

            case "summer":
                let vc = CompareColorView31()
                vc.GETCOLOR = ColorPalettes.SUMMERCOLOR
                vc.seasonTon = seasonTon
                vc.receiveImage = receiveImage
                self.navigationController?.pushViewController(vc, animated: true)

            case "autumn":
                let vc = CompareColorView31()
                vc.GETCOLOR = ColorPalettes.AUTUMNCOLOR
                vc.seasonTon = seasonTon
                vc.receiveImage = receiveImage
                self.navigationController?.pushViewController(vc, animated: true)

            case "winter":
                let vc = CompareColorView3()
                vc.GETCOLOR = ColorPalettes.WINTERCOLOR
                vc.receiveImage = receiveImage
                vc.seasonTon = seasonTon
                self.navigationController?.pushViewController(vc, animated: true)
            default: print("TestResultView2 buttonNextTapped switch Error")
            }
        } else {
            switch seasonTon {
            case "spring":
                let vc = CompareCameraView3()
                vc.GETCOLOR = ColorPalettes.SPRINGCOLOR
                vc.seasonTon = seasonTon
                self.navigationController?.pushViewController(vc, animated: true)

            case "summer":
                let vc = CompareCameraView31()
                vc.GETCOLOR = ColorPalettes.SUMMERCOLOR
                vc.seasonTon = seasonTon
                self.navigationController?.pushViewController(vc, animated: true)

            case "autumn":
                let vc = CompareCameraView31()
                vc.GETCOLOR = ColorPalettes.AUTUMNCOLOR
                vc.seasonTon = seasonTon
                self.navigationController?.pushViewController(vc, animated: true)

            case "winter":
                let vc = CompareCameraView3()
                vc.GETCOLOR = ColorPalettes.WINTERCOLOR
                vc.seasonTon = seasonTon
                self.navigationController?.pushViewController(vc, animated: true)

            default: print("TestResultView2 buttonNextTapped switch Error")
            }
        }

    }

    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom).multipliedBy(0.25)
            make.bottom.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        subLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        nextButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom).multipliedBy(0.85).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().multipliedBy(0.95)
        }
    }

}
