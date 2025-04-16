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
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn


class UserLoginVC: UIViewController {
    lazy private var googleButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "google")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true  // 제스처 인식을 위해 필요
        return imageView
    }()
//    lazy private var appleButton: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "google")
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.isUserInteractionEnabled = true  // 제스처 인식을 위해 필요
//        return imageView
//    }()

    lazy private var facebookButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "facebook")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true  // 제스처 인식을 위해 필요
        return imageView
    }()

    lazy private var kakaoButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kakaotalk")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true  // 제스처 인식을 위해 필요
        return imageView
    }()

    
    lazy private var templetView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "image_login"))
        image.contentMode = .scaleAspectFit
        return image
    }()

    private let viewModel = MemberViewModel()
    private let kakaoVM = KakaoAuthVM()
    
    lazy private var cancellables = Set<AnyCancellable>()
    private var activityIndicator: UIActivityIndicatorView!
    private let backgroundImage = UIImage(named: "logo")
    private let imageView = UIImageView()
    private let textLabel = UILabel()
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

    private func checkedUser() {
        if let id = User.shared.id {
            viewModel.getLoginData(member_id: id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        User.shared.name = data.name
                        UserDefaults.standard.set(data.name, forKey: "name")
                        UserDefaults.standard.set(id, forKey: "userID")
                        UserDefaults.standard.set(User.shared.email, forKey: "email")
                        
                        self?.requestGenerateToken(id: id)
                    case .failure(let error):
                        print(error)
                        self?.signUpInfluence()
                    }
                }
            }
        }
    }

    
    private func requestGenerateToken(id: String){
        viewModel.getToken(member_id: id){ [weak self] result in
            switch result {
            case .success(let data):
                
                UserDefaults.standard.set(data.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(data.refreshToken, forKey: "refreshToken")
                
                let vc = TabBarViewController()
                self?.navigationController?.pushViewController(vc, animated: true)

            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func signUpInfluence() {
        if let id = User.shared.id {
            let member = Member(id: id, auth: 0, regi_date: nil)
            let influence = Influence(no: nil, id: nil, name: User.shared.name ?? "", intro: nil, age: nil, category: nil, gender: nil, video: nil, evaluation: nil, email: User.shared.email)
            let dto = MemberInfluenceDto(member: member, influence: influence)
            viewModel.updateMemberInfluence(memberInfluenceDto: dto) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let responseString):
                        
                        UserDefaults.standard.set(User.shared.name, forKey: "name")
                        UserDefaults.standard.set(User.shared.id, forKey: "userID")
                        UserDefaults.standard.set(User.shared.email, forKey: "email")
                        
                        self?.requestGenerateToken(id: id)
                        
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

        // Facebook 이미지에 탭 제스처 추가
        let facebookTapGesture = UITapGestureRecognizer(target: self, action: #selector(facebookLogin))
        facebookButton.addGestureRecognizer(facebookTapGesture)
        
        // Google 이미지에 탭 제스처 추가
        let googleTapGesture = UITapGestureRecognizer(target: self, action: #selector(googleLogin))
        googleButton.addGestureRecognizer(googleTapGesture)
        
        // Apple 이미지에 탭 제스처 추가
//        let appleTapGesture = UITapGestureRecognizer(target: self, action: #selector(appleLogin))
//        appleButton.addGestureRecognizer(appleTapGesture)
        
        // kakao 이미지에 탭 제스처 추가
        let kakaoTapGesture = UITapGestureRecognizer(target: self, action: #selector(kakaoLogin))
        kakaoButton.addGestureRecognizer(kakaoTapGesture)
        
        
        contentView.addSubview(kakaoButton)
        contentView.addSubview(facebookButton)
        contentView.addSubview(googleButton)

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

        // SNS 버튼들을 균등하게 배치하기 위한 StackView 설정
        let snsButtonStack = UIStackView(arrangedSubviews: [facebookButton, googleButton, kakaoButton])
        snsButtonStack.axis = .horizontal
        snsButtonStack.distribution = .equalSpacing
        snsButtonStack.alignment = .center
        snsButtonStack.spacing = 16 // 버튼 사이 간격
        
        contentView.addSubview(snsButtonStack)
        
        snsButtonStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(52)
        }

        // 각 버튼의 크기를 동일하게 설정
        [facebookButton, googleButton, kakaoButton].forEach { button in
            button.snp.makeConstraints {
                $0.width.height.equalTo(52)
            }
        }

        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(snsButtonStack.snp.top).offset(-24)
        }
        
        templetView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalToSuperview().multipliedBy(0.3)
        }
    }


}

extension UserLoginVC {
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        // 로그인 성공
//        switch authorization.credential {
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//            // You can create an account in your system.
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//
//            if  let authorizationCode = appleIDCredential.authorizationCode,
//                let identityToken = appleIDCredential.identityToken,
//                let authCodeString = String(data: authorizationCode, encoding: .utf8),
//                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
//            }
//
//            let id = userIdentifier
//            var name = "\(fullName?.givenName ?? "") \(fullName?.familyName ?? "")"
//            let user_email = email ?? ""
//
//            if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//                name = "user\(generateRandomNumber(digits: 8))"
//            }
//            
//            User.shared.updateUserData(id: id, email: user_email, name: name)
//
//            self.getNickname()
//
//        case let passwordCredential as ASPasswordCredential:
//            // Sign in using an existing iCloud Keychain credential.
//            let username = passwordCredential.user
//            let password = passwordCredential.password
//
//        default:
//            break
//        }
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        // 로그인 실패(유저의 취소도 포함)
//        print("login failed - \(error.localizedDescription)")
//    }
//
//    @objc private func appleLogin() {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email] // 유저로 부터 알 수 있는 정보들(name, email)
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }

    @objc private func googleLogin() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if let error = error {
                print("❌ 로그인 실패: \(error.localizedDescription)")
                return
            }

            guard let signInResult = signInResult else {
                print("❗️ signInResult가 nil입니다.")
                return
            }

            let user = signInResult.user
            print("✅ 로그인 성공")

            // 사용자 정보 safely unwrap
            if let emailAddress = user.profile?.email {
                print("📧 이메일: \(emailAddress)")

                if let fullName = user.profile?.name {
                    print("👤 전체 이름: \(fullName)")

                    print("🆔 사용자 ID: \(user.userID ?? "없음")")

                    // User 데이터 업데이트
                    User.shared.updateUserData(id: user.userID ?? "unknown_id",
                                               email: emailAddress,
                                               name: fullName)
                    self.getNickname()
                } else {
                    print("⚠️ 이름 정보를 가져올 수 없습니다.")
                }
            } else {
                print("⚠️ 이메일 정보를 가져올 수 없습니다.")
            }
        }
    }
    
    @objc private func kakaoLogin() {
        // 카카오톡 실행 가능 여부 확인
        kakaoVM.handleKakaoLogin(){ id in
            if let id = id {
                print(id)
                self.getNickname()
            }
        }
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
                if let email = email{
                    print("email: " + email)
                }
                
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
