//
//  LikeSnapVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/24.
//

import UIKit
import SnapKit
import Alamofire

class LikeSnapVC: UIViewController {

    private var snapList: [CollabDto] = []
    private var tableView = UITableView()
    private let styleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Style", for: .normal)
        button.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        button.backgroundColor = UIColor(hex: "#F7F7F7")
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        return button
    }()
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
        return button
    }()

    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Tìm thêm ảnh chụp nhanh", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.backgroundColor = .black
        button.setImage(UIImage(named: "icon_search"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 4
        return button
    }()

    private let info_label: UILabel = {
        let label = UILabel()
        label.text = "Bạn chưa thích SNAP nào hết\nLượn một vòng SNAP tìm phong cách của bạn nào?"
        label.numberOfLines = 2
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = UIColor(hex: "#535358")
        label.textAlignment = .center
        return label
    }()

    var isEditMode = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        snapList.removeAll()
        clearAndReloadTableView()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        getLikedSnapsByUserId(userId: User.shared.id ?? "")
        setupTopView()
        setTableView()
    }

    private func updateUI() {

        // UI 업데이트를 메인 스레드에서 수행
        DispatchQueue.main.async {
            if self.snapList.isEmpty {
                self.tableView.isHidden = true
                self.info_label.isHidden = false
            } else {
                self.tableView.isHidden = false
                self.info_label.isHidden = true
            }
            // 여기에서 테이블 뷰 리로드 또는 다른 UI 업데이트 수행
            self.tableView.reloadData()
        }
    }

    private func setupTopView() {
        view.addSubview(styleButton)
        styleButton.isHidden = true

        view.addSubview(editButton)

        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        styleButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.width.equalTo(50)
            $0.height.equalTo(32)
        }

        editButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(50)
            $0.height.equalTo(32)
        }
    }

    private func toggleEditMode() {
        isEditMode.toggle() // 편집 모드를 토글

        // 편집 모드에 따라 테이블 뷰를 업데이트
        tableView.reloadData()

        // 삭제 버튼들의 상태를 업데이트
        updateDeleteButtonsVisibility()
    }

    private func updateDeleteButtonsVisibility() {
        for cell in tableView.visibleCells {
            if let cell = cell as? LikeSnapTableCell {
                for deleteButton in cell.subviews {
                    if let button = deleteButton as? UIButton {
                        button.isHidden = !isEditMode
                    }
                }
            }
        }
    }

    @objc private func editButtonTapped() {
        toggleEditMode()
    }

    private func setTableView() {
        // 테이블 뷰 설정
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LikeSnapTableCell.self, forCellReuseIdentifier: "LikeSnapCell")
        tableView.separatorStyle = .none // 셀 사이 구분선 제거
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(styleButton.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        view.addSubview(info_label)
        info_label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.height.equalTo(40)
        }
    }

    private func getLikedSnapsByUserId(userId: String) {

        let url = "\(Bundle.main.TEST_URL)/like/select"

        // 요청에 필요한 파라미터 설정
        let parameters: [String: Any] = ["user_id": userId]

        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [CollabDto].self) { response in
            switch response.result {
            case .success(let snapVo):
                // 성공적으로 데이터를 받아왔을 때
                self.snapList = snapVo
                print("snapList.count : \(self.snapList.count)")

                self.updateUI()
            case .failure(let error):
                // 요청 실패 또는 디코딩 실패
                print("Error snapList: \(error)")
            }
        }
    }

    @objc private func searchTapped() {
        self.tabBarController?.selectedIndex = 1
    }
}

extension LikeSnapVC: UITableViewDataSource, UITableViewDelegate, LikeSnapTableViewCellDelegate {
    // 테이블 뷰 데이터 소스 메서드: 섹션당 행의 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contentCount = snapList.count / 2
        return contentCount+1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = UIScreen.main.bounds.height * 0.35

        return cellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀을 재사용 큐에서 가져옴
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeSnapCell", for: indexPath) as! LikeSnapTableCell
        cell.selectionStyle = .none
        cell.delegate = self

        // 각 셀에 할당할 이미지 인덱스를 계산
        let firstImageIndex = indexPath.row * 2
        let secondImageIndex = firstImageIndex + 1

        // 셀에 할당할 이미지 배열 초기화
        var snapsForCell = [CollabDto]()

        // 배치를 위해 추가 순서 반대로
        // 첫 번째 Snap 추가
        if firstImageIndex < snapList.count {
            let firstData = snapList[firstImageIndex]
            snapsForCell.append(firstData)
        }
        // 두 번째 Snap 추가
        if secondImageIndex < snapList.count {
            let secondData = snapList[secondImageIndex]
            snapsForCell.append(secondData)
        }

        // 셀의 이미지 뷰 설정 함수 호출
        cell.setupImageViews(list: snapsForCell)

        return cell
    }

    func didTapCell(_ cell: LikeSnapTableCell, withNo no: Int) {
        // no 값을 사용하여 해당 페이지를 전환
        let detailVC = CollabDetailVC()
        print("withNo : \(no)")
        if let selectedSnap = snapList.first(where: { $0.no == no }) {
            detailVC.snapList.append(selectedSnap)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func didTapDeleteButton(forCell cell: LikeSnapTableCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            // 셀의 indexPath를 가져와서 해당 항목을 snapList에서 제거
            let firstImageIndex = indexPath.row * 2
            let secondImageIndex = firstImageIndex + 1

            if firstImageIndex < snapList.count {
                snapList.remove(at: firstImageIndex)
            }

            if secondImageIndex < snapList.count {
                snapList.remove(at: secondImageIndex)
            }

            // 테이블 뷰 리로드하여 업데이트
            tableView.reloadData()
        }
    }

    private func clearAndReloadTableView() {
        // 기존 테이블 뷰를 제거
        snapList.removeAll()
        tableView.removeFromSuperview()

        // 테이블 뷰 설정
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LikeSnapTableCell.self, forCellReuseIdentifier: "LikeSnapCell")
        tableView.separatorStyle = .none // 셀 사이 구분선 제거
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(styleButton.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        let userId = User.shared.id ?? ""
        // 데이터 다시 로드
        getLikedSnapsByUserId(userId: userId)
    }
}
