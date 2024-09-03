//
//  CollabModifyVC.swift
//  ByahtColor
//
//  Created by jaem on 5/2/24.
//

import SnapKit
import UIKit
import Alamofire

class CollabModifyVC: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate {
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
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textView.frame.height))
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

    let lbl_date: UILabel = {
        let label = UILabel()
        label.text = "시작일 선택"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    private var selectedStyle: String = ""
    private var selectedNation: String = ""
    private var selectedSNS: [String] = []
    private var styleButtons = [UIButton]()
    private var snsButtons = [UIButton]()
    private var nationButtons = [UIButton]()
    private var selectedImages: [UIImage] = []
    private var activityIndicator: UIActivityIndicatorView!
    private var startDate: Date?
    private var endDate: Date?
    private let viewModel = CollabViewModel()
    var collab: CollabDto?

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

        // 스피너 초기화 및 설정
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        loadImagesFromCollab()
        setMainScrollView()
        setupScrollContentView()
        setTopView()
        setMiddleView()
        setBottomView()
        setData()
        setupTapGesture()
    }

    private func setData() {
        tv_title.text = collab?.title
        tv_info.text = collab?.info
        tv_link.text = collab?.link
        tv_content.text = collab?.content

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let startDateString = collab?.start_date?.stringToDate()
        let endDateString = collab?.end_date?.stringToDate()

        dateButton.setTitle("\(startDateString!) ~ \(endDateString!)", for: .normal)
        startDate = formatter.date(from: startDateString!)
        endDate = formatter.date(from: endDateString!)

        updateStyleButtonState()
        updateSnsButtonState()
        updateNationButtonState()
    }

    private func loadImagesFromCollab() {
        guard let imageUrls = collab?.imageList else { return }

        let group = DispatchGroup()
        imageUrls.forEach { urlString in
            group.enter()
            let url = "\(Bundle.main.TEST_URL)/image\( urlString )"
            print(url)
            loadImageFromURL(url) { [weak self] image in
                DispatchQueue.main.async {
                    if let image = image {
                        self?.selectedImages.append(image)
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.setScrollView()  // 이미지 로딩 완료 후 스크롤 뷰 설정
        }
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

        // 스타일 필터 뷰 추가
        let styleLabel = UILabel()
        styleLabel.text = "카테고리"
        styleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        let styleFilterView = createButtonView(titles: ["Beauty", "Fashion", "Travel", "Etc"],type: 0)
        contentView.addSubview(styleLabel)
        contentView.addSubview(styleFilterView)
        styleLabel.snp.makeConstraints{
            $0.top.equalTo(dateButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(view).offset(-20)
        }
        
        styleFilterView.snp.makeConstraints { make in
            make.top.equalTo(styleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view).offset(-20)
        }

        // SNS 필터 뷰 추가
        let snsLabel = UILabel()
        snsLabel.text = "SNS"
        snsLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        let snsFilterView =
        createButtonView(titles:["TikTok".localized, "Instagram".localized, "Facebook".localized, "Shopee".localized, "Naver".localized, "Youtube".localized],type: 1)
        contentView.addSubview(snsLabel)
        contentView.addSubview(snsFilterView)
        snsLabel.snp.makeConstraints{
            $0.top.equalTo(styleFilterView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(view).offset(-20)
        }
        
        snsFilterView.snp.makeConstraints { make in
            make.top.equalTo(snsLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
        
        // 국가 선택 추가
        let nationLabel = UILabel()
        nationLabel.text = "노출 국가"
        nationLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        let nationFilterView =
        createButtonView(titles: ["nation_ko".localized, "nation_jp".localized, "nation_th".localized, "nation_ph".localized, "nation_vi".localized, "nation_sg".localized],type: 2)
        contentView.addSubview(nationLabel)
        contentView.addSubview(nationFilterView)
        
        nationLabel.snp.makeConstraints{
            $0.top.equalTo(snsFilterView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(view).offset(-20)
        }
        
        nationFilterView.snp.makeConstraints { make in
            make.top.equalTo(nationLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }

    private func createButtonView(titles: [String],type: Int) -> UIView {
        let view = UIView()
        let maxWidth = UIScreen.main.bounds.width - 40
        var currentRowView = UIView()
        var currentRowWidth: CGFloat = 0
        var rowIndex = 0
        let buttonSpacing : CGFloat = 8
        for (index, title) in titles.enumerated() {
            let button = UIButton()
            button.setTitleColor(UIColor(hex: "#4E505B"), for: .normal)
            button.backgroundColor = .white
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
            button.layer.cornerRadius = 16
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
            button.titleEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.5
            button.titleLabel?.lineBreakMode = .byTruncatingTail
            if type == 0 {
                button.addTarget(self, action: #selector(styleButtonTapped), for: .touchUpInside)
                styleButtons.append(button)
            } else if type == 1 {
                button.addTarget(self, action: #selector(snsButtonTapped), for: .touchUpInside)
                snsButtons.append(button)
            } else {
                // index 값을 tag로 설정
                button.tag = index
                button.addTarget(self, action: #selector(nationButtonTapped), for: .touchUpInside)
                nationButtons.append(button)
            }
          
            let buttonWidth: CGFloat = max(48, (title as NSString).size(withAttributes: [.font: UIFont(name: "Pretendard-Regular", size: 14)!]).width + 16) // 16 for padding
            if currentRowWidth + buttonWidth + buttonSpacing > maxWidth { // 4 for spacing
                view.addSubview(currentRowView)
                currentRowView.snp.makeConstraints { make in
                    make.top.equalTo(view).offset(rowIndex * 36) // Adjust the top offset for each row
                    make.left.equalTo(view)
                    make.right.equalTo(view)
                    make.height.equalTo(36)

                }
                currentRowView = UIView()
                currentRowWidth = 0
                rowIndex += 1
            }
            currentRowView.addSubview(button)
            button.snp.makeConstraints { make in
                make.left.equalTo(currentRowView).offset(currentRowWidth)
                make.centerY.equalTo(currentRowView)
                make.width.equalTo(buttonWidth)
                make.height.equalTo(32)
            }
            currentRowWidth += buttonWidth + buttonSpacing
        }

        if !currentRowView.subviews.isEmpty {
            view.addSubview(currentRowView)
            currentRowView.snp.makeConstraints { make in
                make.top.equalTo(view).offset(rowIndex * 36) // Adjust the top offset for each row
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.height.equalTo(36)
                make.bottom.equalToSuperview()
            }
        }

        return view
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
    private func updateStyleButtonState() {

        for button in styleButtons {
            let title = button.titleLabel?.text ?? ""
            if let style = collab?.style, title == style {
                button.isSelected = true
                button.backgroundColor = .black
                button.setTitleColor(.white, for: .normal)
                selectedStyle = button.titleLabel?.text ?? ""
            } else {
                button.isSelected = false
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    private func updateNationButtonState() {

        for button in nationButtons {
            let index = button.tag.toString()
            if let nation = collab?.nation, index == nation {
                button.isSelected = true
                button.backgroundColor = .black
                button.setTitleColor(.white, for: .normal)
                selectedNation = button.tag.toString()
            } else {
                button.isSelected = false
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
            }
        }
    }
    

    @objc private func styleButtonTapped(_ sender: UIButton) {
        // 스타일 선택 토글 로직
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = sender.isSelected ? .black : .white
        sender.setTitleColor(sender.isSelected ? .white : .black, for: .normal)

        // 선택된 스타일을 관리하기 위한 로직
        if let styleText = sender.titleLabel?.text {
            if sender.isSelected {
                selectedStyle = styleText
            } else if selectedStyle == styleText {
                selectedStyle = ""
            }
        }
        updateStyleSelectionUI()
    }

    @objc private func nationButtonTapped(_ sender: UIButton) {
        // 스타일 선택 토글 로직
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = sender.isSelected ? .black : .white
        sender.setTitleColor(sender.isSelected ? .white : .black, for: .normal)

        // 선택된 스타일을 관리하기 위한 로직
        
        let index = sender.tag
        if sender.isSelected {
            selectedNation = index.toString()
        } else if selectedNation == index.toString() {
            selectedNation = ""
        }
        updateNationSelectionUI()
    }
    
    private func updateSnsButtonState() {
        // snsButtons 배열은 미리 생성된 각 SNS 버튼을 포함하고 있어야 합니다.
        for button in snsButtons {
            switch button.titleLabel?.text {
            case "TikTok".localized:
                button.isSelected = collab?.tiktok ?? false

            case "Instagram".localized:
                button.isSelected = collab?.instagram ?? false

            case "Facebook".localized:
                button.isSelected = collab?.facebook ?? false

            case "Shopee".localized:
                button.isSelected = collab?.shopee ?? false

            case "Youtube".localized:
                button.isSelected = collab?.shopee ?? false

            case "Naver".localized:
                button.isSelected = collab?.shopee ?? false

            default:
                break
            }
            if button.isSelected {
                if let title = button.titleLabel?.text {
                    selectedSNS.append(title.localized)
                    print("실행")
                }

            }
            button.backgroundColor = button.isSelected ? .black : .white
            button.setTitleColor(button.isSelected ? .white : .black, for: .normal)
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
        updateSnsSelectionUI()
    }
    
    private func updateStyleSelectionUI() {
        styleButtons.forEach { button in
            if let style = button.titleLabel?.text {
                if selectedStyle.contains(style) {
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

    private func updateNationSelectionUI() {
        nationButtons.forEach { button in
            let index = button.tag
            if selectedNation == index.toString() {
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
    
    private func updateSnsSelectionUI() {
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
        let no = collab?.no?.toString()
        let style = selectedStyle
        let facebookValue = selectedSNS.contains("Facebook".localized) ? "true" : "false"
        let tiktokValue = selectedSNS.contains("TikTok".localized) ? "true" : "false"
        let instagramValue = selectedSNS.contains("Instagram".localized) ? "true" : "false"
        let shopeeValue = selectedSNS.contains("Shopee".localized) ? "true" : "false"
        let youtubeValue = selectedSNS.contains("Youtube".localized) ? "true" : "false"
        let naverValue = selectedSNS.contains("Naver".localized) ? "true" : "false"

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let startDateString = formatter.string(from: startDate! )
        let endDateString = formatter.string(from: endDate! )  // endDate에 대해서도 비슷하게 처리할 수 있음
        let title = tv_title.text ?? ""
        let link = tv_link.text ?? ""
        let nation = selectedNation
        
        let dto = SnapInsertDto(no: no, userId: nil, nickname: nil, content: self.tv_content.text, link: link, title: title, nation: nation, info: tv_info.text, startDate: startDateString, endDate: endDateString, style: style, facebook: facebookValue, tiktok: tiktokValue, instagram: instagramValue, shopee: shopeeValue, naver: naverValue, youtube: youtubeValue, people: nil, collabCode: nil)
        
        viewModel.updateCollab(dto : dto, images: selectedImages){ response in
            switch response {
            case .success(let stringValue):
                self.activityIndicator.stopAnimating()
                print(stringValue)
                if let navigationController = self.navigationController {
                    var navigationArray = navigationController.viewControllers // 모든 뷰 컨트롤러를 배열로 가져옵니다.

                    // 최소한 두 개 이상의 뷰 컨트롤러가 스택에 있어야 하며,
                    // 현재 뷰 컨트롤러와 그 이전 뷰 컨트롤러를 제거합니다.
                    if navigationArray.count > 2 {
                        navigationArray.removeLast(2) // 마지막 두 개의 뷰 컨트롤러를 제거합니다.
                    }
                    // 수정된 뷰 컨트롤러 배열로 네비게이션 스택을 업데이트합니다.
                    navigationController.setViewControllers(navigationArray, animated: true)
                }

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

extension CollabModifyVC: UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
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

        // 엔터(줄 바꿈)를 눌렀을 때 키보드를 숨기는 코드 (옵션)
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }

        // 입력 가능한 최대 글자 수를 초과하지 않는지 확인
        return updatedText.count <= 1000
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

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

    }
}
