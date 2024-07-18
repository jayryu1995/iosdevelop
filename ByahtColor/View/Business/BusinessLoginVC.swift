//
//  BusinessLoginVC.swift
//  ByahtColor
//
//  Created by jaem on 6/12/24.
//

import Foundation
import UIKit

class BusinessLoginVC: UIViewController {

    lazy private var tf_id: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "Pretendard-Medium", size: 16)
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(hex: "#E5E6EA").cgColor
        tf.layer.cornerRadius = 4
        tf.leftPadding()
        tf.attributedPlaceholder = NSAttributedString(
            string: "ID",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#B5B8C2")]
        )
        tf.delegate = self
        return tf
    }()

    lazy private var tf_passwd: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "Pretendard-Medium", size: 16)
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(hex: "#E5E6EA").cgColor
        tf.layer.cornerRadius = 4
        tf.leftPadding()
        tf.attributedPlaceholder = NSAttributedString(
                string: "Password",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#B5B8C2")]
            )
        tf.isSecureTextEntry = true // 비밀번호 표시 설정
        tf.delegate = self
        return tf

    }()
    lazy private var btn_login: UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.setBackgroundColor(UIColor(hex: "#111111"), for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()

    lazy private var btn_join: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle(("login_join".localized), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.clipsToBounds = true
        return button
    }()

    lazy private var btn_findId: UIButton = {
        let button = UIButton()
        button.setTitle(("login_find_account".localized), for: .normal)
        button.setTitleColor(UIColor(hex: "#B5B8C2"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.clipsToBounds = true
        button.isHidden = true
        return button
    }()

    lazy private var imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "image_business_login"))
        image.contentMode = .scaleAspectFill
        return image
    }()

    lazy private var bottomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = UIColor(hex: "#B5B8C2")
        label.text = "login_str2".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    lazy private var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = UIColor(hex: "#FF2727")
        label.isHidden = true
        return label
    }()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    lazy private var viewModel = MemberViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        setupButtons()
        setupConstraints()
        setupGesture()
        setupKeyboardNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    private func setupButtons() {
        btn_join.addTarget(self, action: #selector(buttonJoinTapped), for: .touchUpInside)
        btn_login.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        btn_findId.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func submitButtonTapped() {

        guard let username = tf_id.text, !username.isEmpty,
              let password = tf_passwd.text, !password.isEmpty else {
            print("Please enter valid credentials")
            errorLabel.text = "login_str3".localized
            errorLabel.isHidden = false
            return
        }

        viewModel.loginBusiness(userid: username, password: password ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let business):
                    User.shared.id = business.memberId
                    User.shared.auth = 2
                    User.shared.name = business.business_name ?? nil

                    UserDefaults.standard.setValue(business.memberId, forKey: "businessId")
                    UserDefaults.standard.setValue(2, forKey: "auth")
                    UserDefaults.standard.setValue(business.business_name, forKey: "name")

                    let vc = TabBarViewController()
                    self?.navigationController?.pushViewController(vc, animated: false)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self?.errorLabel.text = "login_str4".localized
                    self?.errorLabel.isHidden = false
                }
            }
        }
    }

    @objc private func buttonJoinTapped() {
        let vc = BusinessSignUpVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func buttonTapped() {
        let vc = FindAccountVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func setupConstraints() {
        contentView.addSubview(tf_id)
        contentView.addSubview(tf_passwd)
        contentView.addSubview(btn_login)
        contentView.addSubview(btn_join)
        contentView.addSubview(btn_findId)
        contentView.addSubview(imageView)
        contentView.addSubview(errorLabel)
        contentView.addSubview(bottomLabel)

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.greaterThanOrEqualTo(scrollView).priority(.low)
        }

        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(imageView.snp.width).multipliedBy(264.0 / 350.0)
        }

        tf_id.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }

        tf_passwd.snp.makeConstraints {
            $0.top.equalTo(tf_id.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }

        errorLabel.snp.makeConstraints {
            $0.top.equalTo(tf_passwd.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }

        btn_login.snp.makeConstraints {
            $0.top.equalTo(errorLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }

        btn_join.snp.makeConstraints {
            $0.top.equalTo(btn_login.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }

        btn_findId.snp.makeConstraints {
            $0.top.equalTo(btn_login.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(20)
        }

        bottomLabel.snp.makeConstraints {
            $0.top.equalTo(btn_join.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets

                // 현재 활성화된 텍스트 필드를 스크롤뷰의 가시 영역에 맞추기
                var visibleRect = view.frame
                visibleRect.size.height -= keyboardSize.height
                if let activeField = view.firstResponder, !visibleRect.contains(activeField.frame.origin) {
                    scrollView.scrollRectToVisible(activeField.frame, animated: true)
                }
            }
        }

        @objc private func keyboardWillHide(notification: NSNotification) {
            let contentInsets = UIEdgeInsets.zero
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
}

extension BusinessLoginVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 제한할 텍스트 길이
        let maxLength = 20
        // 새로운 텍스트 길이 계산
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           if textField == tf_id {
               tf_passwd.becomeFirstResponder()
           } else if textField == tf_passwd {
               textField.resignFirstResponder()
               submitButtonTapped()
           }
           return true
       }
}
