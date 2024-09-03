//
//  InfluenceMyPageWriteVC.swift
//  ByahtColor
//
//  Created by jaem on 6/26/24.
//

import UIKit
import SnapKit
import FBSDKLoginKit
import Combine

class InfluenceMyPageWriteVC: UIViewController {
    private let navigationView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let uploadButton = UIButton()
    private let bottomView = UIView()
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_plus"), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        return button
    }()
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "icon_profile2")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "influence_mypage_write_info".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "influence_mypage_write_name".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    private let nameLabel2: UILabel = {
        let label = UILabel()
        label.text = "influence_mypage_write_name2".localized
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "Pretendard-Regular", size: 14)
        tf.layer.cornerRadius = 4
        tf.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        tf.layer.borderWidth = 1
        tf.leftPadding()
        return tf
    }()

    private let telLabel: UILabel = {
        let label = UILabel()
        label.text = "influence_mypage_write_tel".localized // 여기서 "전화번호"는 로컬라이즈된 문자열이라 가정합니다.
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let telLabel2: UILabel = {
        let label = UILabel()
        label.text = "influence_mypage_write_tel2".localized // 추가 설명을 위한 로컬라이즈된 문자열
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    private let telTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "Pretendard-Regular", size: 14)
        tf.layer.cornerRadius = 4
        tf.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        tf.layer.borderWidth = 1
        tf.leftPadding()
        tf.keyboardType = .numberPad
        return tf
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "influence_mypage_write_address".localized // 여기서 "주소"는 로컬라이즈된 문자열이라 가정합니다.
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let addressLabel2: UILabel = {
        let label = UILabel()
        label.text = "influence_mypage_write_address2".localized // 추가 설명을 위한 로컬라이즈된 문자열
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    private let addressTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "influence_mypage_write_address_hint".localized // 필요에 따라 placeholder 설정
        tf.font = UIFont(name: "Pretendard-Regular", size: 14)
        tf.layer.cornerRadius = 4
        tf.leftPadding()
        tf.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        tf.layer.borderWidth = 1
        return tf
    }()

    private let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "influence_mypage_write_account".localized // 여기서 "계좌번호"는 로컬라이즈된 문자열이라 가정합니다.
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let accountLabel2: UILabel = {
        let label = UILabel()
        label.text = "influence_mypage_write_account2".localized // 추가 설명을 위한 로컬라이즈된 문자열
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    private let accountTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "influence_mypage_write_account_hint".localized // 필요에 따라 placeholder 설정
        tf.font = UIFont(name: "Pretendard-Regular", size: 14)
        tf.layer.cornerRadius = 4
        tf.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        tf.layer.borderWidth = 1
        tf.keyboardType = .numberPad
        tf.leftPadding()
        return tf
    }()

    private var selectedImage: UIImage?
    private let viewModel = InfluenceViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let id = User.shared.id else { return }
        viewModel.getMyAccount(id: id)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 화면 이동 이전에 네비게이션 바를 다시 표시
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileButton.layer.cornerRadius = profileButton.frame.size.width / 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindingView()
        setupUI()
        setupConstraints()
        setupGesture()

    }

    private func setupBindingView() {
        viewModel.$accountData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let data = data else { return }
                self?.nameTextField.text = data.name ?? ""
                self?.accountTextField.text = data.account ?? ""
                self?.telTextField.text = data.tel ?? ""
                self?.addressTextField.text = data.address ?? ""
                let url = "\(Bundle.main.TEST_URL)/img\( data.imagePath ?? "" )"
                print(url)
                self?.profileImage.loadImage2(from: url)
            }
            .store(in: &cancellables)

    }

    private func setupUI() {
        view.addSubview(navigationView)
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        setupNaviagtionView()
        setupContentView()
    }

    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.addSubview(topLabel)
        contentView.addSubview(profileButton)
        contentView.addSubview(profileImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameLabel2)
        contentView.addSubview(nameTextField)
        contentView.addSubview(telLabel)
        contentView.addSubview(telLabel2)
        contentView.addSubview(telTextField)
        contentView.addSubview(addressLabel)
        contentView.addSubview(addressLabel2)
        contentView.addSubview(addressTextField)
        contentView.addSubview(accountLabel)
        contentView.addSubview(accountLabel2)
        contentView.addSubview(accountTextField)
        contentView.addSubview(bottomView)

        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)

        setupBottomView()
    }

    private func setupBottomView() {
        bottomView.backgroundColor = UIColor(hex: "#F4F5F8")
        let label = UILabel()
        label.text = "influence_mypage_write_info2".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#4E505B")

        let logoutButton = UIButton()
        logoutButton.setTitle("influence_mypage_write_logout".localized, for: .normal)
        logoutButton.setImage(UIImage(named: "logout_icon"), for: .normal)
        logoutButton.addTarget(self, action: #selector(facebookLogout), for: .touchUpInside)
        logoutButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        logoutButton.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        logoutButton.backgroundColor = UIColor(hex: "#F7F7F7")
        logoutButton.layer.cornerRadius = 4

        let deleteButton = UIButton()
        deleteButton.setTitle("influence_mypage_write_secession".localized, for: .normal)
        deleteButton.setImage(UIImage(named: "secession_icon"), for: .normal)
        deleteButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        deleteButton.setTitleColor(UIColor.red, for: .normal) // 텍스트 색상을 빨강으로 설정
        deleteButton.backgroundColor = UIColor(hex: "#F7F7F7")
        deleteButton.layer.cornerRadius = 4

        bottomView.addSubview(label)
        bottomView.addSubview(logoutButton)
        bottomView.addSubview(deleteButton)

        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        }

        logoutButton.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(106)
            $0.height.equalTo(44)
        }

        deleteButton.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(106)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().offset(-9)
        }
    }

    private func setupConstraints() {
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.center.equalToSuperview()
        }

        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalToSuperview().offset(20)
        }

        uploadButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.height.equalTo(24)
            make.width.equalTo(55)
            make.trailing.equalToSuperview().offset(-20)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.greaterThanOrEqualTo(scrollView).priority(.low)
        }

        topLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        profileButton.snp.makeConstraints {
            $0.top.equalTo(topLabel.snp.bottom).offset(32)
            $0.trailing.equalTo(view.snp.centerX).offset(-4)
            $0.width.height.equalTo(80)
        }

        profileImage.snp.makeConstraints {
            $0.top.equalTo(topLabel.snp.bottom).offset(32)
            $0.leading.equalTo(view.snp.centerX).offset(4)
            $0.width.height.equalTo(80)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }

        nameLabel2.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(20)
        }

        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel2.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }

        telLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }

        telLabel2.snp.makeConstraints {
            $0.top.equalTo(telLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(20)
        }

        telTextField.snp.makeConstraints {
            $0.top.equalTo(telLabel2.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }

        addressLabel.snp.makeConstraints {
            $0.top.equalTo(telTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }

        addressLabel2.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(20)
        }

        addressTextField.snp.makeConstraints {
            $0.top.equalTo(addressLabel2.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }

        accountLabel.snp.makeConstraints {
            $0.top.equalTo(addressTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }

        accountLabel2.snp.makeConstraints {
            $0.top.equalTo(accountLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(20)
        }

        accountTextField.snp.makeConstraints {
            $0.top.equalTo(accountLabel2.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }

        bottomView.snp.makeConstraints {
            $0.top.equalTo(accountTextField.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }

    private func setupNaviagtionView() {

        navigationView.isUserInteractionEnabled = true

        backButton.setImage(UIImage(named: "icon_Arrow"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        titleLabel.text = "My Page"
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)

        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        uploadButton.backgroundColor = .black
        uploadButton.layer.cornerRadius = 12
        uploadButton.setTitleColor(.white, for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)

        navigationView.addSubview(titleLabel)
        navigationView.addSubview(backButton)
        navigationView.addSubview(uploadButton)
    }

    @objc private func profileButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.sourceType = .photoLibrary // 또는 .camera
        present(imagePickerController, animated: true)
    }

    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: false)
    }

    @objc private func uploadButtonTapped() {
        updateAccount()
        self.navigationController?.popViewController(animated: false)
    }

    private func updateAccount() {
        let dto = InfluenceMyPageDto(
            name: nameTextField.text, tel: telTextField.text, account: accountTextField.text,
            address: addressTextField.text, imagePath: nil
        )
        if let id = User.shared.id {
            viewModel.updateMyAccount(memberId: id, dto: dto, image: selectedImage) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        print("통신 성공")
                        // data변경 알림
                        NotificationCenter.default.post(name: .dataChanged, object: nil)
                        User.shared.name = "\(dto.name ?? "")"
                        if let id = User.shared.id {
                            let url = "\(Bundle.main.TEST_URL)/img/profile/\(id).jpg"
                            ImageCacheManager.shared.removeImage(for: url)
                        }
                        self?.updateChatProfile()

                        self?.navigationController?.popViewController(animated: false)
                    case .failure(let error):
                        print("통신 에러 : \(error)")

                    }
                }
            }
        }
    }

    private func updateChatProfile() {
        var imagePath: String?
        if User.shared.auth ?? 0 < 2 {
            imagePath = "\(Bundle.main.TEST_URL)/img/profile/\(User.shared.id ?? "").jpg"
        } else {
            imagePath = "\(Bundle.main.TEST_URL)/business/profile/\(User.shared.id ?? "").jpg"
        }

        if let name = User.shared.name {
            SendbirdUser.shared.updateUserInfo(nickname: name, profileImage: imagePath) { result in
                switch result {
                case .success(let user):
                    print("업데이트 성공")
                case .failure(let error):
                    print("error : \(error)")
                }
            }
        }
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        let keyboardHeight = keyboardFrame.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        var visibleRect = view.frame
        visibleRect.size.height -= keyboardHeight
        if let activeTextView = UIResponder.currentFirstResponder as? UITextView {
            let textViewRect = activeTextView.convert(activeTextView.bounds, to: view)
            if !visibleRect.contains(textViewRect.origin) {
                scrollView.scrollRectToVisible(textViewRect, animated: true)
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        UIView.animate(withDuration: animationDuration) {
            self.scrollView.contentInset = .zero
            self.scrollView.scrollIndicatorInsets = .zero
        }
    }

    @objc func facebookLogout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "businessId")
        let loginManager = LoginManager()
        loginManager.logOut()
        SendbirdUser.shared.logout {
            print("sendbird 로그아웃 완료")
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

    @objc private func deleteTapped() {
        let customAlertVC = ProfileAlertVC()
        customAlertVC.modalPresentationStyle = .overCurrentContext
        customAlertVC.modalTransitionStyle = .crossDissolve

        self.present(customAlertVC, animated: true, completion: nil)
    }

}

extension InfluenceMyPageWriteVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
            self.profileImage.image = selectedImage
        }

        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
