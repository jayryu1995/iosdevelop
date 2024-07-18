//
//  BusinessProfileVC.swift
//  ByahtColor
//
//  Created by jaem on 6/29/24.
//

import UIKit
import SnapKit
import Combine

class BusinessProfileVC: UIViewController {

    private let tableView = UITableView()
    private let viewModel = BusinessViewModel()
    private var payArray: [Pay] = []
    private var selectedGender: [String] = []
    private var selectedCategory: [String] = []
    private var selectedAge: [String] = []
    private var cancellables = Set<AnyCancellable>()
    private var profileDto: BusinessDetailDto?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let id = User.shared.id else { return }
        viewModel.getBusinessProfile2(id: id)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        setupTableView()
        setupBackButton()
        setupNavigationBar()
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.$businessDetail
            .sink { [weak self] detail in
                guard let self = self, let detail = detail else { return }
                self.navigationItem.title = detail.business_name ?? ""
                self.payArray = detail.payDtos ?? []
                self.profileDto = detail
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ProfileHeaderCell.self, forCellReuseIdentifier: "ProfileHeaderCell")
        tableView.register(PayCell.self, forCellReuseIdentifier: "PayCell")
        tableView.register(TargetCell.self, forCellReuseIdentifier: "TargetCell")
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupNavigationBar() {
        let writeButton = UIBarButtonItem(image: UIImage(named: "icon_write")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(buttonTapped))
        navigationItem.rightBarButtonItem = writeButton
    }

    @objc private func buttonTapped() {
        let vc = BusinessProfileWriteVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: false)
    }

    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension BusinessProfileVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // 섹션 수 (헤더, 페이, 타겟)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // 프로필 헤더
        case 1:
            return 1 // 페이
        case 2:
            return 1 // 타겟
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
            if let data = profileDto {
                cell.selectionStyle = .none
                cell.configure(with: data)
            }
            // 헤더 데이터 설정
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayCell", for: indexPath) as! PayCell
            cell.configure(with: payArray)
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TargetCell", for: indexPath) as! TargetCell
            if let data = profileDto {
                var strArray: [String] = []
                if let category = data.category { strArray.append(category)}
                if let age = data.age { strArray.append(age)}
                if let gender = data.gender { strArray.append(gender)}
                cell.selectionStyle = .none
                cell.configure(with: strArray)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}
