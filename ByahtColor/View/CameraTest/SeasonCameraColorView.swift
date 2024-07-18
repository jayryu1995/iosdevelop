//
//  SeasonCameraColorView.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/05.
//

import UIKit
import SnapKit
import Photos
import AVFoundation

class SeasonCameraColorView: UIViewController, UIScrollViewDelegate {

    private let imageView = UIImageView()
    private let scrollView = UIScrollView()
    private let bottomView = UIView()
    private let resetButton = UIButton()
    private var seletedArray: [UIColor] = []
    private var GETCOLOR: [UIColor] = []
    private var GETCOLOR2: [UIColor] = []
    private var GETCOLOR3: [UIColor] = []
    private var labelArray: [String] = []
    // 카메라 뷰
    private var captureSession: AVCaptureSession!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var capturePhotoOutput: AVCapturePhotoOutput?
    private var currentCameraPosition: AVCaptureDevice.Position = .front
    var stillImageOutput: AVCapturePhotoOutput!
    private var frameView = UIView()
    private var mergeImage: UIImage?

    // 가로로 아이템들을 정렬할 UIStackView 생성
    private var stackView = UIStackView()

    var season = ""
    var colorCount = 0

    // VIEW WILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        view.backgroundColor = UIColor(hex: "#F4F5F8")

        // 뒤로 버튼
        setupBackButton()
        self.navigationItem.title = "Personal Color"

        // 카메라 화면 준비
        startCamera()

    }

    // VIEW DIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setupColor()
        setupViews()
        setupConstraints()
        adjustImageScale(scrollView: scrollView)
        firstImageCenterSetting( scrollView)
    }

    private func setupViews() {
        setupFrameView()
        setupImageView()
        setupResetButton()
        setupBottomView()
    }

    private func startCamera() {
        // 카메라 세팅
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo

        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
        guard let frontCamera = discoverySession.devices.first else {
            print("Unable to access front camera!")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            stillImageOutput = AVCapturePhotoOutput()

            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLiveCameraView()
            }
        } catch let error {
            print("Error Unable to initialize front camera: \(error.localizedDescription)")
        }

        // 캡처 세션 시작
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.startRunning()

        }
    }

    private func setupFrameView() {
        view.addSubview(frameView)
    }

    private func setupLiveCameraView() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        frameView.layer.addSublayer(videoPreviewLayer)
        view.bringSubviewToFront(imageView)
        // Step12
        DispatchQueue.global(qos: .userInitiated).async { // [weak self] in
            self.captureSession.startRunning()
            // Step 13
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.frameView.bounds
            }
        }
        // 캡처 세션 시작
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.startRunning()

        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 백그라운드 스레드에서 카메라 세션을 중단합니다.
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.stopRunning()
        }
    }

    private func setupResetButton() {
        let image = UIImage(named: "reset")
        resetButton.setImage(image, for: .normal)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        imageView.isUserInteractionEnabled = true
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

    ///////

    private func itemViewButtonReset() {
        seletedArray = []

        // scrollView의 모든 itemView를 순회합니다.
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
                                print("실행")
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
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
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
        saveButton.setTitle("저장하기", for: .normal)
        saveButton.setTitleColor(UIColor(hex: "#935DFF"), for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        saveButton.addTarget(self, action: #selector(btnSave), for: .touchUpInside)

        let shareButton = UIButton()
        shareButton.setTitle("공유하기", for: .normal)
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

        imageView.image = CreateBackgroundImage().drawSixteenWholeBackground(size: frameView.frame.size, array: colorArray)
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
        updateimageView()
    }

    private func updateimageView() {
        var colorArray: [UIColor] = []
        switch newClosestIndex {
        case 0: colorArray = GETCOLOR
        case 1: colorArray = GETCOLOR2
        case 2: colorArray = GETCOLOR3
        default: colorArray = GETCOLOR
        }

        switch seletedArray.count {
        case 0: print("색을 선택해주세요")
        case 1: imageView.image = CreateBackgroundImage().drawSingleWholeBackground(size: frameView.frame.size, color: seletedArray.last!)
        case 2: imageView.image = CreateBackgroundImage().drawTwoWholeColorBackground(size: frameView.frame.size, colors: seletedArray)
        case 3: imageView.image = CreateBackgroundImage().drawThreeWholeColorBackground(size: frameView.frame.size, colors: seletedArray)
        case 4: imageView.image = CreateBackgroundImage().drawFourWholeColorBackground(size: frameView.frame.size, array: seletedArray)
        default: imageView.image = CreateBackgroundImage().drawSixteenWholeBackground(size: frameView.frame.size, array: colorArray)
        }
    }

    private func setupImageView() {

        let size = CGSize(width: view.frame.width, height: view.frame.width)
        imageView.image = CreateBackgroundImage().drawSixteenWholeBackground(size: size, array: GETCOLOR)
        view.addSubview(imageView)

    }

    @objc private func btnPresent(_ sender: UIButton) {
        // AVCapturePhotoSettings 생성
        let photoSettings = AVCapturePhotoSettings()
        // 캡처 세션에서 사진 촬영 요청
        stillImageOutput?.capturePhoto(with: photoSettings, delegate: self)
        if let imageToShare = self.mergeImage {
                let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
                present(activityViewController, animated: true, completion: nil)
            }

    }

    @objc private func btnSave(_ sender: UIButton) {
        // AVCapturePhotoSettings 생성
        let photoSettings = AVCapturePhotoSettings()
        // 캡처 세션에서 사진 촬영 요청
        stillImageOutput?.capturePhoto(with: photoSettings, delegate: self)
    }

    // 저장 메서드
    @objc private func saveImageToAlbum(image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { _, error in
            if let error = error {
                // 저장 중에 오류가 발생한 경우 처리
                print("error")
            } else {
                print("success")

            }
        }
    }

    private func createBorderView() -> UIView {
        let borderView = UIView()
        borderView.backgroundColor = UIColor(hex: "#F4F5F8")
        return borderView
    }

    private func setupConstraints() {

        frameView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.snp.width)
            make.width.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalTo(frameView)
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

extension SeasonCameraColorView: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("저장")
        guard let imageData = photo.fileDataRepresentation(),
              let capturedImage = UIImage(data: imageData) else {
            print("Error capturing photo: \(String(describing: error))")
            return
        }
        // 백그라운드 이미지와 합성
        let backImage = imageView.image?.resized(to: capturedImage.size)
        mergeImage = overlayImages(backgroundImage: capturedImage, foregroundImage: backImage!)?.fixOrientation()
        saveImageToAlbum(image: mergeImage!)
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
}
