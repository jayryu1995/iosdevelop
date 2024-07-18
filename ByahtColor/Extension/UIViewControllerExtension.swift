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
        self.navigationController?.popViewController(animated: true)
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
        print(logMessage)
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
}
