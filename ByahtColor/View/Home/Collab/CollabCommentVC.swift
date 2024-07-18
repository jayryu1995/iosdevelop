//
//  SnapCommentVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/02/01.
//

import UIKit
import Alamofire
import SnapKit

class CollabCommentVC: UIViewController, UITextViewDelegate {
    var contentNo = 0
    var commentList: [CollabCommentVO] = []
    let titleLabel = UILabel()
    let tableView = UITableView()
    let commentView = UITextView()
    let submitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_submit"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupTitleLabel()
        setupTableView()
        setupTextView()
        setSubmitButton()
        setupTapGesture()
        setupKeyboardNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func loadData() {
        let url = "\(Bundle.main.TEST_URL)/snap/comment/all"
        print("contentNo : \(contentNo)")
        let parameters: [String: Any] = [
            "snap_no": contentNo,
            "user_id": User.shared.id ?? ""
        ]

        AF.request(url, method: .post, parameters: parameters)
            .responseDecodable(of: [CollabCommentVO].self) { response in
                switch response.result {
                case .success(let commentResponse):
                    // 서버 응답 처리
                    self.commentList = commentResponse
                    print("Response Data: \(commentResponse)")
                    self.tableView.reloadData()

                case .failure(let error):
                    // 오류 처리
                    print("Error: \(error)")
                }
            }
    }

    private func setSubmitButton() {
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        view.addSubview(submitButton)

        submitButton.snp.makeConstraints { make in
            make.trailing.equalTo(commentView.snp.trailing).offset(-20)
            make.centerY.equalTo(commentView.snp.centerY)
        }
    }

    private func setupTextView() {
        commentView.text = "Nhập bình luận."
        commentView.font = UIFont(name: "Pretendard-Medium", size: 12)
        commentView.textColor = .lightGray
        commentView.backgroundColor = UIColor(hex: "#F7F7F7")
        commentView.layer.cornerRadius = 16
        commentView.delegate = self
        commentView.clipsToBounds = false
        view.addSubview(commentView)

        commentView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    private func setupTitleLabel() {
        // titleLabel 설정
        titleLabel.text = "Reply"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    private func setupTableView() {

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
        }

        // TableView 기본 설정
        tableView.register(CollabCommentTableCell.self, forCellReuseIdentifier: "CollabCommentTableCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    // UITextViewDelegate 메서드
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Nhập bình luận." {
            textView.text = nil
            textView.textColor = .black // 입력 텍스트 색상 변경
        }
    }

    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.3) {
                self.tableView.snp.remakeConstraints { make in
                    make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
                    make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-100-keyboardHeight)
                }

                self.commentView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-keyboardHeight)
                }
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.snp.remakeConstraints { make in
                make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
                make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-100)
            }
            self.commentView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            }
            self.view.layoutIfNeeded()
        }
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func submitButtonTapped() {
        print("제출되었습니다")

        let url = "\(Bundle.main.TEST_URL)/snap/comment/update"
        let parameters: [String: Any] = [
            "snap_no": contentNo,
            "nickname": User.shared.nickname as Any,
            "writer_id": User.shared.id as Any,
            "content": commentView.text as Any,
            "depth": 0
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    // 서버 응답 처리
                    print("Response Data: \(data)")
                    self.loadData()
                case .failure(let error):
                    // 오류 처리
                    print("Error: \(error)")
                }
            }

        commentView.text = ""
        commentView.resignFirstResponder()
    }
}

// UITableViewDataSource 및 UITableViewDelegate 확장
extension CollabCommentVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let cellHeight = CGFloat(100)

        return cellHeight
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 테이블 뷰에 표시할 항목 수를 반환합니다.
        return commentList.count // 예시
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀을 구성하고 반환합니다.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollabCommentTableCell", for: indexPath) as! CollabCommentTableCell
        let comment = commentList[indexPath.row]

        cell.setData(comment: comment)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀이 선택되었을 때의 동작을 여기에 작성합니다.
        print("Selected Comment \(indexPath.row)")
    }

}
