//
//  CompareColorView3.swift
//  ByahtColor
//
//  Created by jaem on 2023/12/28.
//

import UIKit
import SnapKit

class CompareColorView3: UIViewController {

    private let imageView = UIImageView()
    private let selectLabel = UILabel()
    private let stageLabel = UILabel()
    private let colorButton1 = UIButton()
    private let colorButton2 = UIButton()
    private let nextButton = NextButton()
    private var stage = 1
    private var selectNumber = 0
    private var selectedList: [Int] = []
    var seasonTon = ""
    var receiveImage: UIImage?
    var GETCOLOR: [[UIColor]] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        print("seasonTon: \(seasonTon)")
        print("GETCOLOR.count : \(GETCOLOR.count)")
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
        selectLabel.text = "Chọn độ sáng"

        stageLabel.text = "\(stage) / \(GETCOLOR.count)"
        selectLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        stageLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        stageLabel.textColor = UIColor(hex: "#4E505B")

        view.addSubview(selectLabel)
        view.addSubview(stageLabel)

    }

    private func setColorButtons() {

        colorButton1.layer.cornerRadius = 20
        colorButton1.tag = 0
        colorButton1.backgroundColor = GETCOLOR[0][0]
        colorButton1.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        colorButton2.layer.cornerRadius = 20
        colorButton2.tag = 1
        colorButton2.backgroundColor = GETCOLOR[0][1]
        colorButton2.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        view.addSubview(colorButton1)
        view.addSubview(colorButton2)
    }

    private func setImageView() {
        imageView.backgroundColor = GETCOLOR[0][0]
        imageView.image = receiveImage
        imageView.contentMode = .center
        view.addSubview(imageView)
    }

    @objc private func buttonNextTapped() {
        selectedList.append(selectNumber)
        if stage < GETCOLOR.count {
            stage += 1
            print(stage)
            resetView()
        } else {

            var frequency: [Int: Int] = [:]

            // 각 요소의 출현 횟수를 계산합니다.
            for number in selectedList {
                frequency[number, default: 0] += 1
            }
            let resultMapping: [Int: [String: String]] = [
                0: ["spring": "Spring Light", "winter": "Winter Deep"],
                1: ["spring": "Spring Bright", "winter": "Winter Bright"]
            ]

            // 가장 많이 출현한 요소와 그 횟수를 찾습니다.
            if let mostFrequentNumber = frequency.max(by: { $0.value < $1.value })?.key {
                let result = resultMapping[mostFrequentNumber]?[seasonTon] ?? "CompareView31 Error"
                let vc = TestResultView3()
                vc.seasonTon = result
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                print("리스트가 비어 있습니다.")
            }
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
        stageLabel.text = "\(stage) / \(GETCOLOR.count)"
        colorButton1.backgroundColor = GETCOLOR[stage-1][0]
        colorButton2.backgroundColor = GETCOLOR[stage-1][1]
        imageView.backgroundColor = GETCOLOR[stage-1][0]

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
