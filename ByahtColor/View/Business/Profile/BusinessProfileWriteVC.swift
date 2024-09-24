//
//  BusinessProfileWriteVC.swift
//  ByahtColor
//
//  Created by jaem on 6/29/24.
//

import SnapKit
import UIKit
import Alamofire
import FloatingPanel
import AVFoundation

class BusinessProfileWriteVC: UIViewController {
    private let topView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let uploadButton = UIButton()
    private let thumbnailView = UIView()
    private let infoView = UIView()
    private let payView = UIView()
    private let targetView = UIView()
    private let buttonPicture = UIButton()
    private let horizonScrollView = UIScrollView()
    private var selectedImages: [UIImage] = []
    private let et_intro = UITextView()
    private var etIntroHeightConstraint: Constraint?
    private let targetLabel: UILabel = {
        let label = UILabel()
        label.text = "business_profile_write_target".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.appendRedStar()
        return label
    }()
    private let targetLabel2: UILabel = {
        let label = UILabel()
        label.text = "business_profile_write_target2".localized
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = UIColor(hex: "#4E505B")
        return label
    }()
    private var payStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = UIColor(hex: "#F4F5F8")
        stackView.layer.cornerRadius = 8
        return stackView
    }()
    private let subtitle1: UILabel = {
        let label = UILabel()
        label.text = "business_profile_subtitle1".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = .black
        return label
    }()

    private let subtitle2: UILabel = {
        let label = UILabel()
        label.text = "business_profile_subtitle2".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = .black
        return label
    }()

    private let subtitle3: UILabel = {
        let label = UILabel()
        label.text = "business_profile_subtitle3".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = .black
        return label
    }()
    private let subtitle4: UILabel = {
        let label = UILabel()
        label.text = "business_profile_subtitle4".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = .black
        return label
    }()
    private let reportView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F4F5F8")
        view.layer.cornerRadius = 8
        return view
    }()
    private var targetStackView = UIStackView()
    private var payArray: [Pay] = []
    private var categoryButtons: [UIButton] = []
    private var ageButtons: [UIButton] = []
    private var genderButtons: [UIButton] = []
    private var nationButtons: [UIButton] = []
    private var selectedAge: [String] = []
    private var selectedCategory: [String] = []
    private var selectedGender: [String] = []
    private var selectedNation: [String] = []
    private let viewModel = BusinessViewModel()
    private var genderView = UIView()
    private var categoryView = UIView()
    private var ageView = UIView()
    private var nationView = UIView()
    private var update = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupProfile()
        setupGesture()

    }

    private func setupProfile() {
        if let id = User.shared.id {
            viewModel.getBusinessProfile(id: id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self?.update = true
                        self?.payArray = data.payDtos ?? []
                        self?.et_intro.text = "\(data.intro ?? "")"
                        self?.selectedGender = data.gender?.components(separatedBy: ",") ?? []
                        self?.selectedAge = data.age?.components(separatedBy: ",") ?? []
                        self?.selectedCategory = data.category?.components(separatedBy: ",") ?? []
                        self?.selectedNation = data.nation?.components(separatedBy: ",") ?? []

                        if let path = data.imagePath {
                            self?.loadImageFromURL(path) { [weak self] image in
                                DispatchQueue.main.async {
                                    if let image = image {
                                        self?.selectedImages.append(image)
                                        self?.resetHorizonScrollView()
                                    }
                                }
                            }
                        }
                        
                        self?.setupUI()
                        self?.setupConstraints()

                    case .failure(let error):
                        print("통신 에러 : \(error)")
                        self?.setupUI()
                        self?.setupConstraints()
                    }
                }
            }
        }
    }

    private func setupUI() {
        setTopView()
        setupScrollView()
        setupThumbnailView()
        setupHorizonScrollView()
        setupInfoView()
        setupPayView()
        setupReportView()
    }

    private func setupReportView() {
        contentView.addSubview(reportView)
        makeTargetStackView()
        contentView.addSubview(targetLabel)
        contentView.addSubview(targetLabel2)
        reportView.addSubview(targetView)
    }

    private func setupThumbnailView() {
        contentView.addSubview(thumbnailView)
        let thumblabel1 = UILabel()
        let thumblabel2 = UILabel()
        thumblabel1.text = "business_profile_write_thumbnail".localized
        thumblabel1.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        thumblabel2.text = "business_profile_write_thumbnail2".localized
        thumblabel2.font = UIFont(name: "Pretendard-Regular", size: 14)
        thumblabel2.numberOfLines = 0

        thumbnailView.addSubview(thumblabel1)
        thumbnailView.addSubview(thumblabel2)
        thumblabel1.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        thumblabel2.snp.makeConstraints {
            $0.top.equalTo(thumblabel1.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

    }

    private func setupHorizonScrollView() {
        horizonScrollView.delegate = self
        horizonScrollView.showsHorizontalScrollIndicator = true
        horizonScrollView.isPagingEnabled = false
        contentView.addSubview(horizonScrollView)

        buttonPicture.backgroundColor = UIColor(hex: "#F7F7F7")
        buttonPicture.setImage(UIImage(named: "icon_plus"), for: .normal)
        buttonPicture.layer.cornerRadius = 8
        buttonPicture.imageView?.contentMode = .scaleAspectFill
        buttonPicture.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        // 버튼의 이미지가 가운데에 위치하도록 설정
        buttonPicture.contentHorizontalAlignment = .center
        buttonPicture.contentVerticalAlignment = .center
        horizonScrollView.addSubview(buttonPicture)

        buttonPicture.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(218)
            make.height.equalTo(218)
        }

    }

    private func resetHorizonScrollView() {
        horizonScrollView.subviews.forEach { subview in
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }

        var totalWidth: CGFloat = 20 // 초기 여백
        let buttonWidth = CGFloat(218)

        // buttonPicture를 항상 왼쪽에 고정
        buttonPicture.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(totalWidth)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonWidth)
        }

        totalWidth += buttonWidth + 20 // buttonPicture의 너비와 여백을 더함

        for (index, image) in selectedImages.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.tag = selectedImages.count - 1 - index
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 8
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            horizonScrollView.addSubview(imageView)

            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalTo(buttonWidth)
                make.height.equalTo(buttonWidth)
                make.leading.equalToSuperview().offset(totalWidth)
            }

            // 이미지 너비와 여백을 더함
            totalWidth += buttonWidth + 20

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

        // 스크롤뷰의 contentSize 업데이트
        horizonScrollView.contentSize = CGSize(width: totalWidth, height: 218)
    }

    @objc private func buttonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.sourceType = .photoLibrary // 또는 .camera
        present(imagePickerController, animated: true)
    }

    private func setupInfoView() {
        contentView.addSubview(infoView)
        infoView.isUserInteractionEnabled = true
        et_intro.delegate = self

        let label = UILabel()
        label.text = "business_profile_write_intro".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.appendRedStar()

        let label2 = UILabel()
        label2.text = "business_profile_write_intro2".localized
        label2.font = UIFont(name: "Pretendard-Regular", size: 14)

        et_intro.layer.cornerRadius = 8
        et_intro.font = UIFont(name: "Pretendard-Medium", size: 14)

        et_intro.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        et_intro.layer.borderWidth = 1

        infoView.addSubview(label)
        infoView.addSubview(label2)
        infoView.addSubview(et_intro)

        label.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }

        label2.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom)
            $0.leading.equalToSuperview()
        }

        et_intro.snp.makeConstraints {
            $0.top.equalTo(label2.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
            self.etIntroHeightConstraint = $0.height.equalTo(40).constraint
        }
    }

    private func setupPayView() {
        contentView.addSubview(payView)

        let label = UILabel()
        label.text = "business_profile_write_pay".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.appendRedStar()

        let button = UIButton()
        button.setTitle("business_profile_write_add".localized, for: .normal)
        button.setTitleColor(UIColor(hex: "#4E505B"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        button.addTarget(self, action: #selector(showFilter), for: .touchUpInside)

        reloadPayStackView()

        let stackContainerView = UIView()
        stackContainerView.layer.cornerRadius = 8
        stackContainerView.backgroundColor = UIColor(hex: "#F4F5F8")

        stackContainerView.addSubview(payStackView)
        payView.addSubview(label)
        payView.addSubview(stackContainerView)
        payView.addSubview(button)

        label.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }

        stackContainerView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }

        payStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }

        button.snp.makeConstraints {
            $0.top.equalTo(stackContainerView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(32)
        }
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.isUserInteractionEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(contentView)
    }

    private func setTopView() {
        topView.isUserInteractionEnabled = true

        titleLabel.text = "Profile"
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)

        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        uploadButton.backgroundColor = .black
        uploadButton.layer.cornerRadius = 12
        uploadButton.setTitleColor(.white, for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        view.addSubview(topView)
        topView.addSubview(titleLabel)
        topView.addSubview(uploadButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.center.equalToSuperview()
        }

        uploadButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.height.equalTo(24)
            make.width.equalTo(55)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: false)
    }

    // 페이
    private func reloadPayStackView() {
        clearStackView(type: 2)
        payArray.enumerated().forEach { (index, pay) in
            let facebookIcon = UIImageView(image: UIImage(named: "facebook"))
            let InstagramIcon = UIImageView(image: UIImage(named: "instagram"))
            let tiktokIcon = UIImageView(image: UIImage(named: "tiktok"))
            let view = UIView()
            payStackView.addArrangedSubview(view)
            view.snp.makeConstraints {
                $0.height.equalTo(42)
                $0.leading.trailing.equalToSuperview()
            }

            var icon: UIImageView
            if pay.sns == 0 {
                icon = tiktokIcon
            } else if pay.sns == 1 {
                icon = InstagramIcon
            } else {
                icon = facebookIcon
            }

            let lbl = UILabel()
            lbl.text = pay.cash
            lbl.font = UIFont(name: "Pretendard-Medium", size: 16)

            var negotiable = ""
            if pay.negotiable ?? false {
                negotiable = "business_profile_write_negotiable".localized
            } else {
                negotiable = "business_profile_write_non_negotiable".localized
            }

            var type = ""
            if pay.type == 0 {
                type = "business_profile_write_video".localized
            } else {
                type = "business_profile_write_photo".localized
            }

            let lbl2 = UILabel()
            lbl2.text = "\(negotiable) | \(type)"
            lbl2.font = UIFont(name: "Pretendard-Regular", size: 12)
            lbl2.textColor = UIColor(hex: "#4E505B")

            let removeButton = UIButton()
            removeButton.setImage(UIImage(named: "back_icon"), for: .normal)
            removeButton.tag = index  // index 값을 tag로 설정
            removeButton.addTarget(self, action: #selector(payDeleteTapped), for: .touchUpInside)

            view.addSubview(icon)
            view.addSubview(lbl)
            view.addSubview(lbl2)
            view.addSubview(removeButton)
            icon.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.width.height.equalTo(20)
            }

            lbl.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalTo(icon.snp.trailing).offset(4)
                $0.trailing.equalToSuperview()
            }

            lbl2.snp.makeConstraints {
                $0.top.equalTo(icon.snp.bottom).offset(4)
                $0.leading.trailing.equalToSuperview()
            }

            removeButton.snp.makeConstraints {
                $0.centerY.equalTo(view.snp.centerY)
                $0.width.height.equalTo(16)
                $0.trailing.equalToSuperview()
            }
        }
    }

    // target
    private func makeTargetStackView() {
        categoryView = createCategoryView(titles: Globals.shared.categories, type: 0, selected: selectedCategory)
        ageView = createCategoryView(titles: Globals.shared.ages, type: 1, selected: selectedAge)
        genderView = createCategoryView(titles: Globals.shared.genders, type: 2, selected: selectedGender)
        nationView = createCategoryView(titles: Globals.shared.nations2, type: 3, selected: selectedNation)

        targetView.addSubview(subtitle1)
        targetView.addSubview(subtitle2)
        targetView.addSubview(subtitle3)
        targetView.addSubview(subtitle4)
        targetView.addSubview(categoryView)
        targetView.addSubview(ageView)
        targetView.addSubview(genderView)
        targetView.addSubview(nationView)

        subtitle1.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(24)
        }

        categoryView.snp.makeConstraints {
            $0.top.equalTo(subtitle1.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }

        subtitle2.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
            $0.height.equalTo(24)
        }

        ageView.snp.makeConstraints {
            $0.top.equalTo(subtitle2.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }

        subtitle3.snp.makeConstraints {
            $0.top.equalTo(ageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
            $0.height.equalTo(24)
        }

        genderView.snp.makeConstraints {
            $0.top.equalTo(subtitle3.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        subtitle4.snp.makeConstraints {
            $0.top.equalTo(genderView.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
            $0.height.equalTo(24)
        }

        nationView.snp.makeConstraints {
            $0.top.equalTo(subtitle4.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    private func createCategoryView(titles: [String], type: Int, selected: [String]) -> UIView {
        let view = UIView()
        let maxWidth = UIScreen.main.bounds.width - 80
        var currentRowView = UIView()
        var currentRowWidth: CGFloat = 0
        var rowIndex = 0
        for (index, title) in titles.enumerated() {
            let button = UIButton()
            if selected.contains(index.toString()) {
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .black
                button.isSelected = true
            } else {
                button.setTitleColor(UIColor(hex: "#4E505B"), for: .normal)
                button.backgroundColor = .white
            }
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
            button.layer.cornerRadius = 16
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
            button.titleEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.5
            button.titleLabel?.lineBreakMode = .byTruncatingTail
            button.tag = index
            if type == 0 {
                button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
                categoryButtons.append(button)
            } else if type == 1 {
                button.addTarget(self, action: #selector(ageButtonTapped), for: .touchUpInside)
                ageButtons.append(button)
            } else if type == 2 {
                button.addTarget(self, action: #selector(genderButtonTapped), for: .touchUpInside)
                ageButtons.append(button)
            } else {
                button.addTarget(self, action: #selector(nationButtonTapped), for: .touchUpInside)
                nationButtons.append(button)
            }
            let buttonWidth: CGFloat = max(48, (title as NSString).size(withAttributes: [.font: UIFont(name: "Pretendard-Regular", size: 14)!]).width + 16) // 16 for padding
            if currentRowWidth + buttonWidth + 4 > maxWidth { // 4 for spacing
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
            currentRowWidth += buttonWidth + 4
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

    @objc private func uploadButtonTapped() {
        guard validateForm() else { return }
        if let id = User.shared.id {
            let category = selectedCategory.joined(separator: ",")
            let gender = selectedGender.joined(separator: ",")
            let age = selectedAge.joined(separator: ",")
            let nation = selectedNation.joined(separator: ",")
            let dto = BusinessDetailDto(memberId: id, business_name: nil, intro: et_intro.text, payDtos: payArray, age: age,
                                        category: category, gender: gender, nation: nation, imagePath: nil, proposal: nil, video: nil)
            viewModel.updateProfile(memberId: id, dto: dto, images: selectedImages, update: update) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let responseString):
                        self?.updateChatProfile()
                        UserDefaults.standard.set(1, forKey: "home")
                        UserDefaults.standard.setValue(self?.et_intro.text, forKey: "intro")
                        self?.navigationController?.popViewController(animated: true)

                    case .failure(let error):
                        print("에러가 발생했습니다")
                        print( "Error: \(error.localizedDescription)")
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

    private func clearStackView(type: Int) {
        for view in payStackView.arrangedSubviews {
            payStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    @objc private func categoryButtonTapped(_ sender: UIButton) {
        let selector = sender.tag.toString()

        if sender.isSelected {
            // 버튼이 이미 선택된 상태라면, 선택 해제
            sender.isSelected = false
            sender.backgroundColor = .white
            sender.setTitleColor(UIColor(hex: "#4E505B"), for: .normal)
            if let index = selectedCategory.firstIndex(of: selector) {
                selectedCategory.remove(at: index)
            }
        } else {
            // 선택된 버튼이 두 개 미만인 경우에만 선택
            sender.isSelected = true
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            selectedCategory.append(selector)
        }

    }

    @objc private func ageButtonTapped(_ sender: UIButton) {
        let selector = sender.tag.toString()
        if sender.isSelected {
            // 버튼이 이미 선택된 상태라면, 선택 해제
            sender.isSelected = false
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            if let index = selectedAge.firstIndex(of: selector) {
                selectedAge.remove(at: index)
            }
        } else {
            // 선택된 버튼이 두 개 미만인 경우에만 선택
            sender.isSelected = true
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            selectedAge.append(selector)
        }
    }

    @objc private func genderButtonTapped(_ sender: UIButton) {
        let selector = sender.tag.toString()
        if sender.isSelected {
            // 버튼이 이미 선택된 상태라면, 선택 해제
            sender.isSelected = false
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            if let index = selectedGender.firstIndex(of: selector) {
                selectedGender.remove(at: index)
            }
        } else {
            // 선택된 버튼이 두 개 미만인 경우에만 선택
            sender.isSelected = true
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            selectedGender.append(selector)
        }
    }

    @objc private func nationButtonTapped(_ sender: UIButton) {
        let selector = sender.tag.description
        if sender.isSelected {
            // 버튼이 이미 선택된 상태라면, 선택 해제
            sender.isSelected = false
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            if let index = selectedNation.firstIndex(of: selector) {
                selectedNation.remove(at: index)
            }
        } else {
            // 다중선택 가능
            sender.isSelected = true
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            selectedNation.append(selector)
        }
    }

    @objc private func payDeleteTapped(_ sender: UIButton) {
        payArray.remove(at: sender.tag)
        reloadPayStackView()
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

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func validateForm() -> Bool {
        // 각 필드의 유효성 검사
        if et_intro.text.isEmpty || et_intro.text.count > 80 {
            showAlert(message: "influence_profile_write_message1".localized)
            return false
        }

        if payArray.isEmpty {
            showAlert(message: "influence_profile_write_message3".localized)
            return false
        }

        if selectedCategory.isEmpty {
            showAlert(message: "influence_profile_write_message4".localized)
            return false
        }

        if selectedAge.isEmpty {
            showAlert(message: "influence_profile_write_message5".localized)
            return false
        }

        if selectedGender.isEmpty {
            showAlert(message: "influence_profile_write_message6".localized)
            return false
        }

        if selectedNation.isEmpty {
            showAlert(message: "influence_profile_write_message7".localized)
            return false
        }
        // 모든 유효성 검사를 통과하면 true를 반환
        return true
    }

    // 추가된 이미지 제거
    @objc private func removeImage(_ sender: UIButton) {
        guard let imageView = sender.superview as? UIImageView else { return }

        // 이미지뷰 제거
        imageView.removeFromSuperview()

        // 선택된 이미지 목록에서 해당 이미지 제거
        selectedImages.removeLast()

        // 스크롤뷰에 남아있는 이미지뷰들의 레이아웃을 다시 조정
        resetHorizonScrollView()
    }

    private func setupConstraints() {
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.greaterThanOrEqualTo(scrollView).priority(.low)
        }

        thumbnailView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        horizonScrollView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(218)
        }

        infoView.snp.makeConstraints {
            $0.top.equalTo(horizonScrollView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        payView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        targetLabel.snp.makeConstraints {
            $0.top.equalTo(payView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        targetLabel2.snp.makeConstraints {
            $0.top.equalTo(targetLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        // 보고서
        reportView.snp.makeConstraints {
            $0.top.equalTo(targetLabel2.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }

        targetView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
}

extension BusinessProfileWriteVC: UIImagePickerControllerDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, UITextViewDelegate,
                                  FloatingPanelControllerDelegate, AddPayVCDelegate {

    // 페이 추가
    func didTapButton(_ VC: AddPayVC, getData: Pay) {
        payArray.append(getData)
        reloadPayStackView()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        selectedImages = []
        if let selectedImage = info[.originalImage] as? UIImage {
            selectedImages.append(selectedImage)
            self.resetHorizonScrollView()
        }

        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func generateThumbnail(url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true

            let time = CMTime(seconds: 1, preferredTimescale: 60)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: img)
                DispatchQueue.main.async {
                    completion(thumbnail)
                }
            } catch {
                print("Error generating thumbnail: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

    // Text
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(hex: "#D3D4DA") {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "influence_profile_write_intro_hint".localized
            textView.textColor = UIColor(hex: "#D3D4DA")
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        etIntroHeightConstraint?.update(offset: size.height)
        view.layoutIfNeeded()
    }

    @objc private func showFilter() {
        let fpc = FloatingPanelController()
        fpc.delegate = self
        let contentVC = AddPayVC() // 패널에 표시할 컨텐츠 뷰 컨트롤러
        contentVC.delegate = self
        fpc.set(contentViewController: contentVC)
        fpc.layout = CustomFloatingPanel()
        fpc.isRemovalInteractionEnabled = true
        fpc.surfaceView.appearance.cornerRadius = 20
        fpc.addPanel(toParent: self)
        fpc.addPanel(toParent: self)
        fpc.move(to: .full, animated: true)
    }

}
