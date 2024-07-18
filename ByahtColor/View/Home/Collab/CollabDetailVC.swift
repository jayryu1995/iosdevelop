//
//  SnapDetailVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/23.
//

import UIKit
import SnapKit
import Alamofire
import FloatingPanel

class CollabDetailVC: UIViewController, UIGestureRecognizerDelegate {

    // 데이터 소스: 매거진 목록
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        return tableView
    }()

    private let requestButton: UIButton = {
        let button = UIButton()
        button.setTitle("collab_detail_submit".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 4
        return button
    }()

    private let containerView = UIView()
    private let optionButton = UIButton()
    private let optionButton1 = UIButton()
    private let optionButton2 = UIButton()
    private var notification = false

    // 최초 스크롤 플래그
    var initialScrollDone = false
    var expandedCells: [IndexPath: Bool] = [:]
    var isCollab = false
    var collab: CollabDto?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        if collab?.id == User.shared.id {
            let moreButtonItem = UIBarButtonItem(image: UIImage(named: "icon_more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(moreButtonTapped))
            moreButtonItem.tintColor = .black // 원하는 색상으로 설정
            navigationItem.rightBarButtonItem = moreButtonItem
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        self.navigationItem.title = "Collab"

        setupBackButton()
        setView()

        setContainView()
        updateNotificationButton()

        self.requestButton.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(-20)
        }
        self.view.layoutIfNeeded()
    }

    @objc private func moreButtonTapped() {
        containerView.isHidden = !containerView.isHidden
    }

    private func setView() {
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        view.addSubview(tableView)

        // 테이블 뷰의 데이터 소스와 델리게이트를 설정
        tableView.dataSource = self
        tableView.delegate = self

        // 셀 등록
        tableView.register(CollabDetailTableViewCell.self, forCellReuseIdentifier: "DetailCell")
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview() // 이 부분이 추가됩니다.
        }

        view.addSubview(requestButton)
        requestButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().offset(-20)
        }

        if collab?.isCollabed == true || isCollab == true {
            requestButton.isEnabled = false
            requestButton.setTitle("collab_detail_button".localized, for: .normal)
            requestButton.backgroundColor = .lightGray
        } else if collab?.application_state == 2 {
            requestButton.setTitle("collab_detail_button2".localized, for: .normal)
            requestButton.addTarget(self, action: #selector(buttonTapped2), for: .touchUpInside)
        } else {
            requestButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }

        // 날짜 형식 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        // 신청 버튼 활성화
        if let startDateString = collab?.start_date, let startDate = dateFormatter.date(from: startDateString) {
            // 현재 날짜 가져오기
            let currentDate = Date()
            if currentDate < startDate {
                requestButton.isHidden = true
            } else if collab?.state == false {
                requestButton.isHidden = true
            } else {
                requestButton.isHidden = false
            }
        }

        if User.shared.auth ?? 0 > 1 {
            requestButton.isHidden = true
        }

    }

    @objc private func buttonTapped() {
        let vc = RequestCollabVC()
        vc.delegate = self
        vc.collab_no = collab?.no ?? 0
        if collab?.tiktok == true {
            vc.tags.append("TikTok")
        }

        if collab?.instagram == true {
            vc.tags.append("Instagram")
        }

        if collab?.facebook == true {
            vc.tags.append("Facebook")
        }

        if collab?.shopee == true {
            vc.tags.append("Shopee")
        }

        print(vc.tags.count)
        self.navigationController?.pushViewController(vc, animated: false)
    }

    @objc private func buttonTapped2() {
        let vc = ReviewWriteVC()
        vc.collab_no = collab?.no ?? 0
        if collab?.tiktok == true {
            vc.tags.append("TikTok")
        }

        if collab?.instagram == true {
            vc.tags.append("Instagram")
        }

        if collab?.facebook == true {
            vc.tags.append("Facebook")
        }

        if collab?.shopee == true {
            vc.tags.append("Shopee")
        }

        self.navigationController?.pushViewController(vc, animated: false)
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

    // 삭제
    @objc private func deleteButtonTapped() {
        // DeleteAlertVC 인스턴스 생성
        let alertVC = DeleteAlertVC()

        // onSuccess 콜백 설정
        alertVC.onSuccess = {
            self.performDeleteAction()
        }

        // onCancel 콜백 설정
        alertVC.onCancel = {
            print("Delete action cancelled")
        }

        // alertVC를 모달로 표시
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true, completion: nil)

    }

    private func performDeleteAction() {
        guard let no = collab?.no else { return }
        let url = "\(Bundle.main.TEST_URL)/snap/del/\(no)" // 실제 요청할 서버의 URL로 변경해주세요.

        AF.request(url, method: .delete).response { response in
            switch response.result {
            case .success:
                self.log(message: "Delete Success")
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.log(message: "Delete Fail : \(error)")
            }
        }
    }

    // 수정
    @objc private func modifyButtonTapped() {
        let vc = CollabModifyVC()
        vc.collab = collab
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // 상단고정
    @objc private func notificationButtonTapped() {
        guard let no = collab?.no else { return }
        let url = "\(Bundle.main.TEST_URL)/snap/update/notification/\(no)" // 실제 요청할 서버의 URL로 변경해주세요.
        AF.request(url, method: .put).response { response in
            switch response.result {
            case .success:
                self.log(message: "Success to Update Notification")
                self.containerView.isHidden = !self.containerView.isHidden
                self.notification = !self.notification

                self.updateNotificationButton()
            case .failure(let error):
                self.log(message: "Fail to Update Notification : \(error)")
            }
        }
    }

    private func updateNotificationButton() {
        notification = collab?.notification ?? false
        if notification {
            optionButton.setTitle("고정 해제", for: .normal)
        } else {
            optionButton.setTitle("상단 고정", for: .normal)
        }
    }
}

extension CollabDetailVC: UITableViewDelegate, UITableViewDataSource, FloatingPanelControllerDelegate, RequestCollabVCDelegate, CollabDetailTableViewCellDelegate {
    func didCopyText(message: String) {
        self.view.showToast(message: message)
    }

    func didCompleteDataTransfer(data: Bool) {

        if data {
            requestButton.isEnabled = false
            requestButton.setTitle("collab_detail_button".localized, for: .normal)
            requestButton.backgroundColor = .lightGray
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let maxContentOffsetY = contentHeight - scrollView.frame.height
        // 최초 스크롤이 아직 수행되지 않았다면 무시
        if !initialScrollDone {
            // 최초 스크롤이 아직 수행되지 않았다면 초기 설정만 실행하고 종료합니다.
            initialScrollDone = true
            return
        }

        if contentOffsetY >= maxContentOffsetY {
            // 최대 높이에 도달했을 때 실행할 코드를 여기에 작성합니다.
            UIView.animate(withDuration: 0.3) {
                self.requestButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-80)
                }
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.requestButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-20)
                }
                self.view.layoutIfNeeded()
            }
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }

    // 테이블 뷰 데이터 소스 메서드: 섹션당 행의 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // 테이블 뷰 데이터 소스 메서드: 각 행에 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! CollabDetailTableViewCell
        cell.delegate = self
        if collab != nil {
            cell.setImages((collab?.imageList)!)
            cell.setText(snap: collab!)
        }

        return cell
    }

}
