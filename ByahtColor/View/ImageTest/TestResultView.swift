//
//  TestResultView.swift
//  ByahtColor
//
//  Created by jaem on 2023/12/28.
//

import UIKit
import SnapKit

class TestResultView: UIViewController {

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
        if seasonTon == "warm"{
            label.text = "Bạn là tông ấm nha!"
            subLabel.text = "Mùa xuân hay mùa thu, cùng check xem sao"
        } else {
            label.text = "Bạn là tông lạnh nha!"
            subLabel.text = "Mùa hè hay mùa đông, cùng check xem sao"
        }
        label.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        label.textAlignment = .center

        subLabel.font = UIFont(name: "Pretendard-Regular", size: 20)
        subLabel.textAlignment = .center
        view.addSubview(label)
        view.addSubview(subLabel)

    }

    private func setImageView() {
        if seasonTon == "warm"{
            imageView.image = UIImage(named: "icon7736")
        } else {
            imageView.image = UIImage(named: "icon7737")
        }
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

    }

    @objc private func buttonNextTapped() {

        if receiveImage != nil {
            let vc = CompareColorView2()
            vc.receiveImage = self.receiveImage
            // 웜톤일 때
            vc.seasonTon = seasonTon
            if seasonTon == "warm"{
                vc.GETCOLOR = ColorPalettes.WARMCOLOR
            } else {
                vc.GETCOLOR = ColorPalettes.COOLCOLOR
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = CompareCameraView2()
            // 웜톤일 때
            vc.seasonTon = seasonTon
            if seasonTon == "warm"{
                vc.GETCOLOR = ColorPalettes.WARMCOLOR
            } else {
                vc.GETCOLOR = ColorPalettes.COOLCOLOR
            }
            self.navigationController?.pushViewController(vc, animated: true)
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
