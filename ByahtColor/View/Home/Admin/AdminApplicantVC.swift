//
//  AdminApplicantVC.swift
//  ByahtColor
//
//  Created by jaem on 4/3/24.
//

import Foundation
import Alamofire
import UIKit
import SnapKit
import FBSDKLoginKit
import FBSDKCoreKit

class AdminApplicantVC: UIViewController {

    private let tab1: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        button.titleLabel?.numberOfLines = 1
        button.setTitle("신청", for: .normal)
        button.setBackgroundColor(.white, for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private let tab2: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        button.titleLabel?.numberOfLines = 1
        button.setTitle("리뷰", for: .normal)
        button.setBackgroundColor(.white, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.isEnabled = false
        return button
    }()

    private let miniTab1: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        button.titleLabel?.numberOfLines = 1
        button.setTitle("미완료", for: .normal)
        button.setBackgroundColor(.black, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        return button
    }()

    private let miniTab2: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        button.titleLabel?.numberOfLines = 1
        button.setTitle("선정", for: .normal)
        button.setBackgroundColor(UIColor(hex: "#F7F7F7"), for: .normal)
        button.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        button.clipsToBounds = true
        return button
    }()

    private let miniTab3: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 12)
        button.titleLabel?.numberOfLines = 1
        button.setTitle("미선정", for: .normal)
        button.setBackgroundColor(UIColor(hex: "#F7F7F7"), for: .normal)
        button.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        button.clipsToBounds = true
        return button
    }()

    private let miniTabsStackView: UIStackView = {
        let stackView = UIStackView()
        // StackView 설정
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
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
        view.text = "Không có event đang tham gia"
        view.textColor = .black
        view.textAlignment = .center
        view.font = UIFont(name: "Pretendard-Regular", size: 16)
        return view
    }()
    private var selectedMiniTabIndex: Int = 0
    private var stackView = UIStackView()
    private var tableView = UITableView()
    private var applicantList: [ApplicantDto] = []
    private var selectedTab = 0
    var collabNo = 0

    override func viewWillAppear(_ animated: Bool) {
        clearAndReloadTableView()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // miniTabsStackView 또는 버튼의 높이를 기반으로 코너 반지름 설정
        [miniTab1, miniTab2, miniTab3].forEach { button in
            button.layer.cornerRadius = button.bounds.height / 2
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "신청자 확인"
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
        applicantList.removeAll()
        // 기존 테이블 뷰를 제거
        tableView.removeFromSuperview()

        // 새 테이블 뷰 생성 및 설정
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AdminApplicantTableCell.self, forCellReuseIdentifier: "AdminApplicantTableCell")
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
        miniTabsStackView.addArrangedSubview(miniTab3)

        [miniTab1, miniTab2, miniTab3].enumerated().forEach { index, button in
            button.tag = index + 1 // 각 버튼에 태그 할당
            button.addTarget(self, action: #selector(miniTabTapped(_:)), for: .touchUpInside)
        }
        view.addSubview(miniTabsStackView)
        miniTabsStackView.snp.makeConstraints { make in
            // miniTabsStackView의 제약 조건 설정
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().dividedBy(2)
            make.height.equalTo(32) // 높이 설정
        }

    }

    private func setTabButtons() {
        stackView = UIStackView(arrangedSubviews: [tab1, tab2])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually // 모든 탭이 동일한 너비를 가지도록 설정
        stackView.alignment = .fill // 모든 탭이 스택뷰를 꽉 채우도록 설정
        stackView.spacing = 0 // 탭 사이의 간격 설정

        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.height.equalTo(32)
        }

        // 각 탭 버튼에 대한 클릭 리스너 설정
        [tab1, tab2].enumerated().forEach { index, button in
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

        clearAndReloadTableView()
    }

    private func updateIndicatorPosition(index: Int) {
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

        [miniTab1, miniTab2, miniTab3].forEach { button in
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

extension AdminApplicantVC: UITableViewDelegate, UITableViewDataSource, AdminApplicantTableCellDelegate {

    func didUpdateApplicantState(cell: AdminApplicantTableCell, applicant: ApplicantDto, state: Int) {
        let no = applicant.no ?? 0
        if applicant.state == 1 || applicant.state == 2 {
            presentAlert(state: state, no: no)
        } else {
            updateState(state: state, no: no)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return applicantList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀을 재사용 큐에서 가져옴
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminApplicantTableCell", for: indexPath) as! AdminApplicantTableCell
        let index = indexPath.row
        cell.selectionStyle = .none
        cell.setData(result: applicantList[index])
        cell.delegate = self
        return cell
    }

    private func loadData(tab: Int) {
        var state: Int?
        switch selectedMiniTabIndex {
        case 2:
            state = 2
        case 3:
            state = 1
        default:
            state = 0
        }

        let url = "\(Bundle.main.TEST_URL)/admin/applicants"
        // 요청에 필요한 파라미터 설정
        let parameters = ApplicantParameter(collab_no: collabNo, state: state)

        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: [ApplicantDto].self) { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let result):
                    let filteredList = result.filter { $0.state == state }
                    self.applicantList = filteredList

                    if self.applicantList.isEmpty {
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

    // alert창
    private func presentAlert(state: Int, no: Int) {
        let alertVC = AdminApplicantAlertVC()
        alertVC.modalPresentationStyle = .overCurrentContext // 현재 뷰 컨트롤러 위에 표시
        alertVC.modalTransitionStyle = .crossDissolve // 부드러운 전환 효과

        alertVC.onSuccess = { [weak self] in
            // 확인 버튼을 탭했을 때 실행할 코드
            self?.updateState(state: state, no: no)
        }

        present(alertVC, animated: false, completion: nil)
    }

    private func updateState(state: Int, no: Int) {
        let url = "\(Bundle.main.TEST_URL)/admin/update/applicants"

        let parameters = ApplicantCellParameter(no: no, state: state)
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseString { response in
            switch response.result {
            case .success(let responseData):
                // 서버 응답 처리
                print("Response Data: \(responseData)")
                self.clearAndReloadTableView()

            case .failure(let error):
                // 오류 처리
                print("Error: \(error)")
            }
        }
    }
}
