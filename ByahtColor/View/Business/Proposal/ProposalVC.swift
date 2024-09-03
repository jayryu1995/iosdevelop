//
//  ProposalVC.swift
//  ByahtColor
//
//  Created by jaem on 8/20/24.
//

import UIKit
import SnapKit
import Combine

class ProposalVC: UIViewController {
    
    private let viewModel = BusinessViewModel()
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProposalCell.self)
        tableView.separatorStyle = .none
        return tableView
    }()
    private let label = {
       let label = UILabel()
        label.text = "proposal_label".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
    
    private let count = {
       let label = UILabel()
        label.text = "proposal_count".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.textColor = UIColor(hex: "#4E505B")
        return label
    }()
    
    private let emptyLabel = {
        let label = UILabel()
        label.text = "proposal_empty_label".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#4E505B")
        return label
    }()
    
    private let emptyLabel2 = {
        let label = UILabel()
        label.text = "proposal_empty_label2".localized
        label.numberOfLines = 0
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        label.textColor = UIColor(hex: "#4E505B")
        label.textAlignment = .center
        return label
    }()

    private let emptyButton = {
        let button = UIButton()
        button.setTitle("proposal_empty_button".localized, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.setTitleColor(UIColor(hex: "#4E505B"), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 4
        button.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupBindings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupBindings()
    }

    private func setupUI() {
        navigationItem.title = "Proposal"
        view.addSubview(label)
        view.addSubview(tableView)
        
    }
    
    private func setupBindings() {
        viewModel.getProposalProfile()
        
        // Binding for proposalList
        viewModel.$proposalList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.label.text = "\("proposal_label".localized) \(self?.viewModel.proposalList.count.toString() ?? "") \(self?.count.text ?? "")"
                
                if self?.viewModel.proposalList.count ?? 0 < 1 {
                    self?.setupEmptyView()
                }else{
                    self?.tableView.reloadData()
                }
            }
            .store(in: &viewModel.cancellables)
        
        // Binding for error
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    print("에러", error)
                }
            }
            .store(in: &viewModel.cancellables)
    }

    private func setupEmptyView(){
        view.addSubview(emptyLabel)
        view.addSubview(emptyLabel2)
        view.addSubview(emptyButton)
        
        emptyButton.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        
        emptyButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(58)
            $0.centerY.equalToSuperview()
        }
        
        emptyLabel2.snp.makeConstraints{
            $0.bottom.equalTo(emptyButton.snp.top).offset(-24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(68)
        }
        
        emptyLabel.snp.makeConstraints{
            $0.bottom.equalTo(emptyLabel2.snp.top).offset(-24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
    }
    
    @objc private func tappedButton(_ Sender: UIButton){
        let vc = BusinessProfileWriteVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(16)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
}

extension ProposalVC: UITableViewDelegate, UITableViewDataSource,ProposalCellDelegate {
    
    
    func didTapCell(_ cell: ProposalCell, withNo no: Int) {
        print("didTapCell \(no)")
        let vc = ProposalSwipeVC()
        if viewModel.proposalList.isEmpty == false{
            var list = viewModel.proposalList
            if no < list.count {
                // 인덱스에 해당하는 요소를 제거하고 첫 번째 위치에 삽입
                let element = list.remove(at: no)
                list.insert(element, at: 0)
            }
            vc.profileList = list
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    // 셀 간의 간격 추가
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear // 간격을 표시할 색상 (보통 투명)
        return footerView
    }

    // 테이블 뷰 데이터 소스 메서드: 섹션당 행의 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contentCount = viewModel.proposalList.count / 2
        let floatCount = viewModel.proposalList.count % 2
        
        // floatCount가 0이면 contentCount 반환, 그렇지 않으면 contentCount + 1 반환
        return floatCount == 0 ? contentCount : contentCount + 1
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let widthSize = UIScreen.main.bounds.width/2 - 5
        let cellHeight = (widthSize) * CGFloat(1.3)
        return cellHeight + 4 // 4는 간격넣기위해서
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProposalCell", for: indexPath) as! ProposalCell
        cell.delegate = self
        cell.selectionStyle = .none

        let firstImageIndex = indexPath.row * 2
        let secondImageIndex = firstImageIndex + 1

        var snapsForCell = [InfluenceProfileDto]()

        if firstImageIndex < viewModel.proposalList.count {
            snapsForCell.append(viewModel.proposalList[firstImageIndex])
        }

        if secondImageIndex < viewModel.proposalList.count {
            snapsForCell.append(viewModel.proposalList[secondImageIndex])
        }

        cell.setupImageViews(list: snapsForCell, row: indexPath.row)

        return cell
    }


}
