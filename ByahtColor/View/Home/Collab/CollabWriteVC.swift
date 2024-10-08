//
//  SnapWriteVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/21.
//

import SnapKit
import UIKit
import Alamofire

class CollabWriteVC: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate {
    private let topView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let middleView = UIScrollView()
    private let bottomView = UIView()
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let uploadButton = UIButton()
    private let button = UIButton()
    private let dateButton = UIButton()
    private let tv_title: UITextField = {
        let textView = UITextField()
        textView.text = "collabWriteVC_title".localized
        textView.font = UIFont(name: "Pretendard-Regular", size: 14)
        textView.textColor = .lightGray
        textView.layer.borderColor = UIColor(hex: "#BCBDC0").cgColor
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 1
        textView.textAlignment = .left

        // 입력 시작 위치 조절을 위한 leftView 설정
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textView.frame.height))
        textView.leftView = paddingView
        textView.leftViewMode = .always
        return textView
    }()
    private let tv_content: UITextView = {
        let textView = UITextView()
        textView.text = "collabWriteVC_contentLabel".localized
        textView.font = UIFont(name: "Pretendard-Regular", size: 14)
        textView.textColor = .lightGray
        textView.layer.borderColor = UIColor(hex: "#BCBDC0").cgColor
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 1
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()
    private let tv_info: UITextView = {
        let textView = UITextView()
        textView.text = "collabWriteVC_condition".localized
        textView.font = UIFont(name: "Pretendard-Regular", size: 14)
        textView.textColor = .lightGray
        textView.layer.borderColor = UIColor(hex: "#BCBDC0").cgColor
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 1
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()
    private let tv_link: UITextField = {
        let textView = UITextField()
        textView.text = "collabWriteVC_link".localized
        textView.font = UIFont(name: "Pretendard-Regular", size: 14)
        textView.textColor = .lightGray
        textView.layer.borderColor = UIColor(hex: "#BCBDC0").cgColor
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 1
        // 입력 시작 위치 조절을 위한 leftView 설정
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textView.frame.height))
        textView.leftView = paddingView
        textView.leftViewMode = .always
        return textView
    }()
    private let lbl_people: UILabel = {
        let label = UILabel()
        label.text = "collabWriteVC_people_label".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    private let tf_people: UITextField = {
        let textView = UITextField()
        textView.text = "collabWriteVC_people_field".localized
        textView.font = UIFont(name: "Pretendard-Regular", size: 14)
        textView.textColor = .lightGray
        textView.layer.borderColor = UIColor(hex: "#BCBDC0").cgColor
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 1

        // 입력 시작 위치 조절을 위한 leftView 설정
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textView.frame.height))
        textView.leftView = paddingView
        textView.leftViewMode = .always
        return textView
    }()
    private let lbl_code: UILabel = {
        let label = UILabel()
        label.text = "collabWriteVC_code_label".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    private let tf_code: UITextField = {
        let textView = UITextField()
        textView.text = "collabWriteVC_code_field".localized
        textView.font = UIFont(name: "Pretendard-Regular", size: 14)
        textView.textColor = .lightGray
        textView.layer.borderColor = UIColor(hex: "#BCBDC0").cgColor
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 1
        // 입력 시작 위치 조절을 위한 leftView 설정
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textView.frame.height))
        textView.leftView = paddingView
        textView.leftViewMode = .always
        return textView
    }()
    let lbl_date: UILabel = {
        let label = UILabel()
        label.text = "시작일 선택"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    private var selectedStyle: String = ""
    private var selectedSNS: [String] = []
    private var tagButtons = [UIButton]()
    private var snsButtons = [UIButton]()
    private var selectedImages: [UIImage] = []
    private var activityIndicator: UIActivityIndicatorView!
    private var startDate: Date?
    private var endDate: Date?

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
        scrollView.delegate = self
        tv_content.delegate = self
        tv_info.delegate = self
        tv_link.delegate = self
        tv_title.delegate = self
        tf_code.delegate = self
        tf_people.delegate = self

        // 스피너 초기화 및 설정
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)

        setMainScrollView()
        setupScrollContentView()
        setTopView()
        setMiddleView()
        setBottomView()
        setupTapGesture()
    }

    private func setMainScrollView() {
        scrollView.clipsToBounds = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }

    private func setupScrollContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
    }

    // 키보드 숨기기
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    private func setBottomView() {
        // 날짜 선택
        contentView.addSubview(lbl_date)
        contentView.addSubview(lbl_code)
        contentView.addSubview(tf_code)
        contentView.addSubview(lbl_people)
        contentView.addSubview(tf_people)
        contentView.addSubview(dateButton)

        dateButton.setTitle("날짜 선택", for: .normal)
        dateButton.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        dateButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        dateButton.layer.cornerRadius = 4
        dateButton.layer.borderWidth = 1
        dateButton.layer.borderColor = UIColor(hex: "#BCBDC0").cgColor
        dateButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)

        lbl_date.snp.makeConstraints {
            $0.top.equalTo(tv_link.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }

        dateButton.snp.makeConstraints {
            $0.top.equalTo(lbl_date.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(view).offset(-20)
        }

        lbl_code.snp.makeConstraints {
            $0.top.equalTo(dateButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }

        tf_code.snp.makeConstraints {
            $0.top.equalTo(lbl_code.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(view).offset(-20)
            $0.height.equalTo(48)
        }

        lbl_people.snp.makeConstraints {
            $0.top.equalTo(tf_code.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }

        tf_people.snp.makeConstraints {
            $0.top.equalTo(lbl_people.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(view).offset(-20)
            $0.height.equalTo(48)
        }
        // 스타일 필터 뷰 추가
        let styleFilterView = styleFilterView(tags: ["Beauty", "Fashion", "Travel", "Etc"])
        contentView.addSubview(styleFilterView)
        styleFilterView.snp.makeConstraints { make in
            make.top.equalTo(tf_people.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view).offset(-20)
        }

        // SNS 필터 뷰 추가
        let snsFilterView =
        snsFilterView(tags: ["TikTok".localized, "Instagram".localized, "Facebook".localized, "Shopee".localized, "Naver".localized, "Youtube".localized])
        contentView.addSubview(snsFilterView)
        snsFilterView.snp.makeConstraints { make in
            make.top.equalTo(styleFilterView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }

    private func styleFilterView(tags: [String]) -> UIView {
        let container = createFilterViewContainer(withTitle: "CATEGORY", tags: tags)
        return container
    }

    private func snsFilterView(tags: [String]) -> UIView {
        let container = createFilterViewContainer(withTitle: "SNS", tags: tags)
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
        let rows = tags.chunked(into: 4) // 태그 배열을 4개 단위로 분할
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
            if tags.count < 4 {
                tagButton.addTarget(self, action: #selector(styleButtonTapped), for: .touchUpInside)
                horizontalStackView.addArrangedSubview(tagButton)
                tagButtons.append(tagButton)
            } else {
                tagButton.addTarget(self, action: #selector(snsButtonTapped), for: .touchUpInside)
                horizontalStackView.addArrangedSubview(tagButton)
                snsButtons.append(tagButton)
            }

            tagButton.snp.makeConstraints {
                $0.height.equalTo(32)
            }
        }

        return horizontalStackView
    }

    private func setMiddleView() {
        middleView.delegate = self
        middleView.showsHorizontalScrollIndicator = true
        middleView.isPagingEnabled = false
        middleView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(middleView)

        // middleView의 오토레이아웃 설정
        middleView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(150) // 필요한 높이 설정
        }

        button.backgroundColor = UIColor(hex: "#F7F7F7")
        button.setImage(UIImage(named: "icon_plus"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        middleView.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(140)
            make.height.equalTo(140)
        }

        setupContentTextView()
    }

    private func setupContentTextView() {
        contentView.addSubview(tv_title)
        contentView.addSubview(tv_content)
        contentView.addSubview(tv_info)
        contentView.addSubview(tv_link)

        tv_title.snp.makeConstraints { make in
            make.top.equalTo(middleView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(48)
        }

        tv_content.snp.makeConstraints { make in
            make.top.equalTo(tv_title.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(110)
        }

        tv_info.snp.makeConstraints { make in
            make.top.equalTo(tv_content.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(110)
        }

        tv_link.snp.makeConstraints {
            $0.top.equalTo(tv_info.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(view.snp.trailing).offset(-20)
            $0.height.equalTo(48)
        }

    }

    private func setScrollView() {
        middleView.subviews.forEach { subview in
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }

        var totalWidth: CGFloat = 20 // 초기 여백

        for (index, image) in selectedImages.reversed().enumerated() {
            let imageView = UIImageView(image: image)
            imageView.tag = selectedImages.count - 1 - index
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 8
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            middleView.addSubview(imageView)

            let imageWidth = CGFloat(140)
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalTo(imageWidth)
                make.height.equalTo(imageWidth)
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
        button.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(totalWidth)
            make.width.equalTo(140)
            make.height.equalTo(140)
        }
        totalWidth += view.safeAreaLayoutGuide.layoutFrame.width * 0.4 + 20

        // 스크롤뷰의 contentSize 업데이트
        middleView.contentSize = CGSize(width: totalWidth, height: 140)
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

    private func setTopView() {
        topView.isUserInteractionEnabled = true
        contentView.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }

        backButton.setImage(UIImage(named: "back_icon"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        titleLabel.text = "Tại lên"
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)

        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        uploadButton.backgroundColor = .black
        uploadButton.layer.cornerRadius = 12
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

    // style 선택
    @objc private func styleButtonTapped(_ sender: UIButton) {
        guard let style = sender.titleLabel?.text else { return }

        // 모든 버튼을 초기 상태로 설정합니다.
        for button in tagButtons {
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            button.isSelected = false
        }

        // 현재 선택된 스타일이 다시 탭된 경우, 선택 해제하지 않고 상태를 유지합니다.
        if selectedStyle != style {
            selectedStyle = style
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            sender.isSelected = true
        } else {
            // 스타일이 이미 선택된 경우, 선택을 해제하는 코드를 제거합니다.
            selectedStyle = ""
        }

    }

    // SNS 선택
    @objc private func snsButtonTapped(_ sender: UIButton) {
        guard let sns = sender.titleLabel?.text else { return }

        // 스타일이 이미 선택된 경우, 선택을 해제합니다.
        if let index = selectedSNS.firstIndex(of: sns) {
            selectedSNS.remove(at: index)
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            sender.isSelected = false
        } else {
            // 선택되지않은 버튼 동작
            selectedSNS.append(sns)
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            sender.isSelected = true
        }

        // 선택된 스타일이 변경될 때마다 UI를 업데이트합니다.
        updateStyleSelectionUI()
    }

    private func updateStyleSelectionUI() {

        snsButtons.forEach { button in
            if let sns = button.titleLabel?.text {
                if selectedSNS.contains(sns) {
                    button.backgroundColor = .black
                    button.setTitleColor(.white, for: .normal)
                    button.isSelected = true
                } else {
                    button.backgroundColor = .white
                    button.setTitleColor(.black, for: .normal)
                    button.isSelected = false
                }
            }
        }
    }

    // 뒤로가기 버튼 액션
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func buttonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary // 또는 .camera
        present(imagePickerController, animated: true)
    }

    // 업로드 버튼 액션
    @objc private func uploadButtonTapped() {
        if let errorMessage = validateInputs() {
            // 검사를 통과하지 못한 경우, 경고 메시지 표시
            showAlert(message: errorMessage)
            return
        }

        self.activityIndicator.startAnimating()
        let url = "\(Bundle.main.TEST_URL)/snap/insert"
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        let nickname: String = User.shared.name ?? ""
        let user_id = User.shared.id ?? ""
        let style = selectedStyle
        let facebookValue = selectedSNS.contains("Facebook") ? "true" : "false"
        let tiktokValue = selectedSNS.contains("TikTok") ? "true" : "false"
        let instagramValue = selectedSNS.contains("Instagram") ? "true" : "false"
        let shopeeValue = selectedSNS.contains("Shopee") ? "true" : "false"
        let youtubeValue = selectedSNS.contains("Youtube") ? "true" : "false"
        let naverValue = selectedSNS.contains("Naver") ? "true" : "false"

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 00:00:00"

        let start_date = formatter.string(from: startDate!)
        let end_date = formatter.string(from: endDate!)
        var collab_code = ""
        if tf_code.text != "코드 입력" { collab_code = tf_code.text ?? "" }
        let people = tf_people.text ?? ""
        let title = tv_title.text ?? ""
        let link = tv_link.text ?? ""
        let notification = "false"

        // MultipartFormData를 사용하여 요청 생성
        AF.upload(multipartFormData: { multipartFormData in
            // 텍스트 데이터 추가
            multipartFormData.append(Data(user_id.utf8), withName: "user_id")
            multipartFormData.append(Data(nickname.utf8), withName: "nickname")
            multipartFormData.append(Data(title.utf8), withName: "title")
            multipartFormData.append(Data(self.tv_content.text.utf8), withName: "content")
            multipartFormData.append(Data(self.tv_info.text.utf8), withName: "info")
            multipartFormData.append(Data(people.utf8), withName: "people")
            multipartFormData.append(Data(collab_code.utf8), withName: "collab_code")
            multipartFormData.append(Data(link.utf8), withName: "link")
            multipartFormData.append(Data(style.utf8), withName: "style")
            multipartFormData.append(Data(facebookValue.utf8), withName: "facebook")
            multipartFormData.append(Data(tiktokValue.utf8), withName: "tiktok")
            multipartFormData.append(Data(instagramValue.utf8), withName: "instagram")
            multipartFormData.append(Data(shopeeValue.utf8), withName: "shopee")
            multipartFormData.append(Data(naverValue.utf8), withName: "naver")
            multipartFormData.append(Data(youtubeValue.utf8), withName: "youtube")
            multipartFormData.append(Data(start_date.utf8), withName: "start_date")
            multipartFormData.append(Data(end_date.utf8), withName: "end_date")
            multipartFormData.append(Data(notification.utf8), withName: "notification")

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

    private func validateInputs() -> String? {
        // 이미지가 없는 경우
        if selectedImages.isEmpty {
            return "선택된 이미지가 없습니다."
        }

        // contentView의 텍스트가 비어있는 경우
        if tv_content.text.isEmpty || tv_content.text == "collabWriteVC_contentLabel".localized {
            return "Vui lòng nhập thông tin chi tiết của bạn."
        }

        if startDate == nil {
            return "시작 날짜를 선택해주세요."
        }

        if endDate == nil {
            return "마감 날짜를 선택해주세요."
        }

        // 추가적으로, 시작 날짜가 마감 날짜보다 이후인지도 검사할 수 있습니다.
        if let start = startDate, let end = endDate, start > end {
            return "시작 날짜가 마감 날짜보다 이후일 수 없습니다."
        }

        // 선택된 스타일이 없는 경우
        if selectedStyle.isEmpty {
            return "Vui lòng chọn ít nhất một kiểu."
        }

        // 모든 검사를 통과한 경우
        return nil
    }

    // 경고 메시지
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    @objc func showDatePicker() {
        let datePickerVC = DatePickerVC()

        datePickerVC.onStartDateSelected = { [weak self] startDate in
            // 시작 날짜
            self?.startDate = startDate

        }
        datePickerVC.onEndDateSelected = { [weak self] endDate in
            // 종료 날짜
            self?.endDate = endDate
            if let startDate = self?.startDate, let endDate = self?.endDate {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"

                let startDateString = formatter.string(from: startDate)
                let endDateString = formatter.string(from: endDate)

                self?.dateButton.setTitle("\(startDateString) ~ \(endDateString)", for: .normal)
            }
        }

        let navController = UINavigationController(rootViewController: datePickerVC)
        present(navController, animated: true)
    }

}

extension CollabWriteVC: UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            selectedImages.append(selectedImage)

            self.setScrollView()
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == tv_content && textView.text == "collabWriteVC_contentLabel".localized {
            textView.text = ""
            textView.textColor = .black
        }
        if textView == tv_info && textView.text == "collabWriteVC_condition".localized {
            textView.text = ""
            textView.textColor = .black
        }
        if textView == tf_code && textView.text == "collabWriteVC_code_field".localized {
            textView.text = ""
            textView.textColor = .black
        }
        if textView == tf_people && textView.text == "collabWriteVC_people_field".localized {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == tv_content && textView.text.isEmpty {
            textView.text = "collabWriteVC_contentLabel".localized
            textView.textColor = .lightGray
        }
        if textView == tv_info && textView.text.isEmpty {
            textView.text = "collabWriteVC_condition".localized
            textView.textColor = .lightGray
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        // 입력 가능한 최대 글자 수를 초과하지 않는지 확인
        return updatedText.count <= 3000
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tf_people {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // 입력 가능한 최대 글자 수를 초과하지 않는지 확인
        return updatedText.count <= 50
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 키보드 숨김
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tv_link && textField.text == "collabWriteVC_link".localized {
            textField.text = ""
            textField.textColor = .black
        }
        if textField == tv_title && textField.text == "collabWriteVC_title".localized {
            textField.text = ""
            textField.textColor = .black
        }
        if textField == tf_people && textField.text == "collabWriteVC_people_field".localized {
            textField.text = ""
            textField.textColor = .black
        }
        if textField == tf_code && textField.text == "collabWriteVC_code_field".localized {
            textField.text = ""
            textField.textColor = .black
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tv_link && textField.text!.isEmpty {
            textField.text = "collabWriteVC_link".localized
            textField.textColor = .lightGray
        }

        if textField == tv_title && textField.text!.isEmpty {
            textField.text = "collabWriteVC_title".localized
            textField.textColor = .lightGray
        }

        if textField == tf_people && textField.text!.isEmpty {
            textField.text = "collabWriteVC_people_field".localized
            textField.textColor = .lightGray
        }

        if textField == tf_code && textField.text!.isEmpty {
            textField.text = "collabWriteVC_code_field".localized
            textField.textColor = .lightGray
        }
    }
}
