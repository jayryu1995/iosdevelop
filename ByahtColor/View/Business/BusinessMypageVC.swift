//
//  BusinessMypageVC.swift
//  ByahtColor
//
//  Created by jaem on 6/28/24.
//

import UIKit
import Alamofire
import Combine
import SnapKit
import Foundation

class BusinessMypageVC: UIViewController {

    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "icon_profile2")
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 40
        image.clipsToBounds = true
        return image
    }()
    private let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.text = "My Company"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "Account"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
    private let layer: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(hex: "#D9D9D9").cgColor
        return view
    }()
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(UIColor(hex: "#009BF2"), for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()
    private let globalButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(UIColor(hex: "#F4F5F8"), for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.isHidden = true
        return button
    }()
    private let accountButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(UIColor(hex: "#F4F5F8"), for: .normal)
        button.layer.cornerRadius = 4

        return button
    }()

    private let marketingButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(UIColor(hex: "#F4F5F8"), for: .normal)
        button.layer.cornerRadius = 4
        button.isHidden = true
        return button
    }()

    private let introLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    private let viewModel = BusinessViewModel()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupProfile()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfile()
        setupUI()
        setupContstraints()
    }

    private func setupProfile() {
        if let id = User.shared.id {
            viewModel.getBusinessProfile(id: id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        let path = "\(Bundle.main.TEST_URL)/business\( data.imagePath ?? "" )"
                        self?.loadImageFromURL(path) { [weak self] image in
                            DispatchQueue.main.async {
                                if let image = image {
                                    self?.profileImage.image = image
                                }
                            }
                        }
                        self?.name.text = data.business_name ?? "회사명"
                        self?.introLabel.text = data.intro ?? "intro"
                    case .failure(let error):
                        print("통신 에러 : \(error)")

                    }
                }
            }
        }
    }

    private func setupUI() {
        view.addSubview(name)
        view.addSubview(introLabel)
        view.addSubview(profileImage)
        view.addSubview(companyLabel)
        view.addSubview(accountLabel)
        view.addSubview(layer)
        view.addSubview(profileButton)
        view.addSubview(globalButton)
        view.addSubview(marketingButton)
        view.addSubview(accountLabel)
        view.addSubview(accountButton)

        setupProfileButton()
        setupGlobalButton()
        setupmarketingButton()
        setupAccountButton()
    }

    private func setupGlobalButton() {
        globalButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        let label = UILabel()
        label.text = "business_mypage_global_label".localized
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = UIColor(hex: "#009BF2")

        let label2 = UILabel()
        label2.text = "business_mypage_global_label2".localized
        label2.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label2.textColor = .black
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(label2)

        let icon = UIImageView(image: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = UIColor(hex: "#4E505B")
        icon.contentMode = .scaleAspectFit

        globalButton.addSubview(stackView)
        globalButton.addSubview(icon)
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(20)
        }

        icon.snp.makeConstraints {
            $0.centerY.equalTo(stackView.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
    }

    private func setupProfileButton() {
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        let label = UILabel()
        label.text = "business_mypage_profile_label".localized
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = .white

        let label2 = UILabel()
        label2.text = "business_mypage_profile_label2".localized
        label2.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label2.textColor = .white
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(label2)

        let icon = UIImageView(image: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit

        profileButton.addSubview(stackView)
        profileButton.addSubview(icon)
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(20)
        }

        icon.snp.makeConstraints {
            $0.centerY.equalTo(stackView.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
    }

    private func setupmarketingButton() {

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        let label = UILabel()
        label.text = "business_mypage_maketing_label".localized
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = UIColor(hex: "#009BF2")

        let label2 = UILabel()
        label2.text = "business_mypage_maketing_label2".localized
        label2.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label2.textColor = .black
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(label2)

        let icon = UIImageView(image: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = UIColor(hex: "#4E505B")
        icon.contentMode = .scaleAspectFit

        marketingButton.addSubview(stackView)
        marketingButton.addSubview(icon)
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(20)
        }

        icon.snp.makeConstraints {
            $0.centerY.equalTo(stackView.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
    }

    private func setupAccountButton() {
        let label = UILabel()
        label.text = "influence_mypage_account_label".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = .black

        let icon = UIImageView(image: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = UIColor(hex: "#4E505B")
        icon.contentMode = .scaleAspectFit

        accountButton.addSubview(label)
        accountButton.addSubview(icon)
        accountButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }

        icon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
    }

    private func setupContstraints() {
        profileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(11)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(80)
        }

        name.snp.makeConstraints {
            $0.bottom.equalTo(profileImage.snp.centerY)
            $0.leading.equalTo(profileImage.snp.trailing).offset(15)
            $0.trailing.equalToSuperview()
        }

        introLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.centerY).offset(8)
            $0.leading.equalTo(profileImage.snp.trailing).offset(15)
            $0.trailing.equalToSuperview()
        }

        layer.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }

        companyLabel.snp.makeConstraints {
            $0.top.equalTo(layer.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }

        profileButton.snp.makeConstraints {
            $0.top.equalTo(companyLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }

        marketingButton.snp.makeConstraints {
            $0.top.equalTo(profileButton.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }

        globalButton.snp.makeConstraints {
            $0.top.equalTo(marketingButton.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }

        accountLabel.snp.makeConstraints {
            $0.top.equalTo(profileButton.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        accountButton.snp.makeConstraints {
            $0.top.equalTo(accountLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
    }

    @objc private func profileButtonTapped() {
        let vc = BusinessProfileVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }

    @objc private func logoutButtonTapped() {
        let vc = BusinessLogoutVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
