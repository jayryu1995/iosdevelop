//
//  TalkModifyVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/16.
//

import SnapKit
import Alamofire
import UIKit
import Kingfisher

class TalkModifyVC: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var activityIndicator: UIActivityIndicatorView!
    private let topView = UIView()
    private let backButton = UIImageView()
    private let titleLabel = UILabel()
    private let uploadButton = UIButton()
    private let titleTextView = UITextView()
    private let contentTextView = UITextView()
    private let layerView = UIView()
    private let cameraButton = UIButton()
    private let checkLabel = UILabel()
    lazy private var selectedImages: [UIImage] = []
    lazy private var mainScrollView = UIScrollView()
    lazy private var contentView = UIView()
    lazy private var imageContainerView = UIView()
    lazy private var imageScrollView = UIScrollView()
    var board : Talk?
    
    
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
        loadImagesIntoSelectedImages()
        view.backgroundColor = .white
        setView()
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        titleTextView.delegate = self
        contentTextView.delegate = self  // delegate 설정
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

    }

    private func loadImagesIntoSelectedImages() {
        // Optional binding으로 이미지 리스트가 있는지 확인
        guard let imageList = board?.imageList else { return }
        
        // 이미지 리스트를 순회하며 URL을 생성하고, 이미지를 로드
        for imageUrl in imageList {
            loadImageAndAppendToSelected(from: imageUrl)
        }
    }

    private func loadImageAndAppendToSelected(from urlString: String) {
        // URL이 유효한지 확인
        guard let url = URL(string: urlString) else {
            print("Invalid URL string: \(urlString)")
            return
        }
        ImageCache.default.removeImage(forKey: urlString) {
                print("Image cache cleared for URL: \(urlString)")
            }
        // Kingfisher를 이용하여 이미지를 로드하고 배열에 추가
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                // 성공적으로 로드된 이미지를 배열에 추가
                DispatchQueue.main.async {
                    self.selectedImages.append(value.image)
                    self.addImagesToScrollView(images: self.selectedImages)
                }
            case .failure(let error):
                // 이미지 로드 실패 시 에러 처리
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
    
    private func setView() {
        setTopView()
        setCameraButton()
        setMainScrollView()
        setTitleView()
        setLayerView()
        setImageScrollView()
        setTextView()
        
    }
    
    private func setImageScrollView() {
        // 가로 스크롤 뷰 설정
        imageScrollView.isPagingEnabled = false
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.alwaysBounceHorizontal = true
        imageScrollView.backgroundColor = .clear
        contentView.addSubview(imageScrollView)
        imageScrollView.snp.makeConstraints { make in
            make.top.equalTo(layerView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(0)
        }
        
        // 이미지 컨테이너 뷰를 imageScrollView에 추가하여 이미지들을 배치
        imageScrollView.addSubview(imageContainerView)
        imageContainerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
    }
    
    private func setMainScrollView() {
        mainScrollView.isUserInteractionEnabled = true
        view.addSubview(mainScrollView)
        
        mainScrollView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(cameraButton.snp.top).offset(-10)
            make.leading.trailing.equalToSuperview()
        }
        
        // contentView를 mainScrollView에 추가
        mainScrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.height.equalToSuperview() // mainScrollView의 가장자리에 맞춤
            make.width.equalToSuperview() // contentView의 가로 길이를 mainScrollView와 같게 설정
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

    private func setTextView() {
        contentTextView.text = board?.content ?? "talk_write_content".localized
        contentTextView.textColor = .lightGray
        contentTextView.isUserInteractionEnabled = true
        contentTextView.font = UIFont(name: "Pretendard-Regular", size: 14)
        contentView.addSubview(contentTextView)

        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
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

        titleLabel.text = "talk_write_navigation".localized
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
        
        titleTextView.text = board?.title ?? "talk_write_title".localized
        titleTextView.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        titleTextView.isUserInteractionEnabled = true
        titleTextView.textColor = .lightGray
        contentView.addSubview(titleTextView)

        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
    }

    private func setLayerView() {
        layerView.backgroundColor = .lightGray // 회색 배경 설정
        contentView.addSubview(layerView)
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
        let url = "\(Bundle.main.TEST_URL)/board/update"
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        let user_id = User.shared.id ?? ""
        let name = User.shared.name ?? ""
        let no = board?.no?.toString() ?? ""
        
        
        
        // MultipartFormData를 사용하여 요청 생성
        AF.upload(multipartFormData: { multipartFormData in
            // 텍스트 데이터 추가
            multipartFormData.append(Data(no.utf8), withName: "no")
            multipartFormData.append(Data(user_id.utf8), withName: "user_id")
            multipartFormData.append(Data(name.utf8), withName: "nickname")
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

    // UITextViewDelegate 메서드
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == titleTextView && textView.text == "talk_write_title".localized {
            textView.text = ""
            textView.textColor = .black
        } else if textView == contentTextView && textView.text == "talk_write_content".localized {
            textView.text = ""
            textView.textColor = .black
        }
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                let keyboardHeight = keyboardSize.height - view.safeAreaInsets.bottom
                print(keyboardHeight)
                cameraButton.snp.updateConstraints { make in
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardHeight)
                }
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        cameraButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func addImagesToScrollView(images: [UIImage]) {
        if images.isEmpty {
                imageScrollView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            } else {
                imageScrollView.snp.updateConstraints { make in
                    make.height.equalTo(188)  // 이미지 스크롤뷰의 높이 설정 (100은 예시입니다. 원하는 높이로 조정하세요)
                }
            }
        imageContainerView.subviews.forEach { $0.removeFromSuperview() }
        // 스크롤 뷰에 이미지 추가
        var previousImageView: UIImageView? = nil

        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            imageContainerView.addSubview(imageView)
            
            // 제거 버튼 추가
            let removeButton = UIButton()
            removeButton.setImage(UIImage(named: "icon_close"), for: .normal)
            removeButton.addTarget(self, action: #selector(removeImage), for: .touchUpInside)
            removeButton.tag = index
            imageView.addSubview(removeButton)

            // 제거 버튼 제약 조건
            removeButton.snp.makeConstraints { make in
                make.top.right.equalToSuperview().inset(10)
                make.width.height.equalTo(30)
            }
            
            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(188)  // 이미지의 너비 설정
                if let previous = previousImageView {
                    make.leading.equalTo(previous.snp.trailing).offset(10)
                } else {
                    make.leading.equalToSuperview()
                }
            }

            previousImageView = imageView
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
            addImagesToScrollView(images: selectedImages)
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
    
    // 이미지 제거 메소드
    @objc private func removeImage(_ sender: UIButton) {
        print("삭제")
        let index = sender.tag
        if !selectedImages.isEmpty {
            selectedImages.remove(at: index)
            
            // 남은 이미지들로 스크롤뷰를 다시 채움
            addImagesToScrollView(images: selectedImages)
        }
        
    }
}
