//
//  AdminApplicantTableCell.swift
//  ByahtColor
//
//  Created by jaem on 4/3/24.
//

import UIKit
import SnapKit
import Alamofire

class AdminApplicantTableCell: UITableViewCell, UIScrollViewDelegate {

    weak var delegate: AdminApplicantTableCellDelegate?
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor(hex: "#BCBDC0").cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label.numberOfLines = 1
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label.textColor = UIColor(hex: "#535358")
        label.numberOfLines = 1
        return label
    }()

    private let linkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label.textColor = .blue // 링크처럼 보이게 하기 위해 파란색으로 설정
        label.isUserInteractionEnabled = true // 사용자 상호작용 활성화
        return label
    }()

    let buttonO: UIButton = {
        let button = UIButton()
        button.setTitle("O", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundColor(UIColor(hex: "#BCBDC0"), for: .normal)
        button.tag = 2
        return button
    }()

    let buttonX: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundColor(UIColor(hex: "#BCBDC0"), for: .normal)
        button.tag = 1
        return button
    }()

    private var applicant: ApplicantDto?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(cardView)

        cardView.addSubview(nameLabel)
        cardView.addSubview(emailLabel)
        cardView.addSubview(linkLabel)
        cardView.addSubview(buttonX)
        cardView.addSubview(buttonO)

        // event 설정
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openLink))
        linkLabel.addGestureRecognizer(tapGesture)

        cardView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.height.equalTo(92)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().offset(-5)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.top).offset(5)
            $0.height.equalTo(24)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(cardView.snp.centerX).offset(10)
        }

        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.height.equalTo(24)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(cardView.snp.centerX).offset(10)
        }

        buttonX.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }

        buttonO.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(buttonX.snp.leading).offset(-10)
        }

        linkLabel.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(5)
            $0.height.equalTo(24)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(cardView.snp.centerX).offset(10)
            $0.bottom.equalToSuperview().inset(5)
        }

    }

    func setData(result: ApplicantDto) {
        applicant = result
        nameLabel.text = result.name
        emailLabel.text = result.email
        linkLabel.text = result.link
        setButtonColor(state: result.state ?? 0)
        buttonO.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        buttonX.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private func setButtonColor(state: Int) {
        switch state {
        case 0:
            // 미완료
            buttonO.setBackgroundColor(UIColor(hex: "#BCBDC0"), for: .normal)
            buttonX.setBackgroundColor(UIColor(hex: "#BCBDC0"), for: .normal)
        case 1:
            // 미선정
            buttonO.setBackgroundColor(UIColor(hex: "#BCBDC0"), for: .normal)
            buttonX.setBackgroundColor(UIColor(hex: "#FF453A"), for: .normal)

        case 2:
            // 선정
            buttonO.setBackgroundColor(UIColor(hex: "#30D158"), for: .normal)
            buttonX.setBackgroundColor(UIColor(hex: "#BCBDC0"), for: .normal)

        default:
            buttonO.setBackgroundColor(UIColor(hex: "#BCBDC0"), for: .normal)
            buttonX.setBackgroundColor(UIColor(hex: "#BCBDC0"), for: .normal)
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        delegate?.didUpdateApplicantState(cell: self, applicant: applicant!, state: sender.tag)
    }

    // 링크 열기 함수
    @objc private func openLink() {
        let string = linkLabel.text
        if let url = URL(string: string ?? "") {
            UIApplication.shared.open(url)
        }
    }
}
protocol AdminApplicantTableCellDelegate: AnyObject {
    func didUpdateApplicantState(cell: AdminApplicantTableCell, applicant: ApplicantDto, state: Int)
}
