//
//  InfulenceMyPageVC.swift
//  ByahtColor
//
//  Created by jaem on 6/26/24.
//

import UIKit
import Combine
import SnapKit

class InfluenceMyPageVC: UIViewController {

    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "icon_profile2")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 40
        image.clipsToBounds = true
        return image
    }()
    private let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
    private let careerLabel: UILabel = {
        let label = UILabel()
        label.text = "My Career"
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

    private let accountButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(UIColor(hex: "#F4F5F8"), for: .normal)
        button.layer.cornerRadius = 4
        return button
    }()

    private let eventButton: UIButton = {
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

    private let viewModel = InfluenceViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let id = User.shared.id else { return }
        viewModel.getMyAccount(id: id)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
        setupBinding()
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataChangedNotification), name: .dataChanged, object: nil)
    }

    @objc private func handleDataChangedNotification() {
        guard let id = User.shared.id else { return }
        viewModel.getMyAccount(id: id)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .dataChanged, object: nil)
    }

    private func setupBinding() {
        viewModel.$accountData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let data = data else { return }
                if let id = User.shared.id {
                    let url = "\(Bundle.main.TEST_URL)/img/profile/\(id).jpg"
                    let currentProfileURL = url

                    self?.profileImage.loadProfileImage(from: currentProfileURL) { [weak self] image in
                        // 현재 셀이 해당 taskID를 가지고 있는지 확인
                        self?.profileImage.image = image
                        self?.profileImage.layer.cornerRadius = (self?.profileImage.frame.size.width ?? 80) / 2
                    }

                }

                self?.name.text = data.name ?? "influence_mypage_name_info".localized
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        view.addSubview(name)
        view.addSubview(profileImage)
        view.addSubview(careerLabel)
        view.addSubview(accountLabel)
        view.addSubview(layer)
        view.addSubview(profileButton)
        view.addSubview(eventButton)
        view.addSubview(accountLabel)
        view.addSubview(accountButton)
        view.addSubview(errorButton)

        setupProfileButton()
        setupeventButton()
        setupAccountButton()
        setupErrorButton()
    }

    private func setupProfileButton() {
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)

        let layer0 = CAGradientLayer()
        layer0.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor,
            UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.25, b: 0, c: 0, d: 1.25, tx: 0, ty: -0.13))
        layer0.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        layer0.position = view.center
        profileButton.layer.addSublayer(layer0)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        let label = UILabel()
        label.text = "influence_mypage_profile_label".localized
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = .white

        let label2 = UILabel()
        label2.text = "influence_mypage_profile_label2".localized
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

    private func setupeventButton() {
        eventButton.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally

        let label = UILabel()
        label.text = "influence_mypage_event_label".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label.textColor = .black
        stackView.addArrangedSubview(label)

        let icon = UIImageView(image: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = UIColor(hex: "#4E505B")
        icon.contentMode = .scaleAspectFit

        eventButton.addSubview(stackView)
        eventButton.addSubview(icon)
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
    
    private func setupAccountButton() {
        let label = UILabel()
        label.text = "influence_mypage_account_label".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = .black

        let icon = UIImageView(image: UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = UIColor(hex: "#4E505B")
        icon.contentMode = .scaleAspectFit

        accountButton.addTarget(self, action: #selector(accountButtonTapped), for: .touchUpInside)

        accountButton.addSubview(label)
        accountButton.addSubview(icon)
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

    private func setupConstraints() {
        profileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(11)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(80)
        }

        name.snp.makeConstraints {
            $0.centerY.equalTo(profileImage.snp.centerY)
            $0.leading.equalTo(profileImage.snp.trailing).offset(15)
        }

        layer.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }

        careerLabel.snp.makeConstraints {
            $0.top.equalTo(layer.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }

        profileButton.snp.makeConstraints {
            $0.top.equalTo(careerLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }

        eventButton.snp.makeConstraints {
            $0.top.equalTo(profileButton.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }

        accountLabel.snp.makeConstraints {
            $0.top.equalTo(eventButton.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        accountButton.snp.makeConstraints {
            $0.top.equalTo(accountLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
        
        errorButton.snp.makeConstraints{
            $0.top.equalTo(accountButton.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
    }

    @objc private func profileButtonTapped() {
        let vc = InfluenceProfileVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }

    @objc private func accountButtonTapped() {
        let vc = InfluenceMyPageWriteVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }

    @objc private func eventButtonTapped() {
        let vc = ApplicationStateVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc private func errorButtonTapped() {
        let urlString = "https://forms.gle/iE8czGec28MGPwvo7"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
