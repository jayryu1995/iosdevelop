//
//  LoginViewController.swift
//  ByahtColor
//
//  Created by jaem on 2023/12/20.
//

import Foundation
import SnapKit
import FBSDKLoginKit
import FBSDKCoreKit
import Alamofire
import AuthenticationServices

class LoginViewController: UIViewController {
    private var activityIndicator: UIActivityIndicatorView!
    private let backgroundImage = UIImage(named: "logo")
    private let imageView = UIImageView()
    private let textLabel = UILabel()
    private let facebookButton = UIButton()
    private let appleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Continue with Apple", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 스피너 초기화 및 설정
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)

        if let token = AccessToken.current,
           !token.isExpired {
            // 토큰 확인 후 계정 정보 수집
            getUserProfile()
        }

        appleUserGet()

        view.backgroundColor = .white

        configureUIComponents()
        setupLayoutConstraints()

    }

    private func appleUserGet() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: UserDefaults.standard.string(forKey: "userID") ?? "") { (credentialState, _) in
            switch credentialState {
            case .authorized:

                DispatchQueue.main.async {
                    let id = UserDefaults.standard.string(forKey: "userID") ?? ""
                    let name = UserDefaults.standard.string(forKey: "name") ?? ""
                    let email = UserDefaults.standard.string(forKey: "email") ?? ""

                    User.shared.updateUserData(id: id, email: email, name: name)
                    self.getNickname()
                }

            case .revoked:
                self.log(message: "apple login : revoked")

            case .notFound:
                self.log(message: "apple login : notFound")

            default:
                break
            }
        }
    }

    // 토큰으로 유저정보 가져오기
    private func getUserProfile() {
        GraphRequest.init(graphPath: "me", parameters: ["fields": "id, name, email"])
            .start(completion: {(_, result, _) in
                guard let fb = result as? [String: AnyObject] else { return }

                let name = fb["name"] as? String
                let email = fb["email"] as? String

                if let idString = fb["id"] as? String {
                    // 변환에 성공한 경우, id를 Int로 사용할 수 있습니다.
                    User.shared.updateUserData(id: idString, email: email, name: name)
                } else {
                    // 변환에 실패한 경우 또는 id가 없는 경우
                    self.log(message: "getUserProfile : 유효하지 않은 id 값 또는 id가 없습니다.")
                }

                self.getNickname()
            })
    }

    // 닉네임이 존재하는지 확인
    private func getNickname() {
        activityIndicator.startAnimating()
        let url = Bundle.main.TEST_URL + "/sel"
        AF.request(url, method: .post, parameters: User.shared, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: UserDto.self) { response in
                switch response.result {
                case .success(let value):
                    User.shared.updateNickName(nickname: value.nickname)
                    User.shared.updateAuth(auth: value.auth)

                    if value.nickname == nil || value.nickname == "" {
                        let vc = NicknameView()
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = TabBarViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    self.activityIndicator.stopAnimating()

                case .failure(let error):
                    self.log(message: "getNickname error : \(error)")
                    let vc = NicknameView()
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.activityIndicator.stopAnimating()
                }
            }

    }

    // UI 컴포넌트를 구성하는 메소드
    private func configureUIComponents() {
        configureImageView()
        configureTextLabel()
        configureLoginButtons()
    }

    // 이미지 뷰 설정
    private func configureImageView() {
        imageView.image = backgroundImage
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

    }

    // 텍스트 라벨 설정
    private func configureTextLabel() {
        textLabel.text = "Liên kết với mạng xã hội của bạn"
        textLabel.textColor = .lightGray
        textLabel.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(textLabel)
    }

    // 로그인 버튼 구성
    private func configureLoginButtons() {

        facebookButton.setTitle("Continue with Facebook", for: .normal)
        facebookButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        facebookButton.setTitleColor(.white, for: .normal)
        facebookButton.backgroundColor = UIColor(hex: "#3875E9")
        facebookButton.layer.cornerRadius = 4
        facebookButton.addTarget(self, action: #selector(self.facebookLogin(_:)), for: .touchUpInside)
        appleButton.addTarget(self, action: #selector(self.appleLogin), for: .touchUpInside)
        view.addSubview(facebookButton)
        view.addSubview(appleButton)

    }

    // 오토레이아웃 제약 조건 설정
    private func setupLayoutConstraints() {
        imageView.snp.makeConstraints { make in
            make.width.equalTo(158)
            make.height.equalTo(57)
            make.top.equalToSuperview().offset(186)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.trailing.equalTo(view.snp.centerX)
        }

        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1.3)
            make.height.equalTo(60)
        }

        // 버튼 스택뷰의 제약 조건 설정
        facebookButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(textLabel.snp.bottom).offset(16)
            $0.height.equalTo(52)
        }

        appleButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(facebookButton.snp.bottom).offset(16)
            $0.height.equalTo(52)
        }
    }

}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // 로그인 성공
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // You can create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email

            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {

            }

            let id = userIdentifier ?? ""
            let name = "\(fullName?.givenName ?? "") \(fullName?.familyName ?? "")"
            let user_email = email ?? ""

            UserDefaults.standard.set(name, forKey: "name")
            UserDefaults.standard.set(id, forKey: "userID")
            UserDefaults.standard.set(user_email, forKey: "email")
            User.shared.updateUserData(id: id, email: user_email, name: name)

            self.getNickname()

        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password

        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("login failed - \(error.localizedDescription)")
    }

    @objc private func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email] // 유저로 부터 알 수 있는 정보들(name, email)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()

    }

    @objc func facebookLogin(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) {(result, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }

            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }

            GraphRequest.init(graphPath: "me", parameters: ["fields": "id, name, email"])
                .start(completion: {(_, result, error) in
                    print("error: ", error ?? "No error")
                    guard let fb = result as? [String: AnyObject] else { return }

                    let name = fb["name"] as? String ?? ""
                    let email = fb["email"] as? String ?? ""
                    let idString = fb["id"] as? String ?? ""

                    User.shared.updateUserData(id: idString, email: email, name: name)
                    self.getNickname()
                })

        }

    }

}
