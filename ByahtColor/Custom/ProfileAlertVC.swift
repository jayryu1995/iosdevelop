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

    let backgroundView = UIView()
    let alertView = UIView()
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let confirmButton = NextButton()
    let cancleButton = NextButton()

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

        // titleLabel 설정
        titleLabel.text = "Really...?😭"
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        titleLabel.textAlignment = .center

        // messageLabel 설정
        messageLabel.text = "Chúng mình sẽ tiếp tục cập nhật nhiều tính năng mới nha.\nBạn có chắc là muốn xoá tài khoản không?"
        messageLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        messageLabel.textAlignment = .center

        // confirmButton 설정
        confirmButton.setTitle("Không", for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)

        // cancleButton 설정
        cancleButton.setTitle("Xoá tài khoản", for: .normal)
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
        print("deleteButton on")
        let id = User.shared.id ?? ""
        if id.contains(".") {
            print("애플 계정입니다")
            print("id : \(id)")
            UserDefaults.standard.set("", forKey: "name")
            UserDefaults.standard.set("", forKey: "userID")
            UserDefaults.standard.set("", forKey: "email")

        } else {
            let loginManager = LoginManager()
            loginManager.logOut()

        }
        // SceneDelegate에 접근하여 rootViewController를 변경합니다.
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            // LoginViewController 인스턴스 생성. 스토리보드를 사용하는 경우 스토리보드 ID로 인스턴스화해야 합니다.
            let loginViewController = LoginViewController() // 또는 스토리보드에서 생성
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
        let url = "\(Bundle.main.TEST_URL)/user/delete" // 서버 URL 변경
        let parameters: [String: Any] = ["user_id": userId]

        AF.request(url, method: .delete, parameters: parameters)
          .response { response in
              switch response.result {
              case .success:
                  print("User with ID \(userId) has been deleted")

              case .failure(let error):
                  print("Error occurred: \(error)")
              }
          }
        // SceneDelegate에 접근하여 rootViewController를 변경합니다.
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            // LoginViewController 인스턴스 생성. 스토리보드를 사용하는 경우 스토리보드 ID로 인스턴스화해야 합니다.
            let loginViewController = LoginViewController() // 또는 스토리보드에서 생성
            let navigationController = UINavigationController(rootViewController: loginViewController)
            sceneDelegate.window?.rootViewController = navigationController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}
