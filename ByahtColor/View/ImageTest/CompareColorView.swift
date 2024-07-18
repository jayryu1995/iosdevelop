//
//  CompareColorView.swift
//  ByahtColor
//
//  Created by jaem on 2023/12/27.
//

import UIKit
import SnapKit

class CompareColorView: UIViewController {

    private let imageView = UIImageView()
    private let selectLabel = UILabel()
    private let stageLabel = UILabel()
    private let colorButton1 = UIButton()
    private let colorButton2 = UIButton()
    private let nextButton = NextButton()
    private let WARMCOOL: [[UIColor]] = ColorPalettes.WARMCOOL
    private var stage = 1
    private var selectNumber = 0
    private var selectedList: [Int] = []

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
        // 뒤로 버튼
        setupBackButton()
        self.navigationItem.title = "Personal Color"
    }

    private func setupViews() {
        setImageView()
        setLabels()
        setColorButtons()
        setNextButton()
    }

    private func setNextButton() {
        nextButton.setTitle("Chọn", for: .normal)
        nextButton.addTarget(self, action: #selector(buttonNextTapped), for: .touchUpInside)
        nextButton.titleLabel?.textColor = .white
        nextButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        nextButton.layer.cornerRadius = 12
        view.addSubview(nextButton)
    }

    private func setLabels() {
        selectLabel.text = "Chọn tông ấm/tông lạnh"
        stageLabel.text = "\(stage) / 5"

        selectLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        stageLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        stageLabel.textColor = UIColor(hex: "#4E505B")

        view.addSubview(selectLabel)
        view.addSubview(stageLabel)

    }

    private func setColorButtons() {

        colorButton1.layer.cornerRadius = 20
        colorButton1.tag = 0
        colorButton1.backgroundColor = WARMCOOL[0][0]
        colorButton1.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        colorButton2.layer.cornerRadius = 20
        colorButton2.tag = 1
        colorButton2.backgroundColor = WARMCOOL[0][1]
        colorButton2.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        view.addSubview(colorButton1)
        view.addSubview(colorButton2)
    }

    private func setImageView() {
        imageView.backgroundColor = WARMCOOL[0][0]
        imageView.image = receiveImage
        imageView.contentMode = .center
        view.addSubview(imageView)
    }

    @objc private func buttonNextTapped() {
        selectedList.append(selectNumber)
        if stage < 5 {
            stage += 1
            print(stage)
            resetView()
        } else {
            let count = selectedList.filter {$0 == 0 }.count
            let vc = TestResultView()
            // 웜톤일 때
            if count > 2 {
                vc.seasonTon = "warm"
            } else {
                // 쿨톤일 때
                vc.seasonTon = "cool"
            }
            vc.receiveImage = self.receiveImage
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    @objc private func buttonTapped(_ sender: UIButton) {
        selectNumber = sender.tag

        // 모든 버튼의 테두리를 제거합니다.
        colorButton1.layer.borderWidth = 0
        colorButton2.layer.borderWidth = 0

        // 선택된 버튼에 테두리를 추가합니다.
        sender.layer.borderWidth = 5
        sender.layer.borderColor = UIColor(hex: "#935DFF").cgColor
        imageView.backgroundColor = sender.backgroundColor
    }

    private func resetView() {

        colorButton1.layer.borderWidth = 0
        colorButton2.layer.borderWidth = 0
        stageLabel.text = "\(stage) / 5"
        colorButton1.backgroundColor = WARMCOOL[stage-1][0]
        colorButton2.backgroundColor = WARMCOOL[stage-1][1]
        imageView.backgroundColor = WARMCOOL[stage-1][0]

    }

    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview().multipliedBy(0.6)
            make.leading.trailing.equalToSuperview()
        }

        selectLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.height.equalTo(20)
            make.leading.equalToSuperview().offset(30)
        }

        stageLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().inset(30)
        }

        let width = UIScreen.main.bounds.width/3.5
        colorButton1.snp.makeConstraints { make in
            make.top.equalTo(selectLabel.snp.bottom).offset(10)
            make.trailing.equalTo(view.snp.centerX).offset(-20)
            make.width.equalTo(width)
            make.bottom.equalToSuperview().multipliedBy(0.85)
        }

        colorButton2.snp.makeConstraints { make in
            make.top.equalTo(selectLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.centerX).offset(20)
            make.width.equalTo(width)
            make.bottom.equalToSuperview().multipliedBy(0.85)
        }

        nextButton.snp.makeConstraints { make in
            make.top.equalTo(colorButton1.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().multipliedBy(0.95)
        }
    }
}
