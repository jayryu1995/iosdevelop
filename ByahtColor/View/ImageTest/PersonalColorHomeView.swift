//
//  PersonalColorHomeView.swift
//  ByahtColor
//
//  Created by jaem on 2023/12/22.
//

import SnapKit
import UIKit

class PersonalColorHomeView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let imageStackView = UIStackView()
    private let images = [UIImage(named: "tulip"), UIImage(named: "umbrella"), UIImage(named: "maple"), UIImage(named: "snow")]
    private let label = UILabel()
    private let tipsStackView = UIStackView()
    private let tipsTitleLabel = UILabel()
    private let tipsView = UIView()
    private let tips = [
        "Bạn nên sử dụng ảnh có ánh sáng trắng hoặc ảnh có ánh sáng tự nhiên để có kết quả chính xác nhất.",
        "Ưu tiên mặt mộc để test chính xác hơn nha.",
        "Chọn màu sắc giống với màu da thật của bạn nhất",
        "Chọn phần màu da trông không bị tái nhợt",
        "Chọn bên nào da nhìn mịn màng hơn"
    ]
    private let imageButton = UIButton()
    private let cameraButton = UIButton()

    private let permission = Permission()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupBackButton()
        setConfigView()
        setConfigLayout()
    }

    private func setConfigView() {
        setImageStackView()
        setLabel()
        setTipsView()
        setupTipsStackView()
        setupButtons()
    }

    private func setupButtons() {
        imageButton.setImage(UIImage(named: "icon_folder"), for: .normal)
        imageButton.setTitle("Chọn ảnh", for: .normal)
        imageButton.setTitleColor(UIColor.black, for: .normal)
        imageButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        imageButton.alignTextBelow()
        imageButton.addTarget(self, action: #selector(imageButtonAction), for: .touchUpInside)
        imageButton.layer.cornerRadius = 20
        imageButton.layer.borderWidth = 1
        imageButton.layer.borderColor = UIColor(red: 0.736, green: 0.74, blue: 0.755, alpha: 1).cgColor
        view.addSubview(imageButton)

        cameraButton.setImage(UIImage(named: "icon_camera"), for: .normal)
        cameraButton.setTitle("Camera", for: .normal)
        cameraButton.setTitleColor(UIColor.black, for: .normal)
        cameraButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        cameraButton.alignTextBelow()
        cameraButton.addTarget(self, action: #selector(cameraButtonAction), for: .touchUpInside)
        cameraButton.layer.cornerRadius = 20
        cameraButton.layer.borderWidth = 1
        cameraButton.layer.borderColor = UIColor(red: 0.736, green: 0.74, blue: 0.755, alpha: 1).cgColor
        view.addSubview(cameraButton)

    }

    private func setTipsView() {
        tipsView.backgroundColor = UIColor(hex: "#F4F5F8")
        tipsView.layer.cornerRadius = 24
        view.addSubview(tipsView)

        tipsTitleLabel.text = "Test Tip"
        tipsTitleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        tipsTitleLabel.textColor = UIColor(hex: "#935DFF")
        tipsView.addSubview(tipsTitleLabel)

    }

    private func createTipItem(withText text: String) -> UIStackView {
        let iconImageView = UIImageView(image: UIImage(named: "exclamation_icon"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 24, height: 24))
        }

        let tipLabel = UILabel()
        tipLabel.text = text
        tipLabel.numberOfLines = 2 // Allow label to wrap
        tipLabel.textColor = .black
        tipLabel.font = UIFont(name: "Pretendard-Regular", size: 14)

        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 8
        horizontalStackView.alignment = .center

        horizontalStackView.addArrangedSubview(iconImageView)
        horizontalStackView.addArrangedSubview(tipLabel)

        return horizontalStackView
    }

    private func setupTipsStackView() {
        tipsStackView.axis = .vertical
        tipsStackView.spacing = 5
        tipsStackView.distribution = .fillEqually
        tipsView.addSubview(tipsStackView)

        tipsStackView.snp.makeConstraints { make in
            make.top.equalTo(tipsTitleLabel.snp.bottom).offset(16)
            make.leading.equalTo(tipsView).offset(20)
            make.bottom.trailing.equalTo(tipsView).offset(-20)
        }

        for tip in tips {
            let horizontalStackView = createTipItem(withText: tip)
            tipsStackView.addArrangedSubview(horizontalStackView)
        }
    }

    private func setImageStackView() {
        view.addSubview(imageStackView)

        imageStackView.axis = .horizontal
        imageStackView.distribution = .fillEqually  // 모든 이미지 뷰의 크기를 동일하게 설정
        imageStackView.spacing = 28  // 원하는 간격을 설정

        // 이미지 뷰들을 스택 뷰에 추가
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit  // 이미지의 비율을 유지하면서 적절히 맞춤
            imageStackView.addArrangedSubview(imageView)
        }

    }

    private func setLabel() {
        label.text = "Find Your Color"
        label.textAlignment = .center
        label.font = UIFont(name: "Pretendard-Bold", size: 32)
        view.addSubview(label)
    }

    private func setConfigLayout() {

        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1.2)
            make.height.equalTo(90)
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(imageStackView.snp.bottom).offset(20)
            make.height.equalTo(42)
            make.centerX.equalToSuperview()
        }

        tipsView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().multipliedBy(0.8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        tipsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(tipsView).offset(14)
            make.leading.equalTo(tipsView).offset(14)
            make.trailing.equalTo(tipsView).offset(-14)
        }

        imageButton.snp.makeConstraints { make in
            make.top.equalTo(tipsView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view.snp.centerX).offset(-5)
            make.bottom.equalToSuperview().offset(-20)
        }

        cameraButton.snp.makeConstraints { make in
            make.top.equalTo(tipsView.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.centerX).offset(5)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    // 버튼 액션 핸들러
    @objc private func imageButtonAction() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary // .camera를 사용할 수도 있습니다.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    @objc private func cameraButtonAction() {

        permission.checkCameraPermissions { [weak self] granted in
            guard granted else {
                print("permission error")
                // 권한 없을 경우
                self?.showAlertForPermission()
                return
            }
            let vc = TestSelectionView2()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func showAlertForPermission() {
        let alert = UIAlertController(title: "access_str1".localized, message: "access_str2".localized, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "access_str3".localized, style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "access_str4".localized, style: .cancel, handler: nil)

        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    // UIImagePickerControllerDelegate 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        guard let selectedImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }

        let vc = CustomCircleViewController()

        vc.receiveImage = selectedImage.resizeAndCompressImage(maxResolution: 1080)// selectedImage로 수정필요
        self.navigationController?.pushViewController(vc, animated: true)

        // 이미지 피커 컨트롤러를 닫습니다.
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 사용자가 이미지 선택을 취소했을 때의 동작을 정의합니다.
        picker.dismiss(animated: true, completion: nil)
    }
}
