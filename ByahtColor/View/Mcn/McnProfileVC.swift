//
//  McnProfileVC.swift
//  ByahtColor
//
//  Created by jaem on 9/24/24.
//

import Foundation
import UIKit
import SnapKit

class McnProfileVC: UIViewController {
  
    private lazy var topLabel = {
        let label = UILabel()
        label.text = "mcn_profile_topLabel".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
    
    private lazy var topLabel2 = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.textColor = UIColor(hex: "#4E505B")
        return label
    }()
    
    private lazy var tableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(McnInfluenceCell.self)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var registButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_plus"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var emptyLabel = {
        let label = UILabel()
        label.text = "mcn_profile_emptyLabel".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var registButton2 = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundColor(.black, for: .normal)
        button.setTitle("mcn_profile_regist".localized, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.isHidden = true
        button.layer.cornerRadius = 4
        return button
    }()
    
    private lazy var viewModel = McnViewModel()
    private lazy var influenceList : [InfluenceProfileDto] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadInfluenceData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Profile"
        setupUI()
        setupConstraints()
    }
    
    private func loadInfluenceData(){
        if let id = User.shared.id{
            viewModel.loadInfluence(id: id){ result in
                switch result{
                case .success(let data):
                    self.influenceList = data
                    self.setupBindingView()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func setupBindingView(){
        let count = influenceList.count
        if count == 0 {
            emptyLabel.isHidden = false
            registButton2.isHidden = false
        }else{
            emptyLabel.isHidden = true
            registButton2.isHidden = true
        }
        topLabel2.text = "\(count)\("mcn_profile_topLabel2".localized)"
        tableView.reloadData()
    }
    
    private func setupUI(){
        
        view.addSubview(topLabel)
        view.addSubview(topLabel2)
        view.addSubview(tableView)
        view.addSubview(registButton)
        view.addSubview(registButton2)
        view.addSubview(emptyLabel)
        
        registButton.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        registButton2.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
    }
    
    @objc private func tappedButton(){
        let vc = McnInfluencProfileWriteVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func setupConstraints(){
        
        emptyLabel.snp.makeConstraints{
            $0.bottom.equalTo(registButton2.snp.top).offset(-54)
            $0.leading.trailing.equalToSuperview()
        }
        
        registButton2.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.9)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
        
        topLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().inset(20)
        }
        
        topLabel2.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(topLabel.snp.trailing).offset(4)
        }
        
        registButton.snp.makeConstraints{
            $0.centerY.equalTo(topLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(20)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(topLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
    
    
}

extension McnProfileVC: McnInfluenceCellDelegate {
    func didTapCell(_ cell: McnInfluenceCell, withNo no: Int) {
        print("didTapCell \(no)")
        
        let vc = McnInfluenceProfileVC()
        vc.influenceId = influenceList[no].memberId
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension McnProfileVC : UITableViewDelegate{
    // 셀 간의 간격 추가
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear // 간격을 표시할 색상 (보통 투명)
        return footerView
    }
}

extension McnProfileVC : UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contentCount = influenceList.count / 2
        let floatCount = influenceList.count % 2
        
        // floatCount가 0이면 contentCount 반환, 그렇지 않으면 contentCount + 1 반환
        return floatCount == 0 ? contentCount : contentCount + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let widthSize = UIScreen.main.bounds.width/2 - 5
        let cellHeight = (widthSize) * CGFloat(1.3)
        return cellHeight + 4 // 4는 간격넣기위해서
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "McnInfluenceCell", for: indexPath) as! McnInfluenceCell
        cell.delegate = self
        cell.selectionStyle = .none

        let firstImageIndex = indexPath.row * 2
        let secondImageIndex = firstImageIndex + 1

        var snapsForCell = [InfluenceProfileDto]()

        if firstImageIndex < influenceList.count {
            snapsForCell.append(influenceList[firstImageIndex])
        }

        if secondImageIndex < influenceList.count {
            snapsForCell.append(influenceList[secondImageIndex])
        }

        cell.setupImageViews(list: snapsForCell, row: indexPath.row)

        return cell
    }
}
