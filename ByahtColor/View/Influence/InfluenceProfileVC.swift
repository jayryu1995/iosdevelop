//
//  InfluenceProfileVC.swift
//  ByahtColor
//
//  Created by jaem on 6/20/24.
//

import UIKit
import Combine
import SnapKit

class InfluenceProfileVC: UIViewController {

    private let tableView = UITableView()
    private let viewModel = InfluenceViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let id = User.shared.id else { return }
        viewModel.getProfile(id: id)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        setupTableView()
        setupBinding()
        setupNavigationBar()
        setupConstraints()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.register(InfluenceProfileCell.self, forCellReuseIdentifier: "InfluenceProfileCell")
        tableView.register(ExperienceCell.self, forCellReuseIdentifier: "ExperienceCell")
        tableView.register(PayCell.self, forCellReuseIdentifier: "PayCell")
        tableView.register(TargetCell.self, forCellReuseIdentifier: "TargetCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupBinding() {
        viewModel.$profileData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupNavigationBar() {
        let writeButton = UIBarButtonItem(image: UIImage(named: "icon_write")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(buttonTapped))
        navigationItem.rightBarButtonItem = writeButton
    }

    @objc private func buttonTapped() {
        let vc = InfluenceProfileWriteVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

extension InfluenceProfileVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 // Header, Experience, Pay, target
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Header section
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "InfluenceProfileCell", for: indexPath) as! InfluenceProfileCell
                if let profileData = viewModel.profileData {
                    cell.selectionStyle = .none
                    cell.configure(with: profileData)
                } else {
                    cell.configure(with: nil) // Configure with nil if data is not available
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceCell", for: indexPath) as! ExperienceCell
                if let profile = viewModel.profileData, let experience = profile.experienceList {
                    cell.selectionStyle = .none
                    cell.configure(with: experience)
                    cell.addTopRadius()
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PayCell", for: indexPath) as! PayCell
                if let pay = viewModel.profileData?.payList {
                    cell.selectionStyle = .none
                    cell.configure(with: pay)
                }
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TargetCell", for: indexPath) as! TargetCell
                if let profile = viewModel.profileData {
                    var strArray: [String] = []
                    if let category = profile.category { strArray.append(category) }
                    if let age = profile.age { strArray.append(age) }
                    if let gender = profile.gender { strArray.append(gender) }

                    cell.selectionStyle = .none
                    cell.configure(with: strArray)
                    cell.addBottomRadius()
                }
                return cell
            default:
                return UITableViewCell()
            }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
