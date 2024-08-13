//
//  SnapVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/17.
//

import SnapKit
import UIKit
import FloatingPanel
import Alamofire
import AlamofireImage
import FirebaseMessaging
import Combine

class CollabVC: UIViewController, CollabFilterVCDelegate {
    private var viewModel = CollabViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let viewControllerName = String(describing: type(of: CollabVC.self))
    private var snapList: [CollabDto] = []
    private let backButton = UIImageView()
    private var tableView = UITableView()
    private let middleView = UIView()

    private let hotButton: UIButton = {
        let button = UIButton()
        button.setTitle("collabVC_filter_recent".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        return button
    }()

    private let newButton: UIButton = {
        let button = UIButton()
        button.setTitle("collabVC_filter_deadline".localized, for: .normal)
        button.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor(hex: "#BCBDC0").cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        return button
    }()

    private let filterButton: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "icon_filter"))
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()

    private var loadingIndicator: UIActivityIndicatorView?
    private var filter: [String] = []
    private var filter2: [String] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        clearAndReloadTableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "collab_navigation_title".localized
        setupBackButton()
        view.backgroundColor = .white
        setupLoadingIndicator()
        setMiddleView()
        setupBindings()
    }

    private func setupBindings() {
        viewModel.$collabList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator?.startAnimating()
                } else {
                    self?.loadingIndicator?.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }

    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator?.center = self.view.center
        self.view.addSubview(loadingIndicator!)

        loadingIndicator?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func clearAndReloadTableView(category: Int? = nil) {
        snapList.removeAll()
        // 기존 테이블 뷰를 제거
        tableView.removeFromSuperview()

        // 새 테이블 뷰 생성 및 설정
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CollabTableViewCell.self, forCellReuseIdentifier: "CollabTableViewCell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        // 새 테이블 뷰의 제약 조건 설정
        tableView.snp.makeConstraints { make in
            make.top.equalTo(hotButton.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        var url = ""
        switch category {
        case 0: url = "\(Bundle.main.TEST_URL)/snap/select/new"
        default: url = "\(Bundle.main.TEST_URL)/snap/select"
        }

        // 데이터 다시 로드
        self.view.bringSubviewToFront(loadingIndicator!)
        viewModel.loadData(url: url, userId: User.shared.id ?? "", styles: filter, sns: filter2)

    }

    private func setMiddleView() {

        view.addSubview(middleView)
        middleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(32)
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showFilter))
        filterButton.addGestureRecognizer(tapGestureRecognizer)
        hotButton.addTarget(self, action: #selector(hotButtonTapped), for: .touchUpInside)
        newButton.addTarget(self, action: #selector(newButtonTapped), for: .touchUpInside)

        middleView.addSubview(hotButton)
        middleView.addSubview(newButton)
        middleView.addSubview(filterButton)

        hotButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(75)
            make.height.equalTo(32)
        }

        newButton.snp.makeConstraints { make in
            make.height.centerY.equalTo(hotButton)
            make.leading.equalTo(hotButton.snp.trailing).offset(10)
            make.width.equalTo(95)
        }

        filterButton.snp.makeConstraints { make in
            make.centerY.equalTo(hotButton.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(20)
        }
    }

    @objc func hotButtonTapped() {
        selectButton(hotButton, deselectButton: newButton)
        filter.removeAll()
        clearAndReloadTableView()
    }

    @objc func newButtonTapped() {
        selectButton(newButton, deselectButton: hotButton)
        clearAndReloadTableView(category: 0)
    }

    private func selectButton(_ selectedButton: UIButton, deselectButton: UIButton) {
        // 선택된 버튼 스타일 적용
        selectedButton.setTitleColor(.white, for: .normal)
        selectedButton.backgroundColor = .black
        selectedButton.layer.borderWidth = 0

        // 선택되지 않은 버튼 스타일 적용
        deselectButton.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        deselectButton.backgroundColor = .white
        deselectButton.layer.borderColor = UIColor(hex: "#BCBDC0").cgColor
        deselectButton.layer.borderWidth = 1
    }

    @objc private func showFilter() {
        self.navigationController?.navigationBar.isHidden = false
        showFloatingPanel()
    }

    // 필터
    private func showFloatingPanel() {
        self.navigationController?.navigationBar.isHidden = true
        let fpc = FloatingPanelController()
        fpc.delegate = self

        let contentVC = CollabFilterVC() // 패널에 표시할 컨텐츠 뷰 컨트롤러
        contentVC.delegate = self
        fpc.set(contentViewController: contentVC)
        fpc.layout = CollabFloatingPanel()
        fpc.move(to: .half, animated: true) // 패널을 반 정도의 높이로 이동
        fpc.isRemovalInteractionEnabled = true
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        fpc.surfaceView.appearance.cornerRadius = 20
        fpc.addPanel(toParent: self)
    }

    @objc private func buttonTapped() {
        let vc = CollabWriteVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func didTapButton(_ snapVC: CollabFilterVC, WithArray array: [String], WithArray2 array2: [String]) {
        // 필터 적용 로직
        filter = array
        filter2 = array2
        clearAndReloadTableView()
    }

}

extension CollabVC: UITableViewDataSource, UITableViewDelegate, FloatingPanelControllerDelegate,
                    CollabTableViewCellDelegate {

    func didTapCell(_ cell: CollabTableViewCell, withNo no: Int) {
        // no 값을 사용하여 해당 페이지를 전환
        let detailVC = CollabDetailVC()

        if let selectedSnap = viewModel.collabList.first(where: { $0.no == no }) {
            detailVC.collab = selectedSnap
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    // 테이블 뷰 데이터 소스 메서드: 섹션당 행의 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contentCount = viewModel.collabList.count / 2
        return contentCount+1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let widthSize = UIScreen.main.bounds.width/2 - 5
        let cellHeight = (widthSize) * 1.3
        return cellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀을 재사용 큐에서 가져옴
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollabTableViewCell", for: indexPath) as! CollabTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        // 각 셀에 할당할 이미지 인덱스를 계산
        let firstImageIndex = indexPath.row * 2
        let secondImageIndex = firstImageIndex + 1

        // 셀에 할당할 이미지 배열 초기화
        var snapsForCell = [CollabDto]()
        do {
            // 첫 번째 Snap 추가
            if firstImageIndex < viewModel.collabList.count {
                let firstData = viewModel.collabList[firstImageIndex]
                snapsForCell.append(firstData)

            }
        } catch let error as NSError {
            // 예외 처리 코드
            print("An exception occurred: \(error.localizedDescription)")
        }

        do {
            // 두 번째 Snap 추가
            if secondImageIndex < viewModel.collabList.count {
                let secondData = viewModel.collabList[secondImageIndex]
                snapsForCell.append(secondData)
            }
        } catch let error as NSError {
            print("An exception occurred: \(error.localizedDescription)")
        }

        // 셀의 이미지 뷰 설정 함수 호출
        cell.setupImageViews(list: snapsForCell)

        return cell
    }

    func floatingPanelWillBeginAttracting(_ fpc: FloatingPanelController, to state: FloatingPanelState) {

        if state == FloatingPanelState.half {
            self.navigationController?.navigationBar.isHidden = false
            fpc.removePanelFromParent(animated: true)
        }
    }

    func floatingPanelDidRemove(_ vc: FloatingPanelController) {
        self.navigationController?.navigationBar.isHidden = false
        }

    func floatingPanel(_ fpc: FloatingPanelController, didTapBackdrop backdropView: UIView) {
        // 패널 제거
        self.navigationController?.navigationBar.isHidden = false
        fpc.removePanelFromParent(animated: true)

    }

}
