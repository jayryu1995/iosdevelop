//
//  LoginViewController.swift
//  ByahtColor
//
//  Created by jaem on 2023/12/20.
//

import SnapKit
import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Alamofire
import Combine
import AuthenticationServices

class LoginVC: UIViewController {

    private var pageViewController: UIPageViewController!
    lazy private var pages = [UIViewController]()
    lazy private var logoImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "logo"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    lazy private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Log in"
        lbl.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        return lbl
    }()
    lazy private var userButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.setTitle("User", for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.setTitleColor(UIColor(hex: "#B5B8C2"), for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    lazy private var businessButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.setTitle("Business", for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.setTitleColor(UIColor(hex: "#B5B8C2"), for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    private let viewModel = MemberViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var stackView: UIStackView!
    lazy private var separatorLine = UIView()
    lazy private var layer1 = CALayer()
    lazy private var layer2 = CALayer()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateButtonBottomLayerFrame()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateButtonBottomLayerFrame()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white

        viewModel.checkServerState { result in
            switch result {
            case .success(let data):
                // Handle successful response
                if data == false {
                    self.log(message: "State : Not Enable Server. Response data: \(data)")
                    self.showServerDownAlert()
                } else {
                    self.setupAutoLogin()
                    self.log(message: "State : Enable Server. Response data: \(data)")
                }

            case .failure(let error):
                // Handle error
                self.log(message: "[Error] Upload Failed. Response data: \(error)")
            }
        }

        setupPages()
        setupButtons()
        setupPageViewController()
        setupButtonBorderLayers()
        setupConstraints()
        setupSeparatorLine()
        // 초기 선택된 버튼의 레이어를 표시
        updateButtonSelection(selectedIndex: 0)
    }

    func showServerDownAlert() {
        let alert = UIAlertController(title: "server_error_title".localized,
                                      message: "server_error_message".localized, preferredStyle: .alert)
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            topController.present(alert, animated: true, completion: nil)
        }
    }

    private func setupAutoLogin() {
        if let token = AccessToken.current,
           !token.isExpired {
            // 토큰 확인 후 계정 정보 수집
            getUserProfile()
        }

        appleUserGet()
        businessGet()
    }

    private func businessGet() {
        if let id = UserDefaults.standard.string(forKey: "businessId") {
            User.shared.id = id
            User.shared.auth = 2

            let vc = TabBarViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
                    self.checkedUser()
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

    private func setupConstraints() {
        view.addSubview(logoImage)
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(pageViewController.view)

        logoImage.snp.makeConstraints { make in
            make.width.equalTo(55)
            make.height.equalTo(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.height.equalTo(34)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

    }

    private func setupButtons() {
        userButton.tag = 0
        businessButton.tag = 1
        userButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        businessButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)

        stackView = UIStackView(arrangedSubviews: [userButton, businessButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
    }

    @objc private func tabButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index >= 0 && index < pages.count else { return }
        pageViewController.setViewControllers([pages[index]], direction: .forward, animated: false, completion: nil)
        updateButtonSelection(selectedIndex: index)
    }

    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        addChild(pageViewController)

        pageViewController.didMove(toParent: self)

        if let firstPage = pages.first {
            pageViewController.setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
        }
    }

    private func setupPages() {
        let page1 = UserLoginVC()
        let page2 = BusinessLoginVC()

        pages.append(page1)
        pages.append(page2)
    }

    private func setupSeparatorLine() {
        separatorLine.backgroundColor = UIColor(hex: "#F4F5F8")
        view.addSubview(separatorLine)

        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
    }

    private func updateButtonSelection(selectedIndex: Int) {
        userButton.isSelected = selectedIndex == 0
        businessButton.isSelected = selectedIndex == 1
        layer1.isHidden = !userButton.isSelected
        layer2.isHidden = !businessButton.isSelected
    }

    // 버튼 layer
    private func setupButtonBorderLayers() {
        layer1.backgroundColor = UIColor.black.cgColor
        layer2.backgroundColor = UIColor.black.cgColor
        userButton.layer.addSublayer(layer1)
        businessButton.layer.addSublayer(layer2)
    }

    private func updateButtonBottomLayerFrame() {
        [userButton, businessButton].forEach { button in
            // 버튼의 타이틀 라벨 크기를 조정

                // 타이틀 라벨의 너비를 바탕으로 바텀 레이어의 프레임 설정
                let layerWidth = button.frame.width
                let layer = button.tag == 0 ? layer1 : layer2
                let layerYPosition = button.frame.height - 3 // 레이어의 y 위치
                layer.frame = CGRect(x: (button.frame.width - layerWidth) / 2, y: layerYPosition, width: layerWidth, height: 3)

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

                self.checkedUser()
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

}

extension LoginVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate,
                   ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController), viewControllerIndex > 0 else {
            return nil
        }
        return pages[viewControllerIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController), viewControllerIndex < pages.count - 1 else {
            return nil
        }
        return pages[viewControllerIndex + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: currentViewController) {
            updateButtonSelection(selectedIndex: index)
        }
    }

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

            self.checkedUser()

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
}
