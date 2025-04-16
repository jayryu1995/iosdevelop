//
//  UIViewControllerExtension.swift
//  ByahtColor
//
//  Created by jaem on 2023/07/21.
//

import UIKit

extension UIViewController {

    // POP 제스쳐
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // or false
      }

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

    // 상태바 컬러 변경
    func changeStatusBarBgColor(bgColor: UIColor?) {
            if #available(iOS 13.0, *) {
                let window = UIApplication.shared.windows.first
                let statusBarManager = window?.windowScene?.statusBarManager

                let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
                statusBarView.backgroundColor = bgColor

                window?.addSubview(statusBarView)
            } else {
                let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
                statusBarView?.backgroundColor = bgColor
            }
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

    // 샌드버드

    public static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: Bundle(for: T.self))
        }

        return instantiateFromNib()
    }

    public func presentAlert(title: String, message: String?, closeHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { _ in closeHandler?() }))
        present(alert, animated: true)
    }

    public func presentTextFieldAlert(title: String, message: String?, defaultTextFieldMessage: String, didConfirm: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField { textField in
            textField.text = defaultTextFieldMessage
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Confirm", style: .default) { [weak alert] _ in
            guard let textFieldText = alert?.textFields?.first?.text else { return }

            didConfirm(textFieldText)
        })

        present(alert, animated: true)
    }

    public func presentAlert(error: Error) {
        presentAlert(title: "Error", message: error.localizedDescription)
    }

    func getLanguageNumber() -> String {
        let currentLanguage = Locale.current.languageCode
        print(currentLanguage)
        switch currentLanguage {
        case "ko": // 한국어
            return "0"
        case "ja": // 일본어
            return "1"
        case "th": // 태국어
            return "2"
        case "tl": // 필리핀어 (타갈로그어)
            return "3"
        case "vi": // 베트남어
            return "4"
        case "en-SG": // 싱가포르 영어
            return "5"
        case "en": // 영어
            return "6"
        case "ar": // 영어
            return "6"
        default: // 그 외 다른 언어의 경우
            return "6" // 영어로 기본 설정
        }
    }
    
    func getLanguage() -> String {
        let currentLanguage = Locale.current.languageCode
            print("Locale.current.languageCode: \(Locale.current.languageCode)")
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
    
    func numTransToNation(num : String) -> String {
        if num == "0" {
            return "ko"
        }else if num == "4"{
            return "vi"
        }else{
            return "en"
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
}
