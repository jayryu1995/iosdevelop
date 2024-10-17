//
//  McnMyPageWriteVC.swift
//  ByahtColor
//
//  Created by jaem on 9/30/24.
//

import UIKit
import SnapKit
import FBSDKLoginKit
import Combine
import Kingfisher

class McnMyPageWriteVC: UIViewController {
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
        label.text = "mcn_mypage_write_info".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        return label
    }()
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "mcn_mypage_write_logo".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label.appendRedStar()
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "mcn_mypage_write_name".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        label.appendRedStar()
        return label
    }()
    private let nameLabel2: UILabel = {
        let label = UILabel()
        label.text = "mcn_mypage_write_name2".localized
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
        label.text = "mcn_mypage_write_tel".localized // 여기서 "전화번호"는 로컬라이즈된 문자열이라 가정합니다.
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let telLabel2: UILabel = {
        let label = UILabel()
        label.text = "mcn_mypage_write_tel2".localized // 추가 설명을 위한 로컬라이즈된 문자열
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
        label.text = "mcn_mypage_write_address".localized // 여기서 "주소"는 로컬라이즈된 문자열이라 가정합니다.
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let addressTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "mcn_mypage_write_address_hint".localized // 필요에 따라 placeholder 설정
        tf.font = UIFont(name: "Pretendard-Regular", size: 14)
        tf.layer.cornerRadius = 4
        tf.leftPadding()
        tf.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        tf.layer.borderWidth = 1
        return tf
    }()

    private lazy var accountLabel: UILabel = {
        let label = UILabel()
        let text = "계정 상태 변경"
        let attributedString = NSAttributedString(string: text, attributes: [
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        label.attributedText = attributedString
        label.textColor = UIColor(hex: "#4E505B")
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textAlignment = .center // Align text to center (optional)
        return label
    }()

    private var selectedImage: UIImage?
    private let viewModel = McnViewModel()
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
                self?.telTextField.text = data.tel ?? ""
                self?.addressTextField.text = data.address ?? ""
                
                if let resource = data.imagePath{
                    let url = URL(string: resource)
                    self?.profileImage.kf.setImage(with:url)
                }
                
            }
            .store(in: &cancellables)

    }

    private func setupUI() {
        scrollView.showsVerticalScrollIndicator = false
        accountLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(accountTapped))
        accountLabel.addGestureRecognizer(tapGesture)
        
        view.addSubview(scrollView)
        view.addSubview(navigationView)
        view.addSubview(accountLabel)
        
        
        setupNaviagtionView()
        setupContentView()
        
        
    }

    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.addSubview(logoLabel)
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
        contentView.addSubview(addressTextField)

        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)

    
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

        accountLabel.snp.makeConstraints{
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(14)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(accountLabel.snp.top)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        topLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        logoLabel.snp.makeConstraints{
            $0.top.equalTo(topLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(24)
        }
        
        profileButton.snp.makeConstraints {
            $0.top.equalTo(logoLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.width.height.equalTo(80)
        }

        profileImage.snp.makeConstraints {
            $0.top.equalTo(logoLabel.snp.bottom).offset(8)
            $0.leading.equalTo(profileButton.snp.trailing).offset(8)
            $0.width.height.equalTo(80)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(24)
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
            $0.height.equalTo(24)
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
            $0.height.equalTo(24)
        }

        addressTextField.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
            $0.bottom.equalTo(contentView.snp.bottom)
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
        let dto = McnMyPageDto(id:User.shared.id ?? "",
            name: nameTextField.text, tel: telTextField.text,
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
                            if let url = self?.viewModel.accountData?.imagePath{
                                ImageCacheManager.shared.removeImage(for: url)
                            }
                        }
                                    self?.navigationController?.popViewController(animated: false)
                    case .failure(let error):
                        print("통신 에러 : \(error)")

                    }
                }
            }
        }
    }

    @objc private func accountTapped(){
        let vc = BusinessAccountVC()
        navigationController?.pushViewController(vc, animated: false)
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

}

extension McnMyPageWriteVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

