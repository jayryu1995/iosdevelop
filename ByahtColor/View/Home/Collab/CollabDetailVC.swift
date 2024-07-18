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
        button.setTitle("ĐĂNG KÝ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 4
        return button
    }()
    private let containerView = UIView()

    // 최초 스크롤 플래그
    var initialScrollDone = false
    var snapList: [CollabDto] = []
    var expandedCells: [IndexPath: Bool] = [:]
    var isCollab = false
    var collab: CollabDto?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(hex: "#F7F7F7")
        if collab?.id == User.shared.id || User.shared.auth == 1 {
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

        if snapList.first?.isCollabed == true && snapList.first?.application_state != 2 || isCollab == true && snapList.first?.application_state != 2 {
            requestButton.isEnabled = false
            requestButton.setTitle("Tham gia thành công", for: .normal)
            requestButton.backgroundColor = .lightGray
        } else if snapList.first?.application_state == 2 {
            requestButton.setTitle("Gửi đánh giá", for: .normal)
            requestButton.addTarget(self, action: #selector(buttonTapped2), for: .touchUpInside)
        } else {
            requestButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }

        view.addSubview(requestButton)
        requestButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().offset(-20)
        }

        // 날짜 형식 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        // 신청 버튼 활성화
        if let startDateString = snapList.first?.start_date, let startDate = dateFormatter.date(from: startDateString) {
            // 현재 날짜 가져오기
            let currentDate = Date()
            if currentDate < startDate {
                requestButton.isHidden = true
            } else if snapList.first?.state == false {
                requestButton.isHidden = true
            } else {
                requestButton.isHidden = false
            }
        }

    }

    @objc private func buttonTapped() {
        let vc = RequestCollabVC()
        vc.delegate = self
        vc.collab_no = snapList.first?.no ?? 0
        let collab = snapList.first
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

    @objc private func buttonTapped2() {
        let vc = ReviewWriteVC()
        vc.collab_no = snapList.first?.no ?? -1
        let collab = snapList.first
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
        // 옵션 버튼 1 설정
        let optionButton1 = UIButton()
        optionButton1.setTitle("수정", for: .normal)
        optionButton1.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 16)
        optionButton1.backgroundColor = .white
        optionButton1.setTitleColor(.black, for: .normal)
        optionButton1.contentHorizontalAlignment = .left
        optionButton1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        optionButton1.clipsToBounds = true

        // 옵션 버튼 2 설정
        let optionButton2 = UIButton()
        optionButton2.setTitle("삭제", for: .normal)
        optionButton2.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 16)
        optionButton2.backgroundColor = .white
        optionButton2.contentHorizontalAlignment = .left
        optionButton2.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        optionButton2.setTitleColor(.black, for: .normal)
        optionButton2.clipsToBounds = true

        optionButton2.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        optionButton1.addTarget(self, action: #selector(modifyButtonTapped), for: .touchUpInside)

        let line = UIView()
        line.backgroundColor = UIColor(hex: "#F7F7F7")

        // 컨테이너 뷰 설정
        containerView.addSubview(optionButton1)
        containerView.addSubview(optionButton2)
        containerView.addSubview(line)
        containerView.isHidden = true // 초기 상태는 숨김
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(optionButton2.snp.bottom) // 이 부분을 추가
        }

        optionButton1.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(44)
            $0.top.equalToSuperview()
        }

        line.snp.makeConstraints {
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
}

extension CollabDetailVC: UITableViewDelegate, UITableViewDataSource, FloatingPanelControllerDelegate, RequestCollabVCDelegate, CollabDetailTableViewCellDelegate {
    func didCopyText(message: String) {
        self.view.showToast(message: message)
    }

    func didCompleteDataTransfer(data: Bool) {

        if data {
            requestButton.isEnabled = false
            requestButton.setTitle("Tham gia thành công", for: .normal)
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
        return snapList.count
    }

    // 테이블 뷰 데이터 소스 메서드: 각 행에 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! CollabDetailTableViewCell
        let snap = snapList[indexPath.row]
        cell.delegate = self
        cell.setImages(snap.imageList!)
        cell.setText(snap: snap)
//        cell.onDeleteTapped = {
//            let customAlertVC = DeleteAlertVC()
//            customAlertVC.modalPresentationStyle = .overCurrentContext
//            customAlertVC.modalTransitionStyle = .crossDissolve
//            customAlertVC.onSuccess = {
//
//                guard let no = snap.no else { return }
//                let url = "\(Bundle.main.TEST_URL)/snap/del/\(no)" // 실제 요청할 서버의 URL로 변경해주세요.
//
//                AF.request(url, method: .delete).response { response in
//                    switch response.result {
//                    case .success:
//                        self.log(message: "Delete Success")
//                        self.navigationController?.popViewController(animated: true)
//                    case .failure(let error):
//                        self.log(message: "Delete Fail : \(error)")
//                    }
//                }
//            }
//
//            self.present(customAlertVC, animated: true, completion: nil)
//
//        }

        return cell
    }

}
