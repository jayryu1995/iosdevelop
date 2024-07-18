//
//  MyProfileVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/25.
//

import Alamofire
import UIKit
import SnapKit
import FBSDKLoginKit
import FBSDKCoreKit
class MyProfileVC: UIViewController, UITextFieldDelegate {
    let topView = UIView()
    let pictureLabel: UILabel={
        let label = UILabel()
        label.text = "Picture"
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        return label
    }()

    let profileIcon: UIImageView={
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_profile2")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    let nickNameLabel: UILabel={
        let label = UILabel()
        label.text = "Nickname"
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        return label
    }()

    let nickNameTextView: CustomBottomField={
        let textView = CustomBottomField()
        textView.lineColor = UIColor(hex: "#E5E6EA")
        textView.font = UIFont(name: "Pretendard-Medium", size: 16)
        return textView
    }()

    let bioLabel: UILabel={
        let label = UILabel()
        label.text = "Bio"
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        return label
    }()

    let bioTextView: CustomBottomField={
        let textView = CustomBottomField()
        textView.lineColor = UIColor(hex: "#E5E6EA")
        textView.font = UIFont(name: "Pretendard-Medium", size: 16)
        return textView
    }()

    let sizeLabel: UILabel={
        let label = UILabel()
        label.text = "Size Info"
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        return label
    }()

    let heightTextView: CustomBottomField={
        let textView = CustomBottomField()
        textView.lineColor = UIColor(hex: "#E5E6EA")
        textView.font = UIFont(name: "Pretendard-Medium", size: 16)
        return textView
    }()

    let heightLabel: UILabel={
        let label = UILabel()
        label.text = "cm"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        return label
    }()

    let weightTextView: CustomBottomField={
        let textView = CustomBottomField()
        textView.lineColor = UIColor(hex: "#E5E6EA")
        textView.font = UIFont(name: "Pretendard-Medium", size: 16)
        return textView
    }()

    let weightLabel: UILabel={
        let label = UILabel()
        label.text = "kg"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        return label
    }()

    let linkLabel: UILabel={
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.text = "Link"
        return label
    }()

    let linkTextView: CustomBottomField={
        let textView = CustomBottomField()
        textView.lineColor = UIColor(hex: "#E5E6EA")
        textView.font = UIFont(name: "Pretendard-Medium", size: 16)
        return textView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        profileIcon.layer.cornerRadius = profileIcon.frame.size.width / 2
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 화면 이동 이전에 네비게이션 바를 다시 표시
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view?.backgroundColor = .white
        // heightTextView와 weightTextView의 delegate를 설정
        heightTextView.delegate = self
        weightTextView.delegate = self

        // 키보드 타입을 숫자 패드로 설정
        heightTextView.keyboardType = .numberPad
        weightTextView.keyboardType = .numberPad
        loadData()
        setTopView()
        setupTapGesture()
        setView()
        setLayoutConfig()
        setBottomView()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileIconTapped))
        profileIcon.addGestureRecognizer(tapGesture)

    }

    private func setTopView() {
        topView.isUserInteractionEnabled = true
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "back_icon"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        let titleLabel = UILabel()
        titleLabel.text = "Profile"
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)

        let uploadButton = UIButton()
        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.layer.cornerRadius = 16
        uploadButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        uploadButton.backgroundColor = .black
        uploadButton.setTitleColor(.white, for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)

        topView.addSubview(titleLabel)
        topView.addSubview(backButton)
        topView.addSubview(uploadButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()

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

    }

    private func loadData() {
        if let userId = User.shared.id {
            let url = "\(Bundle.main.TEST_URL)/user/sel"

            let parameters: [String: Any] = ["user_id": userId]

            AF.request(url, method: .post, parameters: parameters)
                .responseDecodable(of: UserDto.self) { response in
                    switch response.result {
                    case .success(let userDto):
                        // 서버 응답 처리
                        print("UserDto: \(userDto)")

                        // UserDto에서 원하는 정보를 가져와서 UI 업데이트 등을 수행

                            self.nickNameTextView.text = userDto.nickname ?? "Nickname"
                            self.bioTextView.text = userDto.bio ?? ""
                            self.heightTextView.text = String(userDto.height ?? 0)
                            self.weightTextView.text = String(userDto.weight ?? 0)
                            self.linkTextView.text = userDto.link ?? ""

                            let userId = userDto.id ?? ""
                            let path = "/\(userId)/\(userId).jpg"
                            let url = "\(Bundle.main.TEST_URL)/profile\(path)"
                        print("url : \(url)")
                            self.profileIcon.loadImage(from: url, resizedToWidth: self.profileIcon.frame.size.width)
                            self.profileIcon.layer.cornerRadius = self.profileIcon.frame.size.width / 2
                            // 다른 필요한 정보도 동일한 방식으로 업데이트

                    case .failure(let error):
                        // 오류 처리
                        print("Error: \(error)")
                    }
                }
        }
    }

    private func setBottomView() {
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor(hex: "#F7F7F7")
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.top.equalTo(linkLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        let accountLabel = UILabel()
        accountLabel.text = "Account"
        accountLabel.font = UIFont(name: "Pretendard-Medium", size: 16)
        bottomView.addSubview(accountLabel)
        accountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }

        let logoutButton = UIButton()
        logoutButton.setTitle("Đăng xuất", for: .normal)
        logoutButton.addTarget(self, action: #selector(facebookLogout), for: .touchUpInside)
        logoutButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        logoutButton.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        bottomView.addSubview(logoutButton)
        logoutButton.snp.makeConstraints {
            $0.centerY.equalTo(accountLabel)
            $0.centerX.equalToSuperview()
        }

        let deleteButton = UIButton()
        deleteButton.setTitle("Xoá tài khoản", for: .normal)
        deleteButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        deleteButton.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        bottomView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(accountLabel)
            $0.trailing.equalToSuperview().offset(-20)
        }

        let label = UILabel()
        label.text = "Chúng mình sẽ tiếp tục cập nhật nhiều tính năng mới nha."
        label.textAlignment = .center
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        bottomView.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(accountLabel.snp.bottom).offset(20)
        }
    }

    private func setView() {
        view.addSubview(pictureLabel)
        view.addSubview(profileIcon)
        view.addSubview(nickNameLabel)
        view.addSubview(nickNameTextView)
        view.addSubview(bioLabel)
        view.addSubview(bioTextView)
        view.addSubview(sizeLabel)
        view.addSubview(heightLabel)
        view.addSubview(heightTextView)
        view.addSubview(weightLabel)
        view.addSubview(weightTextView)
        view.addSubview(linkLabel)
        view.addSubview(linkTextView)
    }

    private func setLayoutConfig() {

        pictureLabel.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalToSuperview().dividedBy(3)
            $0.height.equalTo(70)
        }

        profileIcon.snp.makeConstraints {
            $0.centerY.equalTo(pictureLabel)
            $0.leading.equalTo(pictureLabel.snp.trailing)
            $0.width.equalTo(pictureLabel.snp.height)
            $0.height.equalTo(pictureLabel)
        }

        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(pictureLabel.snp.bottom).offset(20)
            $0.leading.equalTo(pictureLabel)
            $0.width.equalTo(pictureLabel)
            $0.height.equalTo(44)
        }

        nickNameTextView.snp.makeConstraints {
            $0.centerY.equalTo(nickNameLabel)
            $0.leading.equalTo(nickNameLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(nickNameLabel)
        }

        bioLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(20)
            $0.leading.equalTo(pictureLabel)
            $0.width.equalTo(pictureLabel)
            $0.height.equalTo(44)
        }

        bioTextView.snp.makeConstraints {
            $0.centerY.equalTo(bioLabel)
            $0.leading.equalTo(bioLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(bioLabel)
        }

        sizeLabel.snp.makeConstraints {
            $0.top.equalTo(bioLabel.snp.bottom).offset(20)
            $0.leading.equalTo(pictureLabel)
            $0.width.equalTo(pictureLabel)
            $0.height.equalTo(44)
        }

        heightTextView.snp.makeConstraints {
            $0.centerY.equalTo(sizeLabel)
            $0.leading.equalTo(sizeLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(sizeLabel)
        }

        heightLabel.snp.makeConstraints {
            $0.center.equalTo(heightTextView)
            $0.height.equalTo(heightTextView)
        }

        weightTextView.snp.makeConstraints {
            $0.top.equalTo(heightTextView.snp.bottom).offset(20)
            $0.leading.equalTo(heightTextView)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(sizeLabel)
        }

        weightLabel.snp.makeConstraints {
            $0.center.equalTo(weightTextView)
            $0.height.equalTo(weightTextView)
        }

        linkLabel.snp.makeConstraints {
            $0.top.equalTo(weightTextView.snp.bottom).offset(20)
            $0.leading.equalTo(pictureLabel)
            $0.width.equalTo(pictureLabel)
            $0.height.equalTo(44)
        }

        linkTextView.snp.makeConstraints {
            $0.centerY.equalTo(linkLabel)
            $0.leading.equalTo(linkLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(linkLabel)
        }
    }

    // 키보드 숨기기
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    // 뒤로가기 버튼 액션
    @objc private func backButtonTapped() {
        print("backbutton on")
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func deleteTapped() {
        let customAlertVC = ProfileAlertVC()
        customAlertVC.modalPresentationStyle = .overCurrentContext
        customAlertVC.modalTransitionStyle = .crossDissolve

        self.present(customAlertVC, animated: true, completion: nil)
    }

    @objc func profileIconTapped() {
        // UIImagePickerController를 사용하여 사진을 가져올 수 있는 라이브러리 화면 열기
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    // 업로드 버튼 액션
    @objc private func uploadButtonTapped() {

        let url = "\(Bundle.main.TEST_URL)/user/update"
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        let nickname = nickNameTextView.text ?? ""
        let user_id = User.shared.id ?? ""
        let height = String(heightTextView.text ?? "0")
        let weight = String(weightTextView.text ?? "0")
        let bio = bioTextView.text ?? ""
        let link = linkTextView.text ?? ""
        let image = profileIcon.image
        // MultipartFormData를 사용하여 요청 생성
        AF.upload(multipartFormData: { multipartFormData in
            // 텍스트 데이터 추가
            multipartFormData.append(Data(user_id.utf8), withName: "user_id")
            multipartFormData.append(Data(nickname.utf8), withName: "nickname")
            multipartFormData.append(Data(bio.utf8), withName: "bio")
            multipartFormData.append(Data(height.utf8), withName: "height")
            multipartFormData.append(Data(weight.utf8), withName: "weight")
            multipartFormData.append(Data(link.utf8), withName: "link")

            if let imageData = image!.jpegData(compressionQuality: 1080) {
                multipartFormData.append(imageData, withName: "image", fileName: "image\(user_id).jpg", mimeType: "image/jpg")
            }

        }, to: url, method: .post, headers: headers).responseString { response in
            switch response.result {
            case .success(let stringValue):

                self.navigationController?.popViewController(animated: true)

            case .failure(let error):
                print("Upload failed with error: \(error)")
            }
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 입력한 문자열이 숫자인지 확인
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)

        // 현재 텍스트 필드의 텍스트와 새로 입력된 문자열을 합친다.
        if let text = textField.text, let range = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: range, with: string)

            // 합친 문자열이 3자리 숫자 이하인지 확인
            if updatedText.count <= 3 && allowedCharacters.isSuperset(of: characterSet) {
                return true
            }
        }

        return false // 3자리를 초과하거나 숫자가 아닌 경우 입력을 막음
    }

    @objc func facebookLogout(_ sender: Any) {
        let id = User.shared.id ?? ""
        if id.contains(".") {

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
    }

}

extension MyProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 이미지를 선택한 후 호출되는 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // 선택한 이미지를 처리하는 코드를 여기에 작성
            profileIcon.image = selectedImage // 선택한 이미지를 프로필 이미지뷰에 표시하거나 다른 처리를 수행할 수 있음
            profileIcon.layer.cornerRadius = profileIcon.frame.size.width / 2
        }

        // 이미지 선택 완료 후 이미지 피커 닫기
        picker.dismiss(animated: true, completion: nil)
    }

    // 이미지 선택이 취소될 때 호출되는 메서드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 이미지 선택 취소 시 필요한 처리를 여기에 작성
        picker.dismiss(animated: true, completion: nil)
    }
}
