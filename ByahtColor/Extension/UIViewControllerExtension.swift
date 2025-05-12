//
//  UIViewControllerExtension.swift
//  ByahtColor
//
//  Created by jaem on 4/29/25.
//
import UIKit
import SnapKit
import Foundation
extension UIViewController {

    // 뒤로가기 버튼
    func setupBackButton() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(named: "icon_Arrow"), style: .plain, target: self, action: #selector(goBack))
        newBackButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = newBackButton
    }

    func setupBackButton2() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(goBack))
        newBackButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = newBackButton
    }

    @objc private func goBack() {
        self.navigationController?.popViewController(animated: false)
    }

    // 키보드 숨기기 기능
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func log(message: String) {
        let vcName = String(describing: type(of: self))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: Date())
        let logMessage = "[\(vcName)] || \(dateString): \(message)\n"
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileURL = documentsDirectory.appendingPathComponent("log.txt")

        if let outputStream = OutputStream(url: fileURL, append: true) {
            outputStream.open()
            let bytesWritten = outputStream.write(logMessage, maxLength: logMessage.lengthOfBytes(using: .utf8))
            if bytesWritten < 0 {
                print("write failure")
            }
            outputStream.close()
            print(logMessage)
        } else {
            print("Unable to open file")
        }
    }

    func loadImageFromURL(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }

   
    func getLanguage() -> String {
        let currentLanguage = Locale.current.languageCode
            
        switch currentLanguage {
        case "ko": // 한국어
            return "ko"
        case "vi": // 베트남어
            return "vi"
        case "jp": // 일본어
            return "jp"
        default: // 그 외 다른 언어의 경우
            return "en" // 영어로 기본 설정
        }
    }
    
    
    //기업 회원가입
    
    func makeButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(hex: "#4E505B"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.layer.borderColor = UIColor(hex: "#B5B8C2").cgColor
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }

    func makeLabel(text: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = text.localized
        lbl.font = UIFont(name: "Pretendard-Regular", size: 14)
        lbl.textColor = UIColor(hex: "#4E505B")
        return lbl
    }

    func makeTextField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder.localized
        tf.textColor = UIColor(hex: "#B5B8C2")
        tf.font = UIFont(name: "Pretendard-Regular", size: 14)
        return tf
    }
    
    func makeContainerView(withLabel label: UILabel, textField: UITextField, button: UIButton?) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 4
        containerView.addSubview(label)

        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill

        stackView.addArrangedSubview(textField)
        if let button = button {
            stackView.addArrangedSubview(button)
        }

        containerView.addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.leading.equalTo(label.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }

        if let button = button {
            button.snp.makeConstraints {
                $0.width.equalTo(60)
            }
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        return containerView
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// 아래와 같은 모양·그림자의 토스트를 띄웁니다.
    func showToast(
            message: String,
            icon: UIImage? = nil,
            duration: TimeInterval = 2.0
        ) {
            // 1) 컨테이너 뷰
            let toast = UIView()
            view.addSubview(toast)
            toast.snp.makeConstraints {
                $0.width.equalTo(350)
                $0.height.equalTo(56)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            }

            // 2) 그림자 뷰
            let shadows = UIView()
            shadows.clipsToBounds = false
            toast.addSubview(shadows)
            shadows.snp.makeConstraints { $0.edges.equalToSuperview() }

            let shadowLayer = CALayer()
            shadowLayer.shadowPath = UIBezierPath(
                roundedRect: shadows.bounds,
                cornerRadius: 16
            ).cgPath
            shadowLayer.shadowColor   = UIColor(white: 0, alpha: 0.15).cgColor
            shadowLayer.shadowOpacity = 1
            shadowLayer.shadowRadius  = 18
            shadowLayer.shadowOffset  = CGSize(width: 0, height: 5)
            shadows.layer.addSublayer(shadowLayer)

            // 3) 배경 쉐이프 뷰
            let shapes = UIView()
            shapes.clipsToBounds      = true
            shapes.layer.cornerRadius = 16
            shapes.backgroundColor    = UIColor(red: 0.067, green: 0.067, blue: 0.067, alpha: 1)
            toast.addSubview(shapes)
            shapes.snp.makeConstraints { $0.edges.equalToSuperview() }

            // 4) 아이콘 (있다면)
            var iconView: UIImageView?
            if let iconImage = icon {
                let iv = UIImageView(image: iconImage)
                iv.contentMode = .scaleAspectFit
                shapes.addSubview(iv)
                iv.snp.makeConstraints {
                    $0.leading.equalToSuperview().offset(16)
                    $0.centerY.equalToSuperview()
                    $0.width.height.equalTo(24)
                }
                iconView = iv
            }

            // 5) 메시지 레이블
            let label = UILabel()
            label.text          = message
            label.textColor     = .white
            label.font          = .systemFont(ofSize: 14)
            label.textAlignment = .left
            label.numberOfLines = 0
            shapes.addSubview(label)
            label.snp.makeConstraints { make in
                if let iv = iconView {
                    make.leading.equalTo(iv.snp.trailing).offset(8)
                } else {
                    make.leading.equalToSuperview().offset(16)
                }
                make.trailing.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
            }

            // 6) 레이아웃 확정 후 페이드 인·아웃
            toast.layoutIfNeeded()
            toast.alpha = 0
            UIView.animate(withDuration: 0.2) { toast.alpha = 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                UIView.animate(withDuration: 0.3, animations: {
                    toast.alpha = 0
                }) { _ in
                    toast.removeFromSuperview()
                }
            }
        }
    
    
}
