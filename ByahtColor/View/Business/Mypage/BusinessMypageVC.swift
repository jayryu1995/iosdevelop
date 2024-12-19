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
    
    private lazy var profileLabel = {
        let label = UILabel()
        label.text = "Profile"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "icon_profile2")
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(UIColor(hex: "#009BF2"), for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    private let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.textColor = .white
        return label
    }()
    
    private let myWorkLabel: UILabel = {
        let label = UILabel()
        label.text = "My Work"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    private let myWorkButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(UIColor(hex: "#F4F5F8"), for: .normal)
        button.layer.cornerRadius = 4

        return button
    }()
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "My Account"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    
    private let businessInfoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(UIColor(hex: "#F4F5F8"), for: .normal)
        button.layer.cornerRadius = 4

        return button
    }()

    private let passwordButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(UIColor(hex: "#F4F5F8"), for: .normal)
        button.layer.cornerRadius = 4

        return button
    }()

    private let errorButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(UIColor(hex: "#F4F5F8"), for: .normal)
        button.layer.cornerRadius = 4
        return button
    }()
    
    private let introLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = UIColor(hex: "#F4F5F8")
        label.numberOfLines = 2
        return label
    }()

    private let viewModel = BusinessViewModel()
    

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
                        if let path = data.imagePath{
                            self?.loadImageFromURL(path) { [weak self] image in
                                DispatchQueue.main.async {
                                    if let image = image {
                                        self?.profileImage.image = image
                                    }
                                }
                            }
                        }else{
                            self?.profileImage.image = UIImage(named: "sample_business_image")
                        }
                        
                        self?.name.text = data.business_name ?? "signup_business_name".localized
                        self?.introLabel.text = data.intro ?? "intro"
                    case .failure(let error):
                        print("통신 에러 : \(error)")

                    }
                }
            }
        }
    }

    private func setupUI() {
        view.addSubview(profileLabel)
        view.addSubview(profileButton)
        
        view.addSubview(myWorkLabel)
        view.addSubview(myWorkButton)
        
        view.addSubview(accountLabel)
        view.addSubview(businessInfoButton)
        view.addSubview(passwordButton)
        view.addSubview(errorButton)
        
        setupMyWorkButton()
        setupProfileButton()
        setupPasswordButton()
        setupBusinessInfoButton()
        setupErrorButton()
    }


    private func setupProfileButton() {
        profileButton.addSubview(name)
        profileButton.addSubview(introLabel)
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)

        // 그라데이션 레이어 설정
        let layer0 = CAGradientLayer()
        layer0.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor,
            UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.bounds = view.bounds.insetBy(dx: -0.5 * view.bounds.size.width, dy: -0.5 * view.bounds.size.height)
        layer0.position = view.center
        profileButton.layer.insertSublayer(layer0, at: 0)

        // 프로필 이미지
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.snp.makeConstraints {
            $0.width.height.equalTo(70) // 이미지 크기 설정
        }

        // 텍스트 스택뷰
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = 4

        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(introLabel)

        // 아이콘 이미지
        let icon = UIImageView(image: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit

        // 프로필 이미지와 텍스트 스택뷰를 담는 컨테이너
        let containerView = UIStackView()
        containerView.axis = .horizontal
        containerView.spacing = 12
        containerView.alignment = .center
        containerView.addArrangedSubview(profileImage)
        containerView.addArrangedSubview(stackView)

        // 컨테이너와 아이콘 배치
        profileButton.addSubview(containerView)
        profileButton.addSubview(icon)

        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(20)
        }

        icon.snp.makeConstraints {
            $0.centerY.equalTo(containerView.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
        
        introLabel.snp.makeConstraints{
            $0.leading.equalTo(name.snp.leading)
            $0.trailing.equalTo(icon.snp.leading).offset(-10)
        }
    }

    private func setupMyWorkButton() {
        let label = UILabel()
        label.text = "check_event".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = .black

        let icon = UIImageView(image: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = UIColor(hex: "#4E505B")
        icon.contentMode = .scaleAspectFit

        myWorkButton.addSubview(label)
        myWorkButton.addSubview(icon)
        //myWorkButton.addTarget(self, action: #selector(), for: .touchUpInside)
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

    private func setupBusinessInfoButton() {
        let label = UILabel()
        label.text = "modify_businessinfo".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = .black

        let icon = UIImageView(image: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = UIColor(hex: "#4E505B")
        icon.contentMode = .scaleAspectFit

        businessInfoButton.addSubview(label)
        businessInfoButton.addSubview(icon)
        businessInfoButton.addTarget(self, action: #selector(businessInfoButtonTapped), for: .touchUpInside)
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
    
    private func setupPasswordButton() {
        let label = UILabel()
        label.text = "change_password".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = .black

        let icon = UIImageView(image: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = UIColor(hex: "#4E505B")
        icon.contentMode = .scaleAspectFit

        passwordButton.addSubview(label)
        passwordButton.addSubview(icon)
        passwordButton.addTarget(self, action: #selector(passwordButtonTapped), for: .touchUpInside)
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

    private func setupErrorButton() {
        let label = UILabel()
        label.text = "business_mypage_error_label".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = .black

        let icon = UIImageView(image: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = UIColor(hex: "#4E505B")
        icon.contentMode = .scaleAspectFit

        errorButton.addSubview(label)
        errorButton.addSubview(icon)
        errorButton.addTarget(self, action: #selector(errorButtonTapped), for: .touchUpInside)
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
        myWorkLabel.isHidden = true
        myWorkButton.isHidden = true
        
        profileLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(11)
            $0.leading.equalToSuperview().offset(20)
        }
        
        profileButton.snp.makeConstraints {
            $0.top.equalTo(profileLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(100)
        }

        myWorkLabel.snp.makeConstraints {
            $0.top.equalTo(profileButton.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        myWorkButton.snp.makeConstraints {
            $0.top.equalTo(myWorkLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
        
        accountLabel.snp.makeConstraints {
            $0.top.equalTo(profileButton.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        businessInfoButton.snp.makeConstraints {
            $0.top.equalTo(accountLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
        
        passwordButton.snp.makeConstraints {
            $0.top.equalTo(businessInfoButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
        
        errorButton.snp.makeConstraints{
            $0.top.equalTo(passwordButton.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
    }

    @objc private func profileButtonTapped() {
        let vc = BusinessProfileVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }

    @objc private func businessInfoButtonTapped() {
        let vc = BusinessInfoVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc private func passwordButtonTapped() {
        let vc = BusinessPasswordChangeVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc private func errorButtonTapped() {
        let urlString = "https://forms.gle/iE8czGec28MGPwvo7"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
