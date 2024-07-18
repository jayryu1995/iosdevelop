//
//  DiscountClinicVC.swift
//  ByahtColor
//
//  Created by jaem on 5/13/24.
//

import SnapKit
import UIKit
import FloatingPanel
import Alamofire
import AlamofireImage
import FirebaseMessaging
import Combine

class UserDiscountFashionVC: UIViewController {
    private var viewModel = DiscountViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let viewControllerName = String(describing: type(of: UserDiscountFashionVC.self))
    private var tableView = UITableView()
    private var loadingIndicator: UIActivityIndicatorView?
    private var filter: [String] = []
    private var filter2: [String] = []
    private let middleView = UIView()
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
    var category = 0
    override func viewWillAppear(_ animated: Bool) {

        clearAndReloadTableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupLoadingIndicator()
        setMiddleView()
        clearAndReloadTableView()
        setupBindings()
    }

    private func setMiddleView() {
        view.addSubview(middleView)
        middleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.width.equalToSuperview()
            $0.height.equalTo(32)
        }

        hotButton.addTarget(self, action: #selector(hotButtonTapped), for: .touchUpInside)
        newButton.addTarget(self, action: #selector(newButtonTapped), for: .touchUpInside)

        middleView.addSubview(hotButton)
        middleView.addSubview(newButton)

        hotButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(75)
            make.height.equalTo(32)
        }

        newButton.snp.makeConstraints { make in
            make.height.centerY.equalTo(hotButton)
            make.leading.equalTo(hotButton.snp.trailing).offset(10)
            make.width.equalTo(95)
        }

    }

    private func setupBindings() {
        viewModel.$result
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

    @objc func hotButtonTapped() {
        selectButton(hotButton, deselectButton: newButton)
        filter.removeAll()
        category = 0
        clearAndReloadTableView()

    }

    @objc func newButtonTapped() {
        selectButton(newButton, deselectButton: hotButton)
        category = 1
        clearAndReloadTableView()

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

    private func clearAndReloadTableView() {
        // 기존 테이블 뷰를 제거
        tableView.removeFromSuperview()

        // 새 테이블 뷰 생성 및 설정
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserDiscountTableViewCell.self, forCellReuseIdentifier: "UserDiscountTableViewCell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        // 새 테이블 뷰의 제약 조건 설정
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        var url = ""
        switch category {
        case 1: url = "\(Bundle.main.TEST_URL)/discount/sel2/Fashion"
        default: url = "\(Bundle.main.TEST_URL)/discount/sel/Fashion"
        }

        // 데이터 다시 로드
        view.bringSubviewToFront(loadingIndicator!)
        viewModel.loadData(url: url)

    }

}

extension UserDiscountFashionVC: UITableViewDataSource, UITableViewDelegate,
                            UserDiscountTableViewCellDelegate {

    func didTapCell(_ cell: UserDiscountTableViewCell, withNo no: Int) {
            let detailVC = UserDiscountDetailVC()

        if let selectedSnap = viewModel.result.first(where: { $0.no == no }) {
                detailVC.discount = selectedSnap
                detailVC.hidesBottomBarWhenPushed = true
                self.navigationController?.navigationBar.isHidden = false
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }

    // 테이블 뷰 데이터 소스 메서드: 섹션당 행의 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contentCount = viewModel.result.count / 2
        return contentCount+1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let widthSize = UIScreen.main.bounds.width/2 - 5
        let cellHeight = (widthSize) * 1.3
        return cellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀을 재사용 큐에서 가져옴
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDiscountTableViewCell", for: indexPath) as! UserDiscountTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        // 각 셀에 할당할 이미지 인덱스를 계산
        let firstImageIndex = indexPath.row * 2
        let secondImageIndex = firstImageIndex + 1

        // 셀에 할당할 이미지 배열 초기화
        var snapsForCell = [DiscountDto]()
        do {
            // 첫 번째 Snap 추가
            if firstImageIndex < viewModel.result.count {
                let firstData = viewModel.result[firstImageIndex]
                snapsForCell.append(firstData)

            }
        }

        do {
            // 두 번째 Snap 추가
            if secondImageIndex < viewModel.result.count {
                let secondData = viewModel.result[secondImageIndex]
                snapsForCell.append(secondData)
            }
        }

        // 셀의 이미지 뷰 설정 함수 호출
        cell.setupImageViews(list: snapsForCell)

        return cell
    }

}
