//
//  ApplicationStateVC.swift
//  ByahtColor
//
//  Created by jaem on 3/28/24.
//

import Foundation
import Alamofire
import UIKit
import SnapKit
import FBSDKLoginKit
import FBSDKCoreKit

class ApplicationStateVC: UIViewController {

    private let tab1: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        button.titleLabel?.numberOfLines = 1
        button.setTitle("tab1_title".localized, for: .normal)
        button.setBackgroundColor(.white, for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private let tab2: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        button.titleLabel?.numberOfLines = 1
        button.setTitle("tab2_title".localized, for: .normal)
        button.setBackgroundColor(.white, for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private let tab3: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        button.titleLabel?.numberOfLines = 1
        button.setTitle("tab3_title".localized, for: .normal)
        button.setBackgroundColor(.white, for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private let tab4: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        button.titleLabel?.numberOfLines = 1
        button.setTitle("tab4_title".localized, for: .normal)
        button.setBackgroundColor(.white, for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private let miniTab1: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        button.titleLabel?.numberOfLines = 1
        button.setTitle("miniTab1_title".localized, for: .normal)
        button.setBackgroundColor(.black, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        return button
    }()

    private let miniTab2: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        button.titleLabel?.numberOfLines = 1
        button.setTitle("miniTab2_title".localized, for: .normal)
        button.setBackgroundColor(UIColor(hex: "#F7F7F7"), for: .normal)
        button.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        button.clipsToBounds = true
        return button
    }()

    private let miniTabsStackView: UIStackView = {
        let stackView = UIStackView()
        // StackView 설정
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()

    private var indicator: UIView = {
        let view = UIView()
        view.backgroundColor = .black // 검정색 선으로 설정
        return view
    }()

    private var selectedMiniTab: UIButton? {
        didSet {
            updateMiniTabAppearance()
        }
    }

    private let emptyDataView: UILabel = {
        let view = UILabel()
        view.text = "empty_data_view".localized
        view.textColor = .black
        view.textAlignment = .center
        view.font = UIFont(name: "Pretendard-Regular", size: 16)
        return view
    }()
    private var selectedMiniTabIndex: Int = 1
    private var stackView = UIStackView()
    private var tableView = UITableView()
    private var snapList: [CollabDto] = []
    private var selectedTab = 0

    override func viewWillAppear(_ animated: Bool) {
        clearAndReloadTableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "application_state_title".localized
        setupBackButton()
        setTabButtons()
        setupIndicator()
        // 초기 선택된 탭 설정
        updateIndicatorPosition(index: 1)
        setMiniTap()
        clearAndReloadTableView()
        setupEmptyView()
    }

    private func setupEmptyView() {
        view.addSubview(emptyDataView)
        emptyDataView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func clearAndReloadTableView() {
        snapList.removeAll()
        // 기존 테이블 뷰를 제거
        tableView.removeFromSuperview()

        // 새 테이블 뷰 생성 및 설정
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CollabTableViewCell2.self, forCellReuseIdentifier: "CollabTableViewCell2")
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        // 새 테이블 뷰의 제약 조건 설정
        tableView.snp.makeConstraints { make in
            make.top.equalTo(miniTabsStackView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }

        // 데이터 다시 로드
        loadData(tab: selectedTab)

    }

    @objc private func miniTabTapped(_ sender: UIButton) {
        selectedMiniTabIndex = sender.tag
        selectedMiniTab = sender
        clearAndReloadTableView()

    }

    private func setMiniTap() {
        // miniTabsStackView에 miniTab1, miniTab2 추가
        miniTabsStackView.addArrangedSubview(miniTab1)
        miniTabsStackView.addArrangedSubview(miniTab2)

        [miniTab1, miniTab2].enumerated().forEach { index, button in
            button.tag = index + 1 // 각 버튼에 태그 할당
                   button.addTarget(self, action: #selector(miniTabTapped(_:)), for: .touchUpInside)
                   button.titleEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
                   button.layer.cornerRadius = 16
                   button.contentHorizontalAlignment = .center // 텍스트 중앙 정렬
                   button.titleLabel?.lineBreakMode = .byClipping
            let title = button.titleLabel?.text
            let buttonWidth: CGFloat = max(48, (title! as NSString).size(withAttributes: [.font: UIFont(name: "Pretendard-Regular", size: 12)!]).width + 16) // 16 for padding
                   button.snp.makeConstraints { make in
                       make.height.equalTo(32)
                       make.width.greaterThanOrEqualTo(buttonWidth) // 최소 너비를 50으로 설정
                   }
//            button.tag = index + 1 // 각 버튼에 태그 할당
//            button.addTarget(self, action: #selector(miniTabTapped(_:)), for: .touchUpInside)
//            button.titleEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
//            button.layer.cornerRadius = 16
//            button.contentHorizontalAlignment = .center // 텍스트 중앙 정렬
//            button.titleLabel?.lineBreakMode = .byClipping
//            button.snp.makeConstraints { make in
//                make.width.greaterThanOrEqualTo(50)
//                make.height.equalTo(32)
//            }
        }
        view.addSubview(miniTabsStackView)
        miniTabsStackView.snp.makeConstraints { make in
            // miniTabsStackView의 제약 조건 설정
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(32) // 높이 설정
        }

        miniTabsStackView.isHidden = true // 초기에는 숨김
    }

    private func setTabButtons() {
        stackView = UIStackView(arrangedSubviews: [tab1, tab2, tab3, tab4])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually // 모든 탭이 동일한 너비를 가지도록 설정
        stackView.alignment = .fill // 모든 탭이 스택뷰를 꽉 채우도록 설정
        stackView.spacing = 0 // 탭 사이의 간격 설정

        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(32)
        }

        // 각 탭 버튼에 대한 클릭 리스너 설정
        [tab1, tab2, tab3, tab4].enumerated().forEach { index, button in
            button.tag = index + 1 // 각 버튼에 태그 할당
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        }

    }

    private func setupIndicator() {
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.height.equalTo(2) // 선의 높이는 2
            make.bottom.equalTo(tab1.snp.bottom) // 탭1의 하단에 위치
            make.width.equalTo(tab1.snp.width) // 탭1의 너비와 동일하게 설정
            make.centerX.equalTo(tab1.snp.centerX) // 탭1의 중앙에 위치
        }
    }

    @objc private func tabButtonTapped(_ sender: UIButton) {
        updateIndicatorPosition(index: sender.tag)
        selectedTab = sender.tag
        if selectedTab == 2 { // tab2가 선택되었을 경우
            miniTabsStackView.isHidden = false // miniTabsStackView 보이게 설정
            miniTabsStackView.snp.updateConstraints {
                $0.height.equalTo(34)
            }
        } else {
            miniTabsStackView.isHidden = true // 그 외의 경우 숨김
            miniTabsStackView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
        }
        clearAndReloadTableView()
    }

    private func updateIndicatorPosition(index: Int) {
        print("index : \(index)")
        guard let targetButton = self.view.viewWithTag(index) as? UIButton else {
            print("Error: No button found with the given tag.")
            return
        }
        self.indicator.snp.remakeConstraints { make in
            make.height.equalTo(2)
            make.bottom.equalTo(targetButton.snp.bottom)
            make.width.equalTo(targetButton.snp.width)
            make.centerX.equalTo(targetButton.snp.centerX)
        }
        self.view.layoutIfNeeded() // 애니메이션으로 위치 업데이트
    }

    private func updateMiniTabAppearance() {
        let normalBackgroundColor = UIColor(hex: "#F7F7F7")
        let normalTitleColor = UIColor(hex: "#535358")
        let selectedBackgroundColor = UIColor.black
        let selectedTitleColor = UIColor.white

        [miniTab1, miniTab2].forEach { button in
            if button == selectedMiniTab {
                button.setBackgroundColor(selectedBackgroundColor, for: .normal)
                button.setTitleColor(selectedTitleColor, for: .normal)
            } else {
                button.setBackgroundColor(normalBackgroundColor, for: .normal)
                button.setTitleColor(normalTitleColor, for: .normal)
            }
        }
    }
}

extension ApplicationStateVC: CollabTableViewCell2Delegate, UITableViewDelegate, UITableViewDataSource {
    func didTapButtonInCell(_ cell: CollabTableViewCell2, withNo no: Int) {
        let vc = ReviewWriteVC()
        vc.collab_no = no
        if let selectedSnap = snapList.first(where: { $0.no == no }) {
            let collab = selectedSnap
            if collab.tiktok == true {
                vc.tags.append("TikTok")
            }

            if collab.instagram == true {
                vc.tags.append("Instagram")
            }

            if collab.facebook == true {
                vc.tags.append("Facebook")
            }

            if collab.shopee == true {
                vc.tags.append("Shopee")
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    func didTapCell(_ cell: CollabTableViewCell2, withNo no: Int) {
        // no 값을 사용하여 해당 페이지를 전환
        let detailVC = CollabDetailVC()
        if let selectedSnap = snapList.first(where: { $0.no == no }) {
            detailVC.collab = selectedSnap
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contentCount = snapList.count / 2
        return contentCount+1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let widthSize = UIScreen.main.bounds.width/2 - 5
        let cellHeight = (widthSize) * 1.3
        return cellHeight + 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀을 재사용 큐에서 가져옴
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollabTableViewCell2", for: indexPath) as! CollabTableViewCell2
        cell.selectionStyle = .none
        cell.delegate = self

        // 각 셀에 할당할 이미지 인덱스를 계산
        let firstImageIndex = indexPath.row * 2
        let secondImageIndex = firstImageIndex + 1

        // 셀에 할당할 이미지 배열 초기화
        var snapsForCell = [CollabDto]()
        do {
            // 첫 번째 Snap 추가
            if firstImageIndex < snapList.count {
                let firstData = snapList[firstImageIndex]
                snapsForCell.append(firstData)

            }
        } catch let error as NSError {
            // 예외 처리 코드
            print("An exception occurred: \(error.localizedDescription)")
        }

        do {
            // 두 번째 Snap 추가
            if secondImageIndex < snapList.count {
                let secondData = snapList[secondImageIndex]
                snapsForCell.append(secondData)
            }
        } catch let error as NSError {
            print("An exception occurred: \(error.localizedDescription)")
        }

        // 셀의 이미지 뷰 설정 함수 호출
        cell.setupImageViews(list: snapsForCell)

        return cell
    }

    @objc private func buttonTapped() {
        let vc = ReviewWriteVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }

    private func loadData(tab: Int) {
        let state: Int
        if tab == 1 {
            state = 0
        } else if tab == 2 {
            state = (selectedMiniTabIndex == 1) ? 2 : 1
        } else {
            state = tab
        }
        let url = "\(Bundle.main.TEST_URL)/mypage/snap/select"
        // 요청에 필요한 파라미터 설정
        let parameters = CollabRequestDTO(user_id: User.shared.id ?? "", styles: nil, sns: nil, nation: nil)
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: [CollabDto].self) { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let collabList):
                    let filteredList = collabList.filter { $0.application_state == state }
                    self.snapList = filteredList

                    if self.snapList.isEmpty {
                        // 데이터가 비어있을 경우
                        self.showEmptyDataView(show: true)
                    } else {
                        // 데이터가 존재할 경우
                        self.showEmptyDataView(show: false)
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Error snapList: \(error)")
                    self.showEmptyDataView(show: true)
                }
            }
        }
    }

    private func showEmptyDataView(show: Bool) {
        if show {
            // 데이터가 없을 때 표시될 뷰를 보여줌
            self.emptyDataView.isHidden = false
            self.tableView.isHidden = true
        } else {
            // 데이터가 있을 때는 숨김
            self.emptyDataView.isHidden = true
            self.tableView.isHidden = false
        }
    }
}
