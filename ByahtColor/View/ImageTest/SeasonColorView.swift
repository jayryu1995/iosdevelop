//
//  SeasonColorView.swift
//  ByahtColor
//
//  Created by jaem on 2023/12/29.
//

import UIKit
import SnapKit
import Photos

class SeasonColorView: UIViewController, UIScrollViewDelegate {
    private let backgroundImage = UIImageView()
    private let imageView = UIImageView()
    private let scrollView = UIScrollView()
    private let bottomView = UIView()
    private let resetButton = UIButton()
    private var seletedArray: [UIColor] = []
    private var GETCOLOR: [UIColor] = []
    private var GETCOLOR2: [UIColor] = []
    private var GETCOLOR3: [UIColor] = []
    private var labelArray: [String] = []
    // 가로로 아이템들을 정렬할 UIStackView 생성
    private var stackView = UIStackView()

    var season = ""
    var colorCount = 0
    var receiveImage: UIImage?

    // VIEW WILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        view.backgroundColor = UIColor(hex: "#F4F5F8")

        // 뒤로 버튼
        setupBackButton()
        self.navigationItem.title = "Personal Color"
    }

    // VIEW DIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setupColor()
        setupViews()
        setupConstraints()

    }

    private func setupViews() {
        setupImageView()
        setupResetButton()
        setupBottomView()
    }

    private func setupResetButton() {
        let image = UIImage(named: "reset")
        resetButton.setImage(image, for: .normal)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        imageView.addSubview(resetButton)
    }

    private func setupColor() {
        switch season {
        case "spring":
            GETCOLOR = ColorPalettes.SPRINGLIGHT
            GETCOLOR2 = ColorPalettes.SPRINGBRIGHT
            labelArray = ["Spring Light", "Spring Bright"]
            colorCount = 2
        case "summer":
            GETCOLOR = ColorPalettes.SUMMERLIGHT
            GETCOLOR2 = ColorPalettes.SUMMERBRIGHT
            GETCOLOR3 = ColorPalettes.SUMMERMUTE
            labelArray = ["Summer Light", "Summer Bright", "Summer Mute"]
            colorCount = 3
        case "autumn":
            GETCOLOR = ColorPalettes.AUTUMNSTRONG
            GETCOLOR2 = ColorPalettes.AUTUMNDEEP
            GETCOLOR3 = ColorPalettes.AUTUMNMUTE
            labelArray = ["Autumn Strong", "Autumn Deep", "Autumn Mute"]
            colorCount = 3
        case "winter":
            GETCOLOR = ColorPalettes.WINTERBRIGHT
            GETCOLOR2 = ColorPalettes.WINTERDEEP
            labelArray = ["Winter Bright", "Winter Deep"]
            colorCount = 2
        default: print("SpringColorView viewTapped Error!")

        }
    }
    private func setupBottomView() {
        bottomView.backgroundColor = UIColor(hex: "#F4F5F8")
        view.addSubview(bottomView)

        // 스크롤 뷰의 델리게이트를 설정
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = false

        var previousView: UIView?
        let width = view.frame.size.width * 0.7

        for i in 0..<colorCount {
            let itemView = UIView()

            itemView.backgroundColor = .white
            itemView.layer.cornerRadius = 16
            scrollView.addSubview(itemView)

            createItemView(itemView: itemView, itemIndex: i)

            itemView.snp.makeConstraints { make in
                make.width.equalTo(width)
                make.height.equalTo(scrollView.snp.height)
                if i == 0 {
                    make.centerX.equalTo(scrollView)
                } else {
                    make.leading.equalTo(previousView?.snp.trailing ?? scrollView.snp.leading)
                }
                make.centerY.equalTo(scrollView.snp.centerY)
            }

            previousView = itemView
        }

        bottomView.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.top).offset(10)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(width)
            make.bottom.equalTo(bottomView).inset(10)
        }
        scrollView.contentSize = CGSize(width: (view.frame.width * 0.7) * CGFloat(colorCount) + (view.frame.width * 0.3), height: scrollView.frame.height)
    }
//    private func setupBottomView() {
//        bottomView.backgroundColor = UIColor(hex: "#F4F5F8")
//        view.addSubview(bottomView)
//
//        // 스크롤 뷰의 델리게이트를 설정
//        scrollView.delegate = self
//        scrollView.showsHorizontalScrollIndicator = false
//
//        stackView = createHorizontalStackView()
//
//        // 스택 뷰를 스크롤 뷰에 추가
//        scrollView.addSubview(stackView)
//
//        var itemIndex = 0
//        // 스택 뷰에 아이템 뷰들을 추가
//        for _ in 0..<colorCount { // 계절별 컬러 종류갯수 카운트
//            let itemView = UIView()
//            itemView.backgroundColor = .white // 색상은 예시입니다.
//            itemView.layer.cornerRadius = 16 // 모서리 둥글기
//            stackView.addArrangedSubview(itemView)
//
//            createItemView(itemView: itemView, itemIndex: itemIndex)
//
//            itemIndex += 1
//            let width = view.frame.size.width * 0.7
//            itemView.snp.makeConstraints { make in
//                make.width.equalTo(width) // 너비는 고정값으로 설정
//                make.height.equalTo(scrollView.snp.height) // 높이는 스크롤 뷰와 동일하게 설정
//            }
//        }
//        // 뷰에 스크롤 뷰 추가
//        bottomView.addSubview(scrollView)
//
//        // 스택 뷰의 제약 조건 설정
//           stackView.snp.makeConstraints { make in
//               make.top.bottom.equalTo(scrollView)
//               make.leading.trailing.equalTo(scrollView.contentLayoutGuide)
//           }
//
//           // 스크롤 뷰의 제약 조건 설정
//           scrollView.snp.makeConstraints { make in
//               make.top.equalTo(bottomView.snp.top).offset(10)
//               make.leading.trailing.equalToSuperview().inset(20)
//               make.bottom.equalTo(bottomView).inset(10)
//           }
//        // 첫 번째 아이템 뷰가 가운데에 위치하도록 초기 오프셋 설정
//            DispatchQueue.main.async {
//                let firstItemWidth = self.view.frame.size.width * 0.7
//                let firstItemOffset = (self.scrollView.frame.size.width - firstItemWidth) / 2
//                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: firstItemOffset, bottom: 0, right: firstItemOffset)
//            }
//    }

    // 초기화 시 첫번째 이미지뷰 세팅 //
    func firstImageCenterSetting(_ scrollView: UIScrollView) {
        if let imageView = scrollView.subviews[0] as? UIView {
            imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    // 스크롤뷰
    func centerNearestView(in scrollView: UIScrollView) {
        let center = scrollView.bounds.size.width / 2
        var closestDistance = CGFloat.greatestFiniteMagnitude
        var closestView: UIView?

        for imageView in scrollView.subviews {
            let distanceFromCenter = abs((scrollView.contentOffset.x + center) - imageView.center.x)

            if distanceFromCenter < closestDistance {
                closestDistance = distanceFromCenter
                closestView = imageView
            }
        }

        if let closestView = closestView {
            // 중앙에 위치할 뷰를 찾았다면 스크롤 뷰를 그 위치로 스크롤합니다.
            let targetContentOffset = CGPoint(x: closestView.frame.origin.x - (scrollView.bounds.size.width / 2 - closestView.frame.size.width / 2), y: 0)
            scrollView.setContentOffset(targetContentOffset, animated: true)
        }
    }

    func adjustImageScale(scrollView: UIScrollView) {
        let center = scrollView.bounds.size.width / 2
        for imageView in scrollView.subviews {
            let distanceFromCenter = abs(scrollView.contentOffset.x + center - imageView.center.x)
            let scale = max(0.8, 1 - distanceFromCenter / scrollView.bounds.size.width)
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }

    var newClosestIndex: Int? = 0

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustImageScale(scrollView: scrollView)
        let centerOffsetX = scrollView.contentOffset.x + scrollView.bounds.size.width / 2
        var closestDistance = CGFloat.greatestFiniteMagnitude
        var previousCenterIndex: Int?

        for (index, subview) in scrollView.subviews.enumerated() {
                // arrangedSubview의 중앙 x 좌표를 계산
                let viewCenterX = subview.frame.origin.x + (subview.frame.size.width / 2)

                // 중앙점과 arrangedSubview 중앙의 거리를 계산
                let distance = abs(centerOffsetX - viewCenterX)

                // 가장 가까운 거리를 갱신
                if distance < closestDistance {
                    closestDistance = distance
                    newClosestIndex = index
                }
        }
        // 다음 뷰가 중앙에 오기 직전에 resetButtonTapped() 호출
        if let newClosestIndex = newClosestIndex, newClosestIndex != previousCenterIndex {
            if scrollView.isDragging {
                resetButtonTapped()
            }
            previousCenterIndex = newClosestIndex
        }
    }

    private func itemViewButtonReset() {
        seletedArray = []
        // stackView의 모든 itemView를 순회합니다.
        for itemView in scrollView.subviews {
            // itemView의 하위 뷰들 중에서 verticalView를 찾습니다.
            for subview in itemView.subviews {
                if let verticalView = subview as? UIStackView {
                    // verticalView의 하위 뷰들 중에서 horizonView를 찾습니다.
                    for horizonSubview in verticalView.arrangedSubviews {
                        if let horizonView = horizonSubview as? UIStackView {
                            // horizonView 내의 모든 버튼들의 isSelected 상태를 false로 변경합니다.
                            for button in horizonView.arrangedSubviews.compactMap({ $0 as? UIButton }) {
                                button.isSelected = false
                                button.layer.borderColor = nil
                                button.layer.borderWidth = 0

                            }
                        }
                    }
                }
            }
        }

    }

    private func createHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }

    // 스크롤 뷰 내의 팔레트 뷰
    private func createItemView(itemView: UIView, itemIndex: Int) {
        let label = UILabel()
        label.text = labelArray[itemIndex]
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.textAlignment = .center
        itemView.addSubview(label)

        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }

        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 5

        var colorIndex = 0 // 색상 배열 인덱스

        for _ in 0..<4 { // 4개의 horizonStackView를 생성
            let horizonStackView = UIStackView()
            horizonStackView.axis = .horizontal
            horizonStackView.distribution = .fillEqually
            horizonStackView.alignment = .fill
            horizonStackView.spacing = 5

            for _ in 0..<4 { // 각 horizonStackView에 4개의 버튼 추가
                let button = UIButton()
                switch itemIndex {
                case 0: button.backgroundColor = GETCOLOR[colorIndex]
                case 1: button.backgroundColor = GETCOLOR2[colorIndex]
                case 2: button.backgroundColor = GETCOLOR3[colorIndex]
                default: button.backgroundColor = GETCOLOR[colorIndex]
                }
                button.layer.cornerRadius = 6
                button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                horizonStackView.addArrangedSubview(button)
                button.tag = colorIndex
                colorIndex += 1 // 다음 색상으로 인덱스를 증가
            }

            verticalStackView.addArrangedSubview(horizonStackView)

            horizonStackView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().inset(10)
            }

        }

        itemView.addSubview(verticalStackView)

        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
        }

        // 구분선
        let borderView = createBorderView()
        itemView.addSubview(borderView)

        borderView.snp.makeConstraints { make in
            make.width.equalTo(verticalStackView)
            make.top.equalTo(verticalStackView.snp.bottom).offset(10) // verticalStackView의 하단에 위치하도록 설정합니다.
            make.height.equalTo(1) // 높이는 1로 설정하여 선처럼 보이게 합니다.
        }

        let saveButton = UIButton()
        saveButton.setTitle("Lưu", for: .normal)
        saveButton.setTitleColor(UIColor(hex: "#935DFF"), for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        saveButton.addTarget(self, action: #selector(btnSave), for: .touchUpInside)

        let shareButton = UIButton()
        shareButton.setTitle("Chia sẻ", for: .normal)
        shareButton.setTitleColor(UIColor(hex: "#935DFF"), for: .normal)
        shareButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        shareButton.addTarget(self, action: #selector(btnPresent), for: .touchUpInside)

        itemView.addSubview(saveButton)
        itemView.addSubview(shareButton)

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(borderView.snp.bottom)
            make.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }

        shareButton.snp.makeConstraints { make in
            make.top.equalTo(borderView.snp.bottom)
            make.width.equalToSuperview().dividedBy(2)
            make.trailing.bottom.equalToSuperview()
        }
    }

    @objc private func resetButtonTapped() {

        itemViewButtonReset()

        var colorArray: [UIColor] = []
        switch newClosestIndex {
        case 0: colorArray = GETCOLOR
        case 1: colorArray = GETCOLOR2
        case 2: colorArray = GETCOLOR3
        default: colorArray = GETCOLOR
        }

        backgroundImage.image = CreateBackgroundImage().drawSixteenBackground(size: imageView.frame.size, array: colorArray)
    }

    @objc private func buttonTapped(sender: UIButton) {
        // 버튼의 isSelected 상태를 토글합니다.
        sender.isSelected = !sender.isSelected

        // isSelected 상태에 따라 테두리를 설정하거나 제거합니다.
        if sender.isSelected {
            if seletedArray.count < 4 {
                switch newClosestIndex {
                case 0: seletedArray.append(GETCOLOR[sender.tag])
                case 1: seletedArray.append(GETCOLOR2[sender.tag])
                case 2: seletedArray.append(GETCOLOR3[sender.tag])
                default: seletedArray.append(GETCOLOR[sender.tag])
                }

                // 선택된 상태일 때 테두리 색상 설정
                sender.layer.borderColor = UIColor(hex: "#935DFF").cgColor
                sender.layer.borderWidth = 2

            } else {
                DispatchQueue.main.async {
                    CustomFunction().showToast(message: "더이상 선택할 수 없습니다.", font: UIFont.systemFont(ofSize: 14), view: self.view)
                }

            }

        } else {
            // 선택 해제 했을 떄
            sender.layer.borderColor = nil
            sender.layer.borderWidth = 0

            switch newClosestIndex {
            case 0: if let index = seletedArray.firstIndex(of: GETCOLOR[sender.tag]) {
                seletedArray.remove(at: index)
            }
            case 1: if let index = seletedArray.firstIndex(of: GETCOLOR2[sender.tag]) {
                seletedArray.remove(at: index)
            }
            case 2: if let index = seletedArray.firstIndex(of: GETCOLOR3[sender.tag]) {
                seletedArray.remove(at: index)
            }
            default: seletedArray.append(GETCOLOR[sender.tag])
            }

        }
        updateBackgroundImage()
    }

    private func updateBackgroundImage() {
        var colorArray: [UIColor] = []
        switch newClosestIndex {
        case 0: colorArray = GETCOLOR
        case 1: colorArray = GETCOLOR2
        case 2: colorArray = GETCOLOR3
        default: colorArray = GETCOLOR
        }

        switch seletedArray.count {
        case 0: print("색을 선택해주세요")
        case 1: backgroundImage.image = CreateBackgroundImage().drawSingleColorBackground(size: imageView.frame.size, color: seletedArray.last!)
        case 2: backgroundImage.image = CreateBackgroundImage().drawTwoColorBackground(size: imageView.frame.size, colors: seletedArray)
        case 3: backgroundImage.image = CreateBackgroundImage().createThreePartColoredImage(size: imageView.frame.size, colors: seletedArray)
        case 4: backgroundImage.image = CreateBackgroundImage().drawFourColorBackground(size: imageView.frame.size, array: seletedArray)
        default: backgroundImage.image = CreateBackgroundImage().drawSixteenBackground(size: imageView.frame.size, array: colorArray)
        }
    }

    private func setupImageView() {

        let size = CGSize(width: view.frame.width, height: view.safeAreaLayoutGuide.layoutFrame.height*0.6)
        backgroundImage.image = CreateBackgroundImage().drawSixteenBackground(size: size, array: GETCOLOR)
        view.addSubview(backgroundImage)

        imageView.image = receiveImage
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        view.addSubview(imageView)

    }

    // 공유 버튼
    @objc private func btnPresent(_ sender: UIButton) {

        let saveImage = overlayImages(backgroundImage: backgroundImage.image!, foregroundImage: imageView.image!)
        let vc = UIActivityViewController(activityItems: [saveImage!], applicationActivities: nil)
        if UIDevice.current.isiPhone {
            present(vc, animated: true, completion: nil)
        } else {
            vc.popoverPresentationController?.sourceView = sender // 아이패드에서만 사용될 코드
            vc.popoverPresentationController?.sourceRect = sender.bounds // 아이패드에서만 사용될 코드

            present(vc, animated: true, completion: nil)
        }
    }

    // 저장 버튼
    @IBAction func btnSave(_ sender: Any) {

        // 배경과 이미지 겹친 후 저장
        let saveImage = overlayImages(backgroundImage: backgroundImage.image!, foregroundImage: imageView.image!)
        saveImageToAlbum(image: saveImage!)
    }

    // 앨범 저장 메서드
    private func saveImageToAlbum(image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { _, error in
            if error != nil {
                // 저장 중에 오류가 발생한 경우 처리
                DispatchQueue.main.async {
                    CustomFunction().showToast(message: "저장 실패", font: UIFont.systemFont(ofSize: 14), view: self.view)
                }
            } else {
                // 이미지 저장 성공

                DispatchQueue.main.async {
                    CustomFunction().showToast(message: "save_str".localized, font: UIFont.systemFont(ofSize: 14), view: self.view)
                }
            }
        }
    }

    // 이미지 겹치기
    private func overlayImages(backgroundImage: UIImage, foregroundImage: UIImage) -> UIImage? {
        let size = backgroundImage.size

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        backgroundImage.draw(in: CGRect(origin: .zero, size: size))
        let foregroundRect = CGRect(x: (size.width - foregroundImage.size.width) / 2,
                                    y: (size.height - foregroundImage.size.height) / 2,
                                    width: foregroundImage.size.width,
                                    height: foregroundImage.size.height)
        foregroundImage.draw(in: foregroundRect)

        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return mergedImage
    }

    private func createBorderView() -> UIView {
        let borderView = UIView()
        borderView.backgroundColor = UIColor(hex: "#F4F5F8")
        return borderView
    }

    private func setupConstraints() {

        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.width)
        }

        backgroundImage.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }

        resetButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(10)
            make.width.height.equalTo(50)

        }

        bottomView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
