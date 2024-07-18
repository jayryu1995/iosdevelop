//
//  LikeFollowVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/24.
//

import UIKit
import Alamofire
import SnapKit

class LikeFollowVC: UIViewController {

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        return tableView
    }()
    private var userList: [UserDto] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupBackButton()
        loadData()
        setTableView()
    }

    private func setTableView() {
        // 테이블 뷰 초기화 및 설정
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FollowTableCell.self, forCellReuseIdentifier: "FollowTableCell")

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func loadData() {
        let url = "\(Bundle.main.TEST_URL)/mypage/follow/select"

        // 요청에 필요한 파라미터 설정
        let parameters: [String: Any] = ["user_id": User.shared.id ?? 0]

        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [UserDto].self) { response in
            switch response.result {
            case .success(let userData):
                // 성공적으로 데이터를 받아왔을 때
                self.userList = userData
                print("snapList.count : \(self.userList.count)")

                self.tableView.reloadData()
            case .failure(let error):
                // 요청 실패 또는 디코딩 실패
                print("Error snapList: \(error)")
            }
        }
    }

}

extension LikeFollowVC: UITableViewDataSource, UITableViewDelegate {
    // 테이블 뷰 데이터 소스 메서드: 섹션당 행의 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return userList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = CGFloat(80)
        return cellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀을 재사용 큐에서 가져옴
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowTableCell", for: indexPath) as! FollowTableCell
        let i = indexPath.row
        let user = userList[i]

        cell.loadSnapData(user: user)
        cell.onButtonTapped = { [weak self] in
            let vc = CollabProfileVC()
            vc.userDto = user
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }

}
