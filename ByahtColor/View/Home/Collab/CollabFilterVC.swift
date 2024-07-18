//
//  SnapFilterVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/22.
//

import UIKit
import SnapKit
import Alamofire
class CollabFilterVC: UIViewController {
    weak var delegate: CollabFilterVCDelegate?
    let titleLabel = UILabel()
    private let viewLayer: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(hex: "#F7F7F7").cgColor
        view.layer.borderWidth = 1
        return view
    }()

    let containLabel: UILabel = {
       let label = UILabel()
        label.text = "CATEGORY"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    let containLabel2: UILabel = {
       let label = UILabel()
        label.text = "SNS"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    let selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("Áp dụng nào", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.backgroundColor = UIColor.black
        button.setImage(UIImage(named: "icon_search"), for: .normal)
        button.layer.cornerRadius = 4
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()

    // 선택된 버튼들을 저장할 배열
    private var selectedButtons = [String]()
    private var selectedSns = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setTitleLabel()

        view.addSubview(viewLayer)
        viewLayer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        setFilterView()
        setSelectButton()
    }

    private func setSelectButton() {
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        view.addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
    }

    private func setFilterView() {
        let styleTags = ["Beauty", "Fashion", "Etc"]
        let styleFilterViewContainer = styleFilterView(tags: styleTags)
        view.addSubview(styleFilterViewContainer)
        styleFilterViewContainer.snp.makeConstraints {
            $0.top.equalTo(viewLayer.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }

        let snsTags = ["TikTok", "Instagram", "Facebook", "Shopee"]
        let snsFilterViewContainer = snsFilterView(tags: snsTags)
        view.addSubview(snsFilterViewContainer)
        snsFilterViewContainer.snp.makeConstraints {
            $0.top.equalTo(styleFilterViewContainer.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }

    private func setTitleLabel() {
        titleLabel.text = "Filter"
        titleLabel.font = UIFont(name: "Pretendard-Medium", size: 14)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    // 이 함수는 태그 이름의 배열을 받아서 수평 스택뷰를 생성하고 반환합니다.
    private func createHorizontalStackView(tags: [String]) -> UIStackView {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillProportionally
        horizontalStackView.alignment = .fill
        horizontalStackView.spacing = 10
        horizontalStackView.isUserInteractionEnabled = true

        for tagName in tags {
            let tagButton = UIButton()
            tagButton.setTitle(tagName, for: .normal)
            tagButton.backgroundColor = .white
            tagButton.setTitleColor(.black, for: .normal)
            if tags.count > 3 {
                tagButton.addTarget(self, action: #selector(snsButtonTapped), for: .touchUpInside)
            } else {
                tagButton.addTarget(self, action: #selector(tagButtonTapped), for: .touchUpInside)
            }

            tagButton.isUserInteractionEnabled = true
            tagButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
            tagButton.layer.cornerRadius = 16
            tagButton.layer.borderWidth = 1
            tagButton.layer.borderColor = UIColor.darkGray.cgColor
            horizontalStackView.addArrangedSubview(tagButton)

        }

        return horizontalStackView
    }

    // 이 함수는 전체 스타일 필터 뷰를 생성하고 반환합니다.
    private func styleFilterView(tags: [String]) -> UIView {
        let container = UIView()
        container.isUserInteractionEnabled = true

        container.addSubview(containLabel)
        containLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
        }

        let verticalStackView = UIStackView()

        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalSpacing
        verticalStackView.alignment = .fill
        verticalStackView.spacing = 10
        verticalStackView.isUserInteractionEnabled = true

        let firstRowStackView = createHorizontalStackView(tags: Array(tags.prefix(4)))

        firstRowStackView.isUserInteractionEnabled = true
        verticalStackView.addArrangedSubview(firstRowStackView)
        container.addSubview(verticalStackView)

        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(containLabel.snp.bottom).offset(10)
            $0.height.equalTo(32)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        return container
    }

    private func snsFilterView(tags: [String]) -> UIView {
        let container = UIView()
        container.isUserInteractionEnabled = true

        container.addSubview(containLabel2)
        containLabel2.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
        }

        let verticalStackView = UIStackView()

        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalSpacing
        verticalStackView.alignment = .fill
        verticalStackView.spacing = 10
        verticalStackView.isUserInteractionEnabled = true

        let firstRowStackView = createHorizontalStackView(tags: Array(tags.prefix(4)))

        firstRowStackView.isUserInteractionEnabled = true
        verticalStackView.addArrangedSubview(firstRowStackView)
        container.addSubview(verticalStackView)

        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(containLabel2.snp.bottom).offset(10)
            $0.height.equalTo(32)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        return container
    }

    @objc func tagButtonTapped(_ sender: UIButton) {
        let filter = sender.titleLabel?.text ?? ""
        if sender.isSelected {
            // 버튼이 이미 선택된 상태라면, 선택 해제
            sender.isSelected = false
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            if let index = selectedButtons.firstIndex(of: filter) {
                selectedButtons.remove(at: index)
            }
        } else {
            // 버튼이 선택되지 않은 상태라면
            if selectedButtons.count < 2 {
                // 선택된 버튼이 두 개 미만인 경우에만 선택
                sender.isSelected = true
                sender.backgroundColor = .black
                sender.setTitleColor(.white, for: .normal)
                selectedButtons.append(filter)
            }
        }
    }

    @objc func snsButtonTapped(_ sender: UIButton) {
        let filter = sender.titleLabel?.text ?? ""
        if sender.isSelected {
            // 버튼이 이미 선택된 상태라면, 선택 해제
            sender.isSelected = false
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            if let index = selectedSns.firstIndex(of: filter) {
                selectedSns.remove(at: index)
            }
        } else {

            // 선택된 버튼이 두 개 미만인 경우에만 선택
            sender.isSelected = true
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            selectedSns.append(filter)

        }
    }

    @objc private func selectButtonTapped() {

        delegate?.didTapButton(self, WithArray: selectedButtons, WithArray2: selectedSns)
        dismiss(animated: true)
    }
}

protocol CollabFilterVCDelegate: AnyObject {
    func didTapButton(_ snapVC: CollabFilterVC, WithArray array: [String], WithArray2 array2: [String])
}
