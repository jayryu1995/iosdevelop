//
//  CompareCameraView.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/04.
//

import UIKit
import AVFoundation
import SnapKit
import Photos

class CompareCameraView: UIViewController {
    private let imageView = UIImageView()
    // 카메라 뷰
    private var captureSession: AVCaptureSession!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var capturePhotoOutput: AVCapturePhotoOutput?
    private var currentCameraPosition: AVCaptureDevice.Position = .front
    var stillImageOutput: AVCapturePhotoOutput!
    private var frameView = UIView()

    private let selectLabel = UILabel()
    private let stageLabel = UILabel()
    private let colorButton1 = UIButton()
    private let colorButton2 = UIButton()
    private let nextButton = NextButton()
    private let WARMCOOL: [[UIColor]] = ColorPalettes.WARMCOOL
    private var stage = 1
    private var selectNumber = 0
    private var selectedList: [Int] = []

    var receiveImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        view.backgroundColor = .white
        self.navigationItem.title = "Personal Color"
        // 처음으로 버튼
        setupPopButton2()

        // 카메라 화면 준비
        startCamera()
    }

    private func setupViews() {
        setupFrameView()
        setImageView()
        setLabels()
        setColorButtons()
        setNextButton()
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

    private func setNextButton() {
        nextButton.setTitle("Chọn", for: .normal)
        nextButton.addTarget(self, action: #selector(buttonNextTapped), for: .touchUpInside)
        nextButton.titleLabel?.textColor = .white
        nextButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        nextButton.layer.cornerRadius = 12
        view.addSubview(nextButton)
    }

    private func setLabels() {
        selectLabel.text = "Chọn tông ấm/tông lạnh"
        stageLabel.text = "\(stage) / 5"

        selectLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        stageLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        stageLabel.textColor = UIColor(hex: "#4E505B")

        view.addSubview(selectLabel)
        view.addSubview(stageLabel)

    }

    private func setColorButtons() {

        colorButton1.layer.cornerRadius = 20
        colorButton1.tag = 0
        colorButton1.backgroundColor = WARMCOOL[0][0]
        colorButton1.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        colorButton2.layer.cornerRadius = 20
        colorButton2.tag = 1
        colorButton2.backgroundColor = WARMCOOL[0][1]
        colorButton2.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        view.addSubview(colorButton1)
        view.addSubview(colorButton2)
    }

    private func setImageView() {
        let size = CGSize(width: view.frame.width, height: view.frame.width)
        imageView.image = CreateBackgroundImage().drawSingleWholeBackground(size: size, color: WARMCOOL[0][0])
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = false
        view.addSubview(imageView)
    }

    @objc private func buttonNextTapped() {
        selectedList.append(selectNumber)
        if stage < 5 {
            stage += 1
            resetView()
        } else {
            let count = selectedList.filter {$0 == 0 }.count
            let vc = TestResultView()
            // 웜톤일 때
            if count > 2 {
                vc.seasonTon = "warm"
            } else {
                // 쿨톤일 때
                vc.seasonTon = "cool"
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    @objc private func buttonTapped(_ sender: UIButton) {
        selectNumber = sender.tag

        // 모든 버튼의 테두리를 제거합니다.
        colorButton1.layer.borderWidth = 0
        colorButton2.layer.borderWidth = 0

        // 선택된 버튼에 테두리를 추가합니다.
        sender.layer.borderWidth = 5
        sender.layer.borderColor = UIColor(hex: "#935DFF").cgColor
        imageView.image = CreateBackgroundImage().drawSingleWholeBackground(size: view.frame.size, color: sender.backgroundColor!)
    }

    private func resetView() {

        colorButton1.layer.borderWidth = 0
        colorButton2.layer.borderWidth = 0
        stageLabel.text = "\(stage) / 5"
        colorButton1.backgroundColor = WARMCOOL[stage-1][0]
        colorButton2.backgroundColor = WARMCOOL[stage-1][1]
        imageView.image = CreateBackgroundImage().drawSingleWholeBackground(size: view.frame.size, color: WARMCOOL[stage-1][0])

    }

    private func setupConstraints() {
        frameView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.snp.width)
            make.width.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalTo(frameView) // imageView의 제약 조건을 frameView와 동일하게 설정
        }

        selectLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.height.equalTo(20)
            make.leading.equalToSuperview().offset(30)
        }

        stageLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().inset(30)
        }

        let width = UIScreen.main.bounds.width/3.5

        colorButton1.snp.makeConstraints { make in
            make.top.equalTo(selectLabel.snp.bottom).offset(10)
            make.trailing.equalTo(view.snp.centerX).offset(-20)
            make.width.equalTo(width)
            make.bottom.equalToSuperview().multipliedBy(0.85)
        }

        colorButton2.snp.makeConstraints { make in
            make.top.equalTo(selectLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.centerX).offset(20)
            make.width.equalTo(width)
            make.bottom.equalToSuperview().multipliedBy(0.85)
        }

        nextButton.snp.makeConstraints { make in
            make.top.equalTo(colorButton1.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().multipliedBy(0.95)
        }

    }

}
