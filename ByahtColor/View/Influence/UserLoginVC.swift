//
//  UserLoginVC.swift
//  ByahtColor
//
//  Created by jaem on 6/12/24.
//

import SnapKit
import FBSDKLoginKit
import FBSDKCoreKit
import Alamofire
import Combine
import AuthenticationServices

class UserLoginVC: UIViewController {
    private let appleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Continue with Apple", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()

    lazy private var templetView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "image_login"))
        image.contentMode = .scaleAspectFill
        return image
    }()

    private let viewModel = MemberViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var activityIndicator: UIActivityIndicatorView!
    private let backgroundImage = UIImage(named: "logo")
    private let imageView = UIImageView()
    private let textLabel = UILabel()
    private let facebookButton = UIButton()
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 스피너 초기화 및 설정
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)

        view.backgroundColor = .white

        configureUIComponents()
        setupLayoutConstraints()

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

    private func checkedUser() {
        if let id = User.shared.id {
            viewModel.login(id: id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let message):
                        print(message)
                        User.shared.updateAuth(auth: message)
                        let vc = TabBarViewController()
                        self?.navigationController?.pushViewController(vc, animated: true)

                    case .failure(let error):
                        print("데이터 없음")
                        self?.signUpInfluence()
                    }
                }
            }
        }
    }

    private func signUpInfluence() {
        if let id = User.shared.id {
            let member = Member(id: id, auth: 0, regi_date: nil)
            let influence = Influence(no: nil, id: nil, name: User.shared.name ?? "", intro: nil, age: nil, category: nil, gender: nil, video: nil, evaluation: nil)
            let dto = MemberInfluenceDto(member: member, influence: influence)
            viewModel.updateMemberInfluence(memberInfluenceDto: dto) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let responseString):
                        let vc = TabBarViewController()
                        self?.navigationController?.pushViewController(vc, animated: true)

                    case .failure(let error):
                        print("에러가 발생했습니다")
                        print( "Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    // 닉네임이 존재하는지 확인
    private func getNickname() {
        checkedUser()
    }

    // UI 컴포넌트를 구성하는 메소드
    private func configureUIComponents() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        configureImageView()
        configureTextLabel()
        configureLoginButtons()
    }

    // 이미지 뷰 설정
    private func configureImageView() {
        contentView.addSubview(templetView)

        templetView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.height.equalTo(264)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    // 텍스트 라벨 설정
    private func configureTextLabel() {
        textLabel.text = NSLocalizedString("login_str", comment: "")
        textLabel.textColor = .lightGray
        textLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(textLabel)
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
        contentView.addSubview(facebookButton)
        contentView.addSubview(appleButton)

    }

    // 오토레이아웃 제약 조건 설정
    private func setupLayoutConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.greaterThanOrEqualTo(scrollView).priority(.low)
        }

        templetView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(templetView.snp.width).multipliedBy(264.0 / 350.0)
        }

        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(templetView.snp.bottom).offset(16)
            make.height.equalTo(60)
        }

        facebookButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(textLabel.snp.bottom).offset(16)
            $0.height.equalTo(52)
        }

        appleButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(facebookButton.snp.bottom).offset(16)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().offset(-200)
        }

    }

}

extension UserLoginVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
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
            var name = "\(fullName?.givenName ?? "") \(fullName?.familyName ?? "")"
            let user_email = email ?? ""

            if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                name = "user\(generateRandomNumber(digits: 8))"
            }
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

    @objc private func facebookLogin(_ sender: Any) {
        let loginManager = LoginManager()
        guard let configuration = LoginConfiguration(
            permissions: ["email"],
            tracking: .limited,
            nonce: "123"
        )
        else {
            return
        }

        loginManager.logIn(configuration: configuration) { result in
            switch result {
            case .cancelled, .failed:
                // Handle error
                break
            case .success:
                // getting user ID
                let userID = Profile.current?.userID

                // getting pre-populated email
                let email = Profile.current?.email
                var name = Profile.current?.name

                // getting id token string
                let tokenString = AuthenticationToken.current?.tokenString
                if name?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                    name = "user\(self.generateRandomNumber(digits: 8))"
                }
                UserDefaults.standard.set(name, forKey: "name")
                UserDefaults.standard.set(userID, forKey: "userID")
                UserDefaults.standard.set(email, forKey: "email")
                User.shared.updateUserData(id: userID, email: email, name: name)

                self.getNickname()
            }
        }
    }

    private func generateRandomNumber(digits: Int) -> String {
        var number = ""
        for _ in 0..<digits {
            number.append(String(Int.random(in: 0...9)))
        }
        print(number)
        return number
    }

}
