//
//  ProfileAlertView.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/29.
//
import SnapKit
import Alamofire
import FBSDKLoginKit
import FBSDKCoreKit

class ProfileAlertVC: UIViewController {
    private let viewModel = MemberViewModel()
    private let backgroundView = UIView()
    private let alertView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let confirmButton = NextButton()
    private let cancleButton = NextButton()

    // 콜백 정의
    var onCancel: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupAlertView()
        setupConstraints()
    }

    private func setupBackgroundView() {
        backgroundView.backgroundColor = .black
        view.addSubview(backgroundView)
    }

    private func setupAlertView() {
        // alertView 설정
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 12

        /// 계정삭제///
        // titleLabel 설정
        titleLabel.text = "alert_exit_label".localized //
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        titleLabel.textAlignment = .center

        // messageLabel 설정
        messageLabel.text = "alert_exit_label2".localized //
        messageLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        messageLabel.textAlignment = .center

        // confirmButton 설정
        confirmButton.setTitle("alert_exit_label3".localized, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)

        // cancleButton 설정
        cancleButton.setTitle("alert_exit_label4".localized, for: .normal)
        cancleButton.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        cancleButton.backgroundColor = UIColor(hex: "#F4F5F8")
        cancleButton.addTarget(self, action: #selector(cancleButtonTapped), for: .touchUpInside)

        // alertView에 컴포넌트 추가
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        alertView.addSubview(confirmButton)
        alertView.addSubview(cancleButton)

        // 전체 뷰에 alertView 추가
        backgroundView.addSubview(alertView)

    }

    // 오토레이아웃 제약조건을 설정합니다.
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let width = view.frame.size.width-30

        alertView.snp.makeConstraints { make in
            make.width.height.equalTo(width)
            make.center.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.centerX.equalToSuperview()
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }

        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(alertView.snp.centerY)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(alertView.snp.height).multipliedBy(0.2)
        }

        cancleButton.snp.makeConstraints { make in
            make.top.equalTo(confirmButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(alertView.snp.height).multipliedBy(0.2)
        }
    }

    @objc private func confirmButtonTapped() {
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "businessId")

        let loginManager = LoginManager()
        loginManager.logOut()

        // SceneDelegate에 접근하여 rootViewController를 변경합니다.
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            // LoginViewController 인스턴스 생성. 스토리보드를 사용하는 경우 스토리보드 ID로 인스턴스화해야 합니다.
            let loginViewController = LoginVC() // 또는 스토리보드에서 생성
            let navigationController = UINavigationController(rootViewController: loginViewController)
            sceneDelegate.window?.rootViewController = navigationController
            sceneDelegate.window?.makeKeyAndVisible()
        }
        deleteUser(userId: User.shared.id ?? "")
    }

    @objc private func cancleButtonTapped() {
        // 콜백 호출
        dismiss(animated: true, completion: nil)

    }

    func deleteUser(userId: String) {
        viewModel.secession(id: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.log(message: "탈퇴 성공")

                case .failure(let error):
                    self?.log(message: "통신 실패")
                }
            }
        }
        // SceneDelegate에 접근하여 rootViewController를 변경합니다.
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            // LoginViewController 인스턴스 생성. 스토리보드를 사용하는 경우 스토리보드 ID로 인스턴스화해야 합니다.
            let loginViewController = LoginVC() // 또는 스토리보드에서 생성
            let navigationController = UINavigationController(rootViewController: loginViewController)
            sceneDelegate.window?.rootViewController = navigationController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}
