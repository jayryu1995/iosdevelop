//
//  MySnapVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/25.
//

import Foundation
import Alamofire
import SnapKit
import UIKit

class MySnapVC: UIViewController {

    private var snapList: [CollabDto] = []
    private var tableView = UITableView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        snapList.removeAll()
        clearAndReloadTableView()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

    }

    private func clearAndReloadTableView() {
        // 기존 테이블 뷰를 제거
        snapList.removeAll()
        tableView.removeFromSuperview()

        // 테이블 뷰 설정
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MySnapTableCell.self, forCellReuseIdentifier: "MySnapCell")
        tableView.separatorStyle = .none // 셀 사이 구분선 제거
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 데이터 다시 로드
        loadData()
    }

    private func loadData() {

        let url = "\(Bundle.main.TEST_URL)/mypage/snap/select"

        // 요청에 필요한 파라미터 설정
        let parameters: [String: Any] = ["user_id": User.shared.id ?? ""]

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

    private func updateUI() {
        print("update 실행")
        // UI 업데이트를 메인 스레드에서 수행
        DispatchQueue.main.async {
            // 여기에서 테이블 뷰 리로드 또는 다른 UI 업데이트 수행
            self.tableView.reloadData()
        }
    }

}

extension MySnapVC: UITableViewDataSource, UITableViewDelegate, MySnapTableCellViewCellDelegate {
    // 테이블 뷰 데이터 소스 메서드: 섹션당 행의 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contentCount = snapList.count / 2
        return contentCount+1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSideLength = (UIScreen.main.bounds.width - 60) / 3 // 화면 너비에 따라 이미지 크기 계산
        let imageHeight = imageSideLength * 1.4
        let cellHeight = imageHeight
        return cellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀을 재사용 큐에서 가져옴
        let cell = tableView.dequeueReusableCell(withIdentifier: "MySnapCell", for: indexPath) as! MySnapTableCell
        cell.selectionStyle = .none
        cell.delegate = self

        // 각 셀에 할당할 이미지 인덱스를 계산
        let firstImageIndex = indexPath.row * 3
        let secondImageIndex = firstImageIndex + 1
        let thirdImageIndex = firstImageIndex + 2

        // 셀에 할당할 이미지 배열 초기화
        var snapsForCell = [CollabDto]()

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
        // 세 번째 Snap 추가
        if thirdImageIndex < snapList.count {
            let thirdData = snapList[thirdImageIndex]
            snapsForCell.append(thirdData)
        }

        // 셀의 이미지 뷰 설정 함수 호출
        cell.setupImageViews(list: snapsForCell)

        return cell
    }

    func didTapCell(_ cell: MySnapTableCell, withNo no: Int) {
        // no 값을 사용하여 해당 페이지를 전환
        let detailVC = CollabDetailVC()
        print("withNo : \(no)")
        if let selectedSnap = snapList.first(where: { $0.no == no }) {
            detailVC.snapList.append(selectedSnap)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

}
