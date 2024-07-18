//
//  Admin_CollabVC.swift
//  ByahtColor
//
//  Created by jaem on 4/3/24.
//

import SnapKit
import UIKit
import FloatingPanel
import Alamofire
import AlamofireImage
import FirebaseMessaging
import Combine

class AdminCollabVC: UIViewController, CollabFilterVCDelegate {
    private var viewModel = CollabViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let topView = UIView()
    private let backButton = UIImageView()
    private var tableView = UITableView()
    private let middleView = UIView()
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Collaboration"
        label.numberOfLines = 0
        label.font = UIFont(name: "Pretendard-ExtraBold", size: 24)
        return label
    }()

    private let uploadButton2: UIButton = {
        let button = UIButton()
        button.setTitle("등록하기", for: .normal)
        button.setImage(UIImage(named: "icon_hands"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 3)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: -3)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.backgroundColor = .black
        button.layer.cornerRadius = 19
        button.alpha = 0.7
        return button
    }()

    private let hotButton: UIButton = {
        let button = UIButton()
        button.setTitle("Mới nhất", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        return button
    }()

    private let newButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sắp hết hạn", for: .normal)
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

    private let imageLabel: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo2")
        image.contentMode = .scaleAspectFit
        return image
    }()
    private var loadingIndicator: UIActivityIndicatorView?
    private var filter: [String] = []
    private var filter2: [String] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        clearAndReloadTableView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 화면 이동 이전에 네비게이션 바를 다시 표시
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        Messaging.messaging().subscribe(toTopic: "abcd") { _ in
            print("Subscribed to weather topic")
        }

        view.backgroundColor = .white
        setupLoadingIndicator()
        setTopView()
        setMiddleView()
        setupButton()
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
        view.bringSubviewToFront(uploadButton2)
    }

    private func setMiddleView() {
        view.addSubview(middleView)
        middleView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
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

    private func setTopView() {
        view.addSubview(topView)
        topView.addSubview(topLabel)
        topView.addSubview(imageLabel)

        imageLabel.frame = CGRect(x: 10, y: 5, width: 60, height: 30)
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(102)
        }

        imageLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }

        topLabel.snp.makeConstraints { make in
            make.top.equalTo(imageLabel.snp.bottom).offset(10)
            make.bottom.leading.equalToSuperview()
            make.trailing.equalToSuperview().dividedBy(2)
        }
    }

    private func setupButton() {
        uploadButton2.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(uploadButton2)

        uploadButton2.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
            make.width.equalToSuperview().inset(40).dividedBy(2)
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
        showFloatingPanel()
    }

    // 필터
    private func showFloatingPanel() {
        let fpc = FloatingPanelController()
        fpc.delegate = self

        let contentVC = CollabFilterVC() // 패널에 표시할 컨텐츠 뷰 컨트롤러
        contentVC.delegate = self
        fpc.set(contentViewController: contentVC)
        fpc.layout = CustomFloatingPanel()
        fpc.move(to: .half, animated: true) // 패널을 반 정도의 높이로 이동
        fpc.isRemovalInteractionEnabled = true
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

extension AdminCollabVC: UITableViewDataSource, UITableViewDelegate, FloatingPanelControllerDelegate,
                    CollabTableViewCellDelegate {

    func didTapCell(_ cell: CollabTableViewCell, withNo no: Int) {
        // no 값을 사용하여 해당 페이지를 전환
        let detailVC = AdminCollabReadVC()

        if let selectedSnap = viewModel.collabList.first(where: { $0.no == no }) {
            detailVC.snapList.append(selectedSnap)
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y

        // 스크롤이 아래로 내려갈 때와 위로 올라갈 때 topView의 높이를 조정합니다.
        if yOffset > 0 {
            self.imageLabel.isHidden = true
            // yOffset이 0보다 클 때, 즉 사용자가 아래로 스크롤할 때 topView를 숨깁니다.
            if topView.frame.height > 0 { // topView가 이미 숨겨진 상태가 아니라면
                UIView.animate(withDuration: 0.3, animations: {
                    // topView의 높이를 0으로 조정하여 숨깁니다.
                    self.topView.snp.updateConstraints { make in
                        make.height.equalTo(0)
                    }
                    self.view.layoutIfNeeded() // 이 변경사항을 즉시 반영합니다.
                })
            }
        } else {
            // yOffset이 0보다 작거나 같을 때, 즉 사용자가 위로 스크롤할 때 topView를 다시 보여줍니다.
            if topView.frame.height < 102 { // topView가 이미 전체 높이로 표시된 상태가 아니라면
                UIView.animate(withDuration: 0.3, animations: {
                    // topView의 높이를 원래 높이(예: 102)로 조정합니다.
                    self.topView.snp.updateConstraints { make in
                        make.height.equalTo(102)
                    }
                    self.imageLabel.isHidden = false
                    self.view.layoutIfNeeded() // 이 변경사항을 즉시 반영합니다.
                })
            }
        }
    }

    // 테이블 뷰 데이터 소스 메서드: 섹션당 행의 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contentCount = viewModel.collabList.count / 2
        return contentCount + 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let widthSize = UIScreen.main.bounds.width / 2 - 5
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
        if state == FloatingPanelState.tip {
            fpc.removePanelFromParent(animated: true)
        }
    }

    func floatingPanel(_ fpc: FloatingPanelController, didTapBackdrop backdropView: UIView) {
        // 패널 제거
        fpc.removePanelFromParent(animated: true)
    }
}
