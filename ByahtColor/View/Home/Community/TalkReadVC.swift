//
//  boardDetailVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/16.
//

import UIKit
import SnapKit
import Alamofire

class TalkReadVC: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
    private var activityIndicator: UIActivityIndicatorView!
    let submitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_submit"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    private let bottomView = UIView()
    private let commentView = UITextView()
    private var commentList: [BoardCommentVO] = []
    private let tableView = UITableView()
    private let containerView = UIView()
    private let optionButton = UIButton()
    private let optionButton1 = UIButton()
    private let optionButton2 = UIButton()
    private var notification = false
    // 이전 뷰에서 전달받는 변수
    var board: Talk?
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.view.backgroundColor = .white

        if board?.id == User.shared.id || User.shared.auth == 2 {
            let moreButtonItem = UIBarButtonItem(image: UIImage(named: "icon_more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(moreButtonTapped))
            moreButtonItem.tintColor = .black // 원하는 색상으로 설정
            navigationItem.rightBarButtonItem = moreButtonItem
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        loadData()
        setView()
        setupBackButton()
        self.navigationItem.title = "Talk"
        notification = board?.notification ?? false

        // 스피너 초기화 및 설정
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)

    }

    private func setView() {
        setBottomView()
        setTableView()
        setContainView()
        updateNotificationButton()
        setupKeyboardNotifications()
    }

    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TalkCommentTableCell.self, forCellReuseIdentifier: "TalkCommentTableCell")
        tableView.register(TalkReadTableCell.self, forCellReuseIdentifier: "TalkReadTableCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }

    }

    private func setContainView() {

        optionButton.setTitle("상단 고정", for: .normal)
        optionButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 16)
        optionButton.setTitleColor(.black, for: .normal)
        optionButton.contentHorizontalAlignment = .left
        optionButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        optionButton.clipsToBounds = true

        optionButton1.setTitle("수정", for: .normal)
        optionButton1.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 16)
        optionButton1.setTitleColor(.black, for: .normal)
        optionButton1.contentHorizontalAlignment = .left
        optionButton1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        optionButton1.clipsToBounds = true

        optionButton2.setTitle("삭제", for: .normal)
        optionButton2.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 16)
        optionButton2.contentHorizontalAlignment = .left
        optionButton2.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        optionButton2.setTitleColor(.black, for: .normal)
        optionButton2.clipsToBounds = true

        optionButton2.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        optionButton1.addTarget(self, action: #selector(modifyButtonTapped), for: .touchUpInside)
        optionButton.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)

        let line = UIView()
        let line2 = UIView()
        line.backgroundColor = UIColor(hex: "#F7F7F7")
        line2.backgroundColor = UIColor(hex: "#F7F7F7")

        // 컨테이너 뷰 설정
        containerView.addSubview(optionButton)
        containerView.addSubview(optionButton1)
        containerView.addSubview(optionButton2)
        containerView.addSubview(line)
        containerView.addSubview(line2)
        containerView.isHidden = true // 초기 상태는 숨김
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = false

        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.12
        containerView.layer.shadowRadius = 32
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)

        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.trailing.equalToSuperview().offset(10)
            $0.bottom.equalTo(optionButton2.snp.bottom) // 이 부분을 추가
        }

        optionButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(44)
            $0.top.equalToSuperview()
        }

        line.snp.makeConstraints {
            $0.top.equalTo(optionButton.snp.bottom)
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
        }

        optionButton1.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(44)
            $0.top.equalTo(optionButton.snp.bottom).offset(1)
        }

        line2.snp.makeConstraints {
            $0.top.equalTo(optionButton1.snp.bottom)
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
        }

        optionButton2.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(44)
            $0.top.equalTo(optionButton1.snp.bottom).offset(1)
        }

    }

    private func setBottomView() {
        bottomView.backgroundColor = .white
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(80)
            $0.trailing.leading.equalToSuperview()
        }

        commentView.text = "talk_read_comment".localized
        commentView.font = UIFont(name: "Pretendard-Medium", size: 12)
        commentView.textColor = .lightGray
        commentView.backgroundColor = UIColor(hex: "#F7F7F7")
        commentView.layer.cornerRadius = 16
        commentView.delegate = self
        commentView.clipsToBounds = false
        bottomView.addSubview(commentView)

        commentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(52)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        view.addSubview(submitButton)

        submitButton.snp.makeConstraints { make in
            make.trailing.equalTo(commentView.snp.trailing).offset(-20)
            make.centerY.equalTo(commentView.snp.centerY)
        }

    }

    private func loadData() {
        let url = "\(Bundle.main.TEST_URL)/board/comment/all"
        let parameters: [String: Any] = [
            "board_no": board?.no ?? 0,
            "user_id": User.shared.id ?? ""
        ]

        AF.request(url, method: .post, parameters: parameters)
            .responseDecodable(of: [BoardCommentVO].self) { response in
                switch response.result {
                case .success(let commentResponse):
                    self.commentList = commentResponse
                    DispatchQueue.main.async {
                        self.setView()
                        self.tableView.reloadData()
                        self.view.layoutIfNeeded()
                    }

                case .failure(let error):
                    self.log(message: "loadData Error: \(error)")

                }
            }
    }

    @objc private func submitButtonTapped() {
        if let nickname = User.shared.name {
            self.activityIndicator.startAnimating()
            let url = "\(Bundle.main.TEST_URL)/board/comment/update"
            let parameters: [String: Any] = [
                "board_no": board?.no ?? 0,
                "nickname": nickname,
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
                        self.activityIndicator.stopAnimating()
                        self.tableView.reloadData()
                    case .failure(let error):
                        // 오류 처리
                        print("Error: \(error)")
                    }
                }

            commentView.text = ""
            commentView.resignFirstResponder()
        } else {
            setupAlertView()
        }

    }

    private func setupAlertView() {
        let alertVC = RegistAlertVC()
        alertVC.onConfirm = {
            let vc = InfluenceMyPageWriteVC()
            self.navigationController?.pushViewController(vc, animated: false)
        }
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true, completion: nil)
    }

    @objc private func moreButtonTapped() {
        containerView.isHidden = !containerView.isHidden
    }

    // 현재 뷰에서 키보드를 사용 중인 모든 텍스트 필드나 텍스트 뷰의 키보드를 숨깁니다.
    @objc override func dismissKeyboard() {
        view.endEditing(true)
        containerView.isHidden = true
    }

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.3, animations: {
                // bottomView의 제약을 업데이트합니다.
                self.bottomView.snp.remakeConstraints { make in
                    make.height.equalTo(80)
                    make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
                    make.bottom.equalToSuperview().offset(-keyboardHeight)
                }
                // 레이아웃을 즉시 업데이트하여 변경사항을 반영합니다.
                self.view.layoutIfNeeded()

                // 이 단계에서 tableView를 스크롤합니다.
                let lastSectionIndex = max(0, self.tableView.numberOfSections - 1)
                let lastRowIndex = max(0, self.tableView.numberOfRows(inSection: lastSectionIndex) - 1)
                if lastRowIndex > 0 {
                    let indexPath = IndexPath(row: lastRowIndex, section: lastSectionIndex)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                } else {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: false)
                }
            })
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.bottomView.snp.remakeConstraints { make in
                make.height.equalTo(80)
                make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            }
            self.view.layoutIfNeeded()
        }
    }

    // 삭제
    @objc private func deleteButtonTapped() {

        guard let no = board?.no else { return }
        let url = "\(Bundle.main.TEST_URL)/board/del/\(no)" // 실제 요청할 서버의 URL로 변경해주세요.

        AF.request(url, method: .delete).response { response in
            switch response.result {
            case .success:
                self.navigationController?.popViewController(animated: true)

            case .failure(let error):
                self.log(message: "deleteButtonTapped error : \(error)")
            }
        }
    }

    // 상단고정
    @objc private func notificationButtonTapped() {
        guard let no = board?.no else { return }
        let url = "\(Bundle.main.TEST_URL)/board/update/notification/\(no)" // 실제 요청할 서버의 URL로 변경해주세요.
        AF.request(url, method: .put).response { response in
            switch response.result {
            case .success:
                self.log(message: "Success to Update Notification")
                self.notification = !self.notification
                self.updateNotificationButton()
            case .failure(let error):
                self.log(message: "Fail to Update Notification : \(error)")
            }
        }
    }

    private func updateNotificationButton() {
        if notification {
            optionButton.setTitle("고정 해제", for: .normal)
        } else {
            optionButton.setTitle("상단 고정", for: .normal)
        }
    }

    // 수정
    @objc private func modifyButtonTapped() {
        let vc = TalkModifyVC()
        vc.board = board
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // UITextViewDelegate 메서드
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentView.text == "Nhập bình luận." {
            commentView.text = nil
            commentView.textColor = .black // 입력 텍스트 색상 변경
        }
    }

}

extension TalkReadVC: UITableViewDataSource, UITableViewDelegate, TalkCommentTableCellDelegate {

    func didRequestDelete(_ cell: TalkCommentTableCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        // 데이터 모델에서 해당 코멘트 제거
        commentList.remove(at: indexPath.row)
        // 테이블 뷰에서 셀 제거
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return commentList.count // 댓글 수
        default: return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TalkReadTableCell", for: indexPath) as! TalkReadTableCell
            cell.selectionStyle = .none
            cell.configure(with: board!)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TalkCommentTableCell", for: indexPath) as! TalkCommentTableCell
            let index = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            cell.setData(comment: commentList[index])
            return cell

        default:
            log(message: "tableview error")

            return UITableViewCell()

        }
    }

}
