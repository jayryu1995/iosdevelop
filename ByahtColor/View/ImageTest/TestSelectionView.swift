//
//  TestSelectionView.swift
//  ByahtColor
//
//  Created by jaem on 2023/12/26.
//

import SnapKit
import UIKit

class TestSelectionView: UIViewController {

    // 상단 뷰
    private let registerView = UIView()
    private let gradientImageView = UIImageView()
    private let arrowImageView = UIImageView()
    private let actionLabel = UILabel()
    private let stackView = UIStackView()

    // 하단 뷰
    private let contentView = UIView()
    private let topView = UIView()
    private let topTitleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let rainbowImageView = UIImageView()
    private let contentStackView = UIStackView()
    private let cardsStackView = UIStackView()
    private let cardsStackView2 = UIStackView()

    var receiveImage: UIImage?
    var originImage: UIImage?
    var cropRect: CGRect!

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
        setupRegistView()
        setupContentView()
    }

    // 하단 뷰 배경
    private func setupContentView() {
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = UIColor(hex: "#F4F5F8")
        view.addSubview(contentView)

        setupContentStackViews()

    }

    // 하단 뷰 생성
    private func setupContentStackViews() {
        contentStackView.axis = .vertical
        contentStackView.distribution = .fillProportionally

        contentStackView.spacing = 10
        contentView.addSubview(contentStackView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topViewTapped))
        topView.addGestureRecognizer(tapGesture)
        topView.isUserInteractionEnabled = true
        topView.clipsToBounds = true
        topView.layer.cornerRadius = 20
        topView.backgroundColor = .white

        // 상단 뷰 설정
        topTitleLabel.text = "Test Màu Sắc Cá Nhân"
        topTitleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        subTitleLabel.text = "Xuân / Hè / Thu / Đông"
        subTitleLabel.font = UIFont(name: "Pretendard-Regular", size: 14)

        // 레인보우 이미지 설정
        rainbowImageView.image = UIImage(named: "rainbow") // 적절한 이미지를 프로젝트에 추가해야 합니다.
        rainbowImageView.contentMode = .scaleAspectFit

        topView.addSubview(topTitleLabel)
        topView.addSubview(subTitleLabel)
        topView.addSubview(rainbowImageView)

        topTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(topView).offset(20)
            make.leading.equalTo(topView).offset(20)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(topTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(topView).offset(20)
        }

        rainbowImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(topView).offset(10)
        }

        contentStackView.addArrangedSubview(topView)

        // 카드들을 위한 그리드 형태의 수직 스택 뷰 생성
        cardsStackView.axis = .horizontal
        cardsStackView.distribution = .fillEqually
        cardsStackView.spacing = 10

        cardsStackView2.axis = .horizontal
        cardsStackView2.distribution = .fillEqually
        cardsStackView2.spacing = 10

        let seasons = ["Xuân", "Hè", "Thu", "Đông"]
        let descriptions = ["Ôn hoà /\nDịu dàng", "Mát mẻ /\nTao nhã", "Ấm áp /\nTự nhiên", "Mạnh mẽ /\nHiện đại"]
        let icons = ["tulip", "umbrella", "maple", "snow"]

        for i in 0..<seasons.count {
            if i < 2 {
                let cardView = createCardView(title: seasons[i], description: descriptions[i], iconName: icons[i], tag: i)
                cardsStackView.addArrangedSubview(cardView)
            } else {
                let cardView = createCardView(title: seasons[i], description: descriptions[i], iconName: icons[i], tag: i)
                cardsStackView2.addArrangedSubview(cardView)
            }
        }

        contentStackView.addArrangedSubview(cardsStackView)
        contentStackView.addArrangedSubview(cardsStackView2)
    }

    private func setupRegistView() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(registerViewTapped))
        registerView.addGestureRecognizer(tapGesture)

        registerView.backgroundColor = .white
        registerView.layer.cornerRadius = 16
        registerView.layer.borderWidth = 1
        registerView.layer.borderColor = UIColor(hex: "#F4F5F8").cgColor
        registerView.layer.shadowColor = UIColor(hex: "#F4F5F8").cgColor
        registerView.layer.shadowOpacity = 1
        registerView.layer.shadowRadius = 12
        view.addSubview(registerView)

        setupStackView()
    }

    // 하단뷰내에서 하단 카드뷰 생성
    private func createCardView(title: String, description: String, iconName: String, tag: Int) -> UIView {
        let card = UIView()
        card.layer.cornerRadius = 10
        card.layer.masksToBounds = true // 이것을 false로 설정하고 그림자를 추가할 수 있습니다.
        card.backgroundColor = .white
        card.tag = tag

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        card.addGestureRecognizer(tapGesture)
        card.isUserInteractionEnabled = true

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 20)

        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        descriptionLabel.numberOfLines = 0

        let cardStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        cardStackView.axis = .vertical
        cardStackView.spacing = 5
        card.addSubview(cardStackView)

        let iconImageView = UIImageView(image: UIImage(named: iconName))
        iconImageView.contentMode = .scaleAspectFit
        card.addSubview(iconImageView)
        // 카드 내부 스택 뷰의 제약 조건을 설정합니다.
        cardStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
        }

        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.trailing.bottom.equalTo(card).inset(5)
        }

        return card
    }

    // 상단 뷰
    private func setupStackView() {

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10 // 적절한 간격 설정

        registerView.addSubview(stackView)

        // 그라데이션 이미지 뷰 설정
        // 이미 검사 결과가 있으면 검사 결과표현
        if User.shared.color != nil {
            gradientImageView.image = UIImage(named: "icon7268")
            gradientImageView.contentMode = .scaleAspectFit
            gradientImageView.layer.cornerRadius = gradientImageView.frame.height / 2
            gradientImageView.clipsToBounds = true

            // horizonStackView 내에 verticalStackView 추가
            let verticalStackView = UIStackView()
            verticalStackView.axis = .vertical
            verticalStackView.distribution = .fillEqually

            // 두 개의 라벨을 생성하고 verticalStackView에 추가합니다.
            let label1 = UILabel()
            label1.text = "Màu sắc cá nhân của bạn là"
            label1.textAlignment = .left
            label1.font = UIFont(name: "Pretendard-Regular", size: 14)

            let label2 = UILabel()
            let text = "\(User.shared.color ?? "")"
            label2.textAlignment = .left
            label2.textColor = UIColor(hex: "#676975")
            label2.font = UIFont(name: "Pretendard-SemiBold", size: 20)

            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "snow")
            attachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 20) // 이미지의 크기 조정

            let attributedString = NSMutableAttributedString(string: "\(text) ")
            let attachmentString = NSAttributedString(attachment: attachment)
            attributedString.append(attachmentString)
            label2.attributedText = attributedString

            verticalStackView.addArrangedSubview(label1)
            verticalStackView.addArrangedSubview(label2)
            // 화살표 이미지 뷰 설정
            arrowImageView.image = UIImage(named: "arrow_right")
            arrowImageView.contentMode = .scaleAspectFit

            stackView.addArrangedSubview(gradientImageView)
            stackView.addArrangedSubview(verticalStackView)
            stackView.addArrangedSubview(arrowImageView)

            // verticalStackView를 horizonStackView에 추가합니다.
            verticalStackView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().inset(10)
                // make.leading.equalTo(image.snp.trailing).offset(20)  // 이미지와의 간격을 설정
                make.centerY.equalToSuperview()
            }

            // imageView2의 크기 제약 조건을 설정합니다.
            arrowImageView.snp.makeConstraints { make in
                make.width.equalTo(24) // 화살표 아이콘의 너비를 24로 설정
                make.height.equalTo(24) // 화살표 아이콘의 높이를 24로 설정
            }
        } else {
            gradientImageView.image = UIImage(named: "icon7267")
            gradientImageView.contentMode = .scaleAspectFit
            gradientImageView.layer.cornerRadius = gradientImageView.frame.height / 2
            gradientImageView.clipsToBounds = true

            // 레이블 설정
            actionLabel.text = "Khám phá tông màu của bạn và nhận kết quả nào!"
            actionLabel.font = UIFont(name: "Pretendard-Medium", size: 16)
            actionLabel.numberOfLines = 0

            // 스택 뷰에 이미지와 레이블 추가
            stackView.addArrangedSubview(gradientImageView)
            stackView.addArrangedSubview(actionLabel)

        }

        // imageView1의 크기 제약 조건을 설정합니다.
        gradientImageView.snp.makeConstraints { make in
            make.width.equalTo(40) // 너비를 40으로 설정
            make.height.equalTo(40) // 높이를 40으로 설정
        }

    }

    // Constraints 제약조건
    private func setupConstraints() {

        registerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.height.equalToSuperview().multipliedBy(0.15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        stackView.snp.makeConstraints { make in
            make.top.leading.equalTo(registerView).offset(10)
            make.trailing.bottom.equalTo(registerView).offset(-10)
        }

        contentView.snp.makeConstraints { make in
            make.top.equalTo(registerView.snp.bottom).offset(24)
            make.bottom.trailing.leading.equalToSuperview()
        }

        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(24)
            make.leading.equalTo(contentView).offset(20)
            make.trailing.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView).inset(77)
        }

        topView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.25)
        }

        cardsStackView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.35)
        }
        cardsStackView2.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.35)
        }

    }

    @objc private func registerViewTapped() {
        let vc = TestResultView3()
        vc.seasonTon = User.shared.color ?? ""
        if vc.seasonTon != "" {
            vc.receiveImage = receiveImage
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        let vc = SeasonColorView()
        vc.receiveImage = self.receiveImage
        if let card = sender.view {
            switch card.tag {
            case 0:
                vc.season = "spring"
            case 1:
                vc.season = "summer"
            case 2:
                vc.season = "autumn"
            case 3:
                vc.season = "winter"
            default: print("Test Selection viewTapped Error!")

            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func topViewTapped() {
        let vc = CompareColorView()
        vc.receiveImage = receiveImage
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
