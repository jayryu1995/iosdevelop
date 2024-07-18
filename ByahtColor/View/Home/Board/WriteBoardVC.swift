//
//  WriteBoardVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/16.
//

import SnapKit
import Alamofire
import UIKit

class WriteBoardVC: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var activityIndicator: UIActivityIndicatorView!
    private let topView = UIView()
    private let backButton = UIImageView()
    private let titleLabel = UILabel()
    private let uploadButton = UIButton()
    private let titleTextView = UITextView()
    private let contentTextView = UITextView()
    private let layerView = UIView()
    private let cameraButton = UIButton()
    private let checkButton = UIButton()
    private let checkLabel = UILabel()
    private var selectedImages: [UIImage] = []
    private var mainScrollView = UIScrollView()
    private var contentView = UIView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 화면 이동 이전에 네비게이션 바를 다시 표시
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setView()
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        titleTextView.delegate = self
        contentTextView.delegate = self  // delegate 설정
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

    }

    private func setView() {
        setTopView()
        setTitleView()
        setLayerView()
        setContentView()
        setCameraButton()
        setCheckButton()
    }

    private func setCheckButton() {
        checkButton.setImage(UIImage(named: "checkbox_icon"), for: .normal)
        checkButton.setImage(UIImage(named: "checkbox_icon2"), for: .selected)
        checkButton.backgroundColor = .white
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)

        checkLabel.text = "Ẩn danh"
        checkLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        checkLabel.textColor = UIColor(hex: "#BCBDC0")

        view.addSubview(checkLabel)
        view.addSubview(checkButton)

        checkLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cameraButton.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
        }

        checkButton.snp.makeConstraints { make in
            make.centerY.equalTo(cameraButton.snp.centerY)
            make.trailing.equalTo(checkLabel.snp.leading).offset(-5)
            make.width.height.equalTo(20)

        }
    }

    private func setCameraButton() {
        cameraButton.setImage(UIImage(named: "icon_camera"), for: .normal)
        cameraButton.backgroundColor = .white
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        view.addSubview(cameraButton)

        cameraButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.width.height.equalTo(32)
            make.leading.equalToSuperview().offset(20)
        }
    }

    private func setContentView() {
        contentTextView.text = "Nhập nội dung."
        contentTextView.textColor = .lightGray
        contentTextView.isUserInteractionEnabled = true
        contentTextView.font = UIFont(name: "Pretendard-Regular", size: 14)
        view.addSubview(contentTextView)

        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(layerView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-100)
        }
    }

    private func  setTopView() {

        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }

        backButton.image = UIImage(named: "back_icon")
        backButton.contentMode = .scaleAspectFit
        backButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButton.addGestureRecognizer(tapGesture)

        titleLabel.text = "Bài viết"
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)

        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.layer.cornerRadius = 16
        uploadButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        uploadButton.backgroundColor = .black
        uploadButton.setTitleColor(.white, for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)

        topView.addSubview(backButton)
        topView.addSubview(titleLabel)
        topView.addSubview(uploadButton)

        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(20)
            make.leading.equalToSuperview().offset(20)
        }

        titleLabel.snp.makeConstraints { make in

            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton.snp.centerY)
        }

        uploadButton.snp.makeConstraints { make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.height.equalTo(24)
            make.width.equalTo(55)
            make.trailing.equalToSuperview().offset(-20)
        }

    }

    private func setTitleView() {
        titleTextView.text = "Đề mục"
        titleTextView.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        titleTextView.isUserInteractionEnabled = true
        titleTextView.textColor = .lightGray
        view.addSubview(titleTextView)

        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
    }

    private func setLayerView() {

        layerView.backgroundColor = .lightGray // 회색 배경 설정

        view.addSubview(layerView)
        layerView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(10) // titleTextView 아래에 위치
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(1) // 높이는 1픽셀로 설정하여 선처럼 보이게 함
        }
    }

    // 뒤로가기 버튼 액션
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func uploadButtonTapped() {
        self.activityIndicator.startAnimating()
        let url = "\(Bundle.main.TEST_URL)/board/insert"
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        let user_id = User.shared.id ?? ""

        var nickname = ""
        if checkButton.isSelected {
            nickname = User.shared.nickname ?? "Ẩn danh"
        } else {
            nickname = "Ẩn danh"
        }

        // MultipartFormData를 사용하여 요청 생성
        AF.upload(multipartFormData: { multipartFormData in
            // 텍스트 데이터 추가
            multipartFormData.append(Data(user_id.utf8), withName: "user_id")
            multipartFormData.append(Data(nickname.utf8), withName: "nickname")
            multipartFormData.append(Data(self.contentTextView.text.utf8), withName: "content")
            multipartFormData.append(Data(self.titleTextView.text.utf8), withName: "title")

            // 이미지 데이터 추가
            for (index, image) in self.selectedImages.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 1080) {
                    multipartFormData.append(imageData, withName: "images", fileName: "image\(index).jpg", mimeType: "image/jpg")
                }
            }
        }, to: url, method: .post, headers: headers).responseString { response in
            switch response.result {
            case .success(let stringValue):
                self.activityIndicator.stopAnimating()
                self.navigationController?.popViewController(animated: true)

            case .failure(let error):
                self.log(message: "Upload failed with error: \(error)")
            }
        }
    }

    @objc private func checkButtonTapped() {
        checkButton.isSelected = !checkButton.isSelected  // 버튼의 선택 상태를 토글
        checkLabel.textColor = checkButton.isSelected ? UIColor(hex: "#935DFF") : UIColor(hex: "#BCBDC0")
    }

    // UITextViewDelegate 메서드
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == titleTextView && textView.text == "Đề mục" {
            textView.text = ""
            textView.textColor = .black
        } else if textView == contentTextView && textView.text == "Nhập nội dung." {
            textView.text = ""
            textView.textColor = .black
        }
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                let height = keyboardSize.height - 20
                // Adjust the constraint or frame for cameraButton, checkLabel, and checkButton
                // For example:
                cameraButton.snp.updateConstraints { make in
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-height)
                }

                contentTextView.snp.remakeConstraints { make in
                    make.top.equalTo(layerView.snp.bottom).offset(10)
                    make.leading.equalToSuperview().offset(20)
                    make.trailing.equalToSuperview().offset(-20)
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-height)
                }
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        cameraButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        contentTextView.snp.remakeConstraints { make in
            make.top.equalTo(layerView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-100)
        }
    }

    // 카메라 버튼
    @objc private func cameraButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary // .camera를 사용하려면 실제 디바이스가 필요합니다.
        self.present(imagePickerController, animated: true, completion: nil)
    }

    // UIImagePickerControllerDelegate 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImages.append(selectedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    private func validateInputs() -> String? {

        // 모든 검사를 통과한 경우
        return nil
    }
}
