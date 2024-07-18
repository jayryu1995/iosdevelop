//
//  ReviewWriteVC.swift
//  ByahtColor
//
//  Created by jaem on 3/29/24.
//

import UIKit
import SnapKit
import FloatingPanel
import Alamofire

class ReviewWriteVC: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate {
    private let scrollView = UIScrollView()
    private let accessImageLabel: UILabel = {
        let label = UILabel()
        label.text = "review_write_image".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let imageButton: UIButton = {
        let image = UIButton()
        image.setImage(UIImage(named: "icon_plus"), for: .normal)
        image.backgroundColor = UIColor(hex: "#F7F7F7")
        image.layer.cornerRadius = 16
        return image
    }()

    private let imageLabel: UILabel = {
        let label = UILabel()
        label.text = "review_write_image2".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        label.textColor = UIColor(hex: "#535358")
        label.numberOfLines = 2
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "review_write_email".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let emailField: UnderlinedTextField = {
        let field = UnderlinedTextField()
        field.configure(withPlaceholder: "review_write_email_hint".localized, font: UIFont(name: "Pretendard-Regular", size: 14))
        return field
    }()

    private let linkLabel: UILabel = {
        let label = UILabel()
        label.text = "review_write_link".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let linkField: UnderlinedTextField = {
        let field = UnderlinedTextField()
        field.configure(withPlaceholder: "review_write_link_hint".localized, font: UIFont(name: "Pretendard-Regular", size: 14))
        return field
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "review_write_name".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let nameField: UnderlinedTextField = {
        let field = UnderlinedTextField()
        field.configure(withPlaceholder: "review_write_name_hint".localized, font: UIFont(name: "Pretendard-Regular", size: 14))
        return field
    }()

    private let snsIdLabel: UILabel = {
        let label = UILabel()
        label.text = "review_write_sns".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let snsIdField: UnderlinedTextField = {
        let field = UnderlinedTextField()
        field.configure(withPlaceholder: "review_write_sns_hint".localized, font: UIFont(name: "Pretendard-Regular", size: 14))
        return field
    }()

    private let submitButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.backgroundColor = UIColor(hex: "#BCBDC0")
        button.setTitleColor(.white, for: .normal)
        button.setTitle("review_write_button", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Mideum", size: 14)
        button.layer.cornerRadius = 4
        return button
    }()
    private let middleView = UIScrollView()
    private var selectedImages: [UIImage] = []
    private var snsButtons = [UIButton]()
    private var selectedSns: String = ""
    private var activityIndicator: UIActivityIndicatorView!
    var tags: [String] = []
    var collab_no = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBackButton2()
        self.navigationItem.title = "Gửi đánh giá"
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        emailField.delegate = self
        linkField.delegate = self
        nameField.delegate = self
        snsIdField.delegate = self

        view.addSubview(scrollView)
        view.addSubview(submitButton)

        scrollView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview()
        }

        submitButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().offset(-20)
        }

        setScrollContentView()
        setImageView()

        // 화면 탭 시 키보드 숨김 추가
        setupHideKeyboardOnTap()

        // 스피너 초기화 및 설정
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
    }

    private func setScrollContentView() {

        middleView.delegate = self
        middleView.showsHorizontalScrollIndicator = false
        middleView.isPagingEnabled = false
        middleView.translatesAutoresizingMaskIntoConstraints = false

        submitButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)

        scrollView.addSubview(accessImageLabel)
        scrollView.addSubview(middleView)
        scrollView.addSubview(imageLabel)
        scrollView.addSubview(emailField)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(linkField)
        scrollView.addSubview(linkLabel)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(nameField)
        scrollView.addSubview(snsIdField)
        scrollView.addSubview(snsIdLabel)

        // SNS 필터 뷰 추가
        let snsFilterView = snsFilterView(tags: tags)
        scrollView.addSubview(snsFilterView)

        accessImageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview()
        }

        imageLabel.snp.makeConstraints {
            $0.top.equalTo(accessImageLabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview()
        }

        middleView.snp.makeConstraints {
            $0.top.equalTo(imageLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view).inset(20)
            $0.height.equalTo(view.frame.width/2)
        }

        snsFilterView.snp.makeConstraints { make in
            make.top.equalTo(middleView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        snsIdLabel.snp.makeConstraints {
            $0.top.equalTo(snsFilterView.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }

        snsIdField.snp.makeConstraints {
            $0.top.equalTo(snsIdLabel.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }

        linkLabel.snp.makeConstraints {
            $0.top.equalTo(snsIdField.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }

        linkField.snp.makeConstraints {
            $0.top.equalTo(linkLabel.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(linkField.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }

        nameField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }

        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nameField.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }

        emailField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().offset(-102)
        }

    }

    // 유효성 검사
    private func validateSubmissionCriteria() {
        let textFieldsAreValid = !(emailField.text?.isEmpty ?? true) &&
        !(nameField.text?.isEmpty ?? true) &&
        !(snsIdField.text?.isEmpty ?? true) &&
        !(emailField.text?.isEmpty ?? true) &&
        !(linkField.text?.isEmpty ?? true)

        let snsIsSelected = !(selectedSns.isEmpty)
        let imagesAreSelected = !selectedImages.isEmpty

        submitButton.isEnabled = textFieldsAreValid && snsIsSelected && imagesAreSelected
        submitButton.backgroundColor = submitButton.isEnabled ? UIColor.black : .gray
        if submitButton.isEnabled {
            submitButton.setTitle("ĐĂNG KÝ", for: .normal)
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }

    private func createHorizontalStackView(tags: [String]) -> UIStackView {
           let horizontalStackView = UIStackView()
           horizontalStackView.axis = .horizontal
           horizontalStackView.distribution = .fillProportionally
           horizontalStackView.alignment = .fill
           horizontalStackView.spacing = 5
           horizontalStackView.isUserInteractionEnabled = true
           for tagName in tags {
               let tagButton = UIButton()
               tagButton.setTitle(tagName, for: .normal)
               tagButton.backgroundColor = .white
               tagButton.setTitleColor(.black, for: .normal)
               tagButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
               tagButton.layer.cornerRadius = 16
               tagButton.layer.borderWidth = 1
               tagButton.layer.borderColor = UIColor.darkGray.cgColor
               tagButton.isUserInteractionEnabled = true

               tagButton.addTarget(self, action: #selector(snsButtonTapped), for: .touchUpInside)
               horizontalStackView.addArrangedSubview(tagButton)
               snsButtons.append(tagButton)

               tagButton.snp.makeConstraints {
                   $0.height.equalTo(32)
               }
           }

           return horizontalStackView
       }

    // SNS 선택
    @objc private func snsButtonTapped(_ sender: UIButton) {
        // 선택된 스타일의 상태를 업데이트합니다.
        if sender.isSelected {
            // 현재 버튼이 이미 선택된 상태라면 선택을 해제합니다.
            sender.isSelected = false
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            selectedSns = ""
        } else {
            // 모든 버튼을 순회하며 상태를 업데이트합니다.
            snsButtons.forEach { button in
                // 현재 탭된 버튼만 선택된 상태로 설정하고, 나머지는 해제합니다.
                let isSelected = (button == sender)
                button.isSelected = isSelected
                button.backgroundColor = isSelected ? .black : .white
                button.setTitleColor(isSelected ? .white : .black, for: .normal)

                // 선택된 SNS를 업데이트합니다.
                if isSelected {
                    selectedSns = sender.titleLabel?.text ?? ""
                }
            }
        }
    }

    private func setImageView() {
        imageButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        middleView.addSubview(imageButton)
        imageButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(view.frame.width/2)
        }

    }

    @objc private func buttonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary // 또는 .camera
        present(imagePickerController, animated: true)
    }

    private func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // 이 옵션은 다른 컨트롤(예: 버튼)에 대한 탭을 방해하지 않도록 설정
        view.addGestureRecognizer(tapGesture)
    }

    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setScrollView() {
        middleView.subviews.forEach { subview in
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }

        var totalWidth: CGFloat = 20 // 초기 여백
        let imageWidth = view.bounds.width/2
        for (index, image) in selectedImages.reversed().enumerated() {
            let imageView = UIImageView(image: image)
            imageView.tag = selectedImages.count - 1 - index
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 8
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            middleView.addSubview(imageView)

            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.width.equalTo(imageWidth)
                make.leading.equalToSuperview().offset(totalWidth)
            }

            totalWidth += imageWidth + 20 // 이미지 너비와 여백을 더함

            // 지우기 버튼
            let closeButton = UIButton()
            closeButton.setImage(UIImage(named: "icon_close"), for: .normal)
            closeButton.tag = imageView.tag
            closeButton.addTarget(self, action: #selector(removeImage(_:)), for: .touchUpInside)
            imageView.addSubview(closeButton)
            closeButton.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.top.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().offset(-10)
            }
        }

        // 버튼 위치 조정
        imageButton.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(totalWidth)
            make.height.width.equalTo(imageWidth)
        }
        totalWidth += view.safeAreaLayoutGuide.layoutFrame.width * 0.4 + 20

        // 스크롤뷰의 contentSize 업데이트
        middleView.contentSize = CGSize(width: totalWidth, height: imageWidth)
    }

    // 추가된 이미지 제거
    @objc private func removeImage(_ sender: UIButton) {
        guard let imageView = sender.superview as? UIImageView else { return }

        // 이미지뷰 제거
        imageView.removeFromSuperview()

        // 선택된 이미지 목록에서 해당 이미지 제거
        let indexToRemove = selectedImages.count - 1 - sender.tag
        if indexToRemove < selectedImages.count {
            selectedImages.remove(at: indexToRemove)
        }

        // 스크롤뷰에 남아있는 이미지뷰들의 레이아웃을 다시 조정
        setScrollView()
    }

    private func snsFilterView(tags: [String]) -> UIView {
        let container = createFilterViewContainer(withTitle: "Nền tảng của ảnh đã đăng", tags: tags)
        return container
    }

    private func createFilterViewContainer(withTitle title: String, tags: [String]) -> UIView {
        let container = UIView()
        container.isUserInteractionEnabled = true

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        container.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalSpacing
        verticalStackView.alignment = .fill
        verticalStackView.spacing = 10
        verticalStackView.isUserInteractionEnabled = true

        // 모든 태그를 처리하도록 개선
        let rows = tags.chunked(into: tags.count) // 태그 배열을 4개 단위로 분할
        for rowTags in rows {
            let rowStackView = createHorizontalStackView(tags: rowTags)
            verticalStackView.addArrangedSubview(rowStackView)
        }

        container.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview() // VerticalStackView의 바텀을 container의 바텀에 연결
        }

        return container
    }

    // 업로드 버튼 액션
    private func uploadContents() {

        self.activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false

        let url = "\(Bundle.main.TEST_URL)/collab/review/insert"
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        let user_id = User.shared.id ?? ""
        let name: String = nameField.text!
        let sns_id: String = snsIdField.text!
        let sns: String = selectedSns
        let email: String = emailField.text!
        let link: String = linkField.text!
        let collab_no: String = "\(collab_no)"

        // MultipartFormData를 사용하여 요청 생성
        AF.upload(multipartFormData: { multipartFormData in
            // 텍스트 데이터 추가
            multipartFormData.append(Data(user_id.utf8), withName: "user_id")
            multipartFormData.append(Data(collab_no.utf8), withName: "collab_no")
            multipartFormData.append(Data(name.utf8), withName: "name")
            multipartFormData.append(Data(sns_id.utf8), withName: "sns_id")
            multipartFormData.append(Data(sns.utf8), withName: "sns")
            multipartFormData.append(Data(email.utf8), withName: "email")
            multipartFormData.append(Data(link.utf8), withName: "link")

            // 이미지 데이터 추가
            for (index, image) in self.selectedImages.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 1080) {
                    multipartFormData.append(imageData, withName: "images", fileName: "image\(index).jpg", mimeType: "image/jpg")
                }
            }
        }, to: url, method: .post, headers: headers).responseString { response in
            switch response.result {
            case .success(let stringValue):
                self.view.isUserInteractionEnabled = true

                self.navigationController?.popViewController(animated: true)

            case .failure(let error):
                self.view.isUserInteractionEnabled = true
                print("Upload failed with error: \(error)")
            }
        }
    }

    @objc private func uploadButtonTapped() {
        let alertVC = ApplicationAlertVC()
        alertVC.modalPresentationStyle = .overCurrentContext // 현재 뷰 컨트롤러 위에 표시
        alertVC.modalTransitionStyle = .crossDissolve // 부드러운 전환 효과
        alertVC.onSuccess = { [weak self] in
            // 확인 버튼을 탭했을 때 실행할 코드
            self?.uploadContents()
        }

        self.present(alertVC, animated: true, completion: nil)
    }
}

extension ReviewWriteVC: FloatingPanelControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        validateSubmissionCriteria()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            selectedImages.append(selectedImage)
            self.setScrollView()
            validateSubmissionCriteria()
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func floatingPanelWillBeginAttracting(_ fpc: FloatingPanelController, to state: FloatingPanelState) {
        if state == FloatingPanelState.tip {
            fpc.removePanelFromParent(animated: true)
        }
    }

    // UITextFieldDelegate 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드를 숨깁니다.
        return true
    }

}
