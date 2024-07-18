//
//  CustomCircleViewController.swift
//  ByahtColor
//
//  Created by jaem on 2023/12/26.
//

import UIKit
import MLKit
import MLImage
import SnapKit

class CustomCircleViewController: UIViewController, UINavigationControllerDelegate {

    // 내부 변수
    var receiveImage: UIImage?
    private let imageView = UIImageView()
    private let button = UIButton()
    private let tipView = UIView()
    private let tipStackView = UIStackView()
    private let tipViewTitle = UILabel()
    private let tipViewContent = UILabel()
    private var canvasView = CanvasView()
    var cropRect: CGRect?
    let segmentationMaskAlpha: CGFloat = 0.5
    private var segmenter: Segmenter?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        view.backgroundColor = .white
        // 뒤로 버튼
        setupBackButton()
        self.navigationItem.title = "Personal Color"
        imageView.image = self.receiveImage
        setupCanvas()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setupConstraints()
    }

    private func configureView() {
        setupImageView()
        setupTipView()
        setupTipStackView()
        setupButton()
    }

    private func setupTipView() {
        canvasView = CanvasView(frame: CGRect(origin: .zero, size: imageView.frame.size))
        tipView.backgroundColor = UIColor(hex: "#F4F5F8")
        tipView.layer.cornerRadius = 24
        view.addSubview(tipView)

    }

    private func setupTipStackView() {
        tipStackView.axis = .vertical
        tipStackView.spacing = 5
        tipView.addSubview(tipStackView)
        tipStackView.snp.makeConstraints { make in
            make.top.equalTo(tipView.snp.top).offset(24)
            make.leading.equalTo(tipView).offset(24)
            make.bottom.trailing.equalTo(tipView).offset(-24)
        }

        tipViewTitle.text = "Test Tip"
        tipViewTitle.textColor = UIColor(hex: "#935DFF")
        tipViewTitle.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        tipStackView.addArrangedSubview(tipViewTitle)

        let tips = "Xác định khuôn mặt vừa hình sau rồi bấm nút tiếp."
        let horizontalStackView = createTipItem(withText: tips)
        tipStackView.addArrangedSubview(horizontalStackView)
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

    private func setupButton() {
        button.backgroundColor = .black
        button.setTitle("Tiếp", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(buttonOn), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc private func buttonOn() {
        if imageView.image != nil {
            let options = SelfieSegmenterOptions()
            options.segmenterMode = .singleImage
            segmenter = Segmenter.segmenter(options: options)

            CustomFunction().detectSegmentationMask(segmenter: segmenter!, image: imageView.image!) { maskedImage in
                self.imageView.image = maskedImage

                self.canvasView.removeFromSuperview()
                UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, false, 0.0)
                self.imageView.backgroundColor = .clear
                self.imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                // 변환된 이미지 사용
                let cropRect = self.canvasView.CircleRect()
                let cropImage = self.canvasView.cropInsideCircle(image: image!)
                let vc = TestSelectionView()

                vc.cropRect = cropRect
                vc.receiveImage = CustomFunction().cropImageToCircle(image: cropImage!, cropRect: cropRect!)

                vc.originImage = self.receiveImage
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    private func setupImageView() {
        // 이미지 차후 수정 필요
        imageView.image = receiveImage
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
    }

    private func setupCanvas() {

        canvasView.backgroundColor = UIColor.clear
        imageView.addSubview(canvasView)

        canvasView.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }
    }

    private func setupConstraints() {

        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview().multipliedBy(0.6)
            make.leading.trailing.equalToSuperview()
        }

        tipView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.bottom.equalToSuperview().multipliedBy(0.8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(tipView.snp.bottom).offset(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }

    }
}
