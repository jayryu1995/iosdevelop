//
//  MagazineView2.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/17.
//

import UIKit
import SnapKit
import Alamofire
import FloatingPanel

class MagazineView: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // 데이터 소스: 매거진 목록
    var magazineList: [MagazineList] = []

    // 테이블 뷰 생성
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        return tableView
    }()
    var expandedCells: [IndexPath: Bool] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        findAllMagazine()

    }

    private func setView() {
        // 테이블 뷰를 뷰 컨트롤러의 서브뷰로 추가

        tableView.separatorStyle = .none
        view.addSubview(tableView)

        // 테이블 뷰의 데이터 소스와 델리게이트를 설정
        tableView.dataSource = self
        tableView.delegate = self

        // 셀 등록
        tableView.register(MagazineTableViewCell.self, forCellReuseIdentifier: "customCell")
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }

    func showFloatingPanel(no: Int) {
        let fpc = FloatingPanelController()
        fpc.delegate = self

        let contentVC = CommentVC() // 패널에 표시할 컨텐츠 뷰 컨트롤러
        contentVC.contentNo = no
        fpc.set(contentViewController: contentVC)
        fpc.layout = CustomFloatingPanel()
        fpc.move(to: .full, animated: true) // 패널을 반 정도의 높이로 이동
        fpc.addPanel(toParent: self)
    }

}
extension MagazineView: FloatingPanelControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    func floatingPanelWillBeginAttracting(_ fpc: FloatingPanelController, to state: FloatingPanelState) {

        if state == FloatingPanelState.tip {
            fpc.removePanelFromParent(animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let magazine = magazineList[indexPath.row]

        // 가로는 view.frame.width - 20으로 설정
        var cellHeight = view.frame.width + 120

        // 라벨의 높이를 계산하여 적용

        if let isExpanded = expandedCells[indexPath], isExpanded {
            // 라벨의 전체 높이 계산
            let labelFullHeight = calculateLabelHeight(text: magazine.content, font: UIFont(name: "Pretendard-Regular", size: 14)!, width: tableView.frame.width - 20)
            cellHeight += labelFullHeight
        } else {
            // 라벨의 축소된 높이 계산 (예: 2줄만 표시)
            let labelCollapsedHeight = calculateLabelHeight(text: magazine.content, font: UIFont(name: "Pretendard-Regular", size: 14)!, width: tableView.frame.width - 20, maxLines: 2)
            cellHeight += labelCollapsedHeight
        }

        return cellHeight
    }

    // 테이블 뷰 데이터 소스 메서드: 섹션당 행의 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return magazineList.count
    }

    // 테이블 뷰 데이터 소스 메서드: 각 행에 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MagazineTableViewCell

        let magazine = magazineList[indexPath.row]
        cell.setImages(magazine.imageList!)

        cell.setText(magazine: magazine)

        cell.onButton2Tapped = { [weak self] in
            self?.showFloatingPanel(no: magazine.no)
        }
        cell.moreButtonTapped = { [weak self] in
            guard let strongSelf = self else { return }

            // 셀 확장/축소 상태 변경
            if let isExpanded = strongSelf.expandedCells[indexPath] {
                strongSelf.expandedCells[indexPath] = !isExpanded
            } else {
                strongSelf.expandedCells[indexPath] = true
            }

            // 셀 높이 재계산을 위한 테이블 뷰 업데이트
            tableView.beginUpdates()
            tableView.endUpdates()

            // 선택적: 특정 셀로 스크롤
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }

        return cell
    }

    // 라벨의 높이를 계산하는 함수
    func calculateLabelHeight(text: String, font: UIFont, width: CGFloat, maxLines: Int = 0) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = maxLines
        label.font = font
        label.text = text
        label.frame = CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude)
        label.sizeToFit()
        return label.frame.height
    }

    private func expandCell(at indexPath: IndexPath) {
        // 높이 변경 로직을 여기에 구현
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    private func findAllMagazine() {
        let url = "\(Bundle.main.TEST_URL)/magazine/all"

        // 요청에 필요한 파라미터 설정
        let parameters: [String: Any] = ["user_id": User.shared.id ?? ""]

        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [MagazineList].self) { [weak self] response in
            guard let self = self else { return }

            switch response.result {
            case .success(let magazineList):
                // 성공적으로 데이터를 받아왔을 때
                self.magazineList.removeAll()
                self.magazineList = magazineList

                DispatchQueue.main.async {
                    self.setView()
                }

            case .failure(let error):
                // 요청 실패 또는 디코딩 실패
                print("Error magazineList: \(error)")

            }
        }

    }
}
