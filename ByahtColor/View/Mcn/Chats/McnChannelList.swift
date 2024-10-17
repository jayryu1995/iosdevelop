//
//  McnChatsVC.swift
//  ByahtColor
//
//  Created by jaem on 9/30/24.
//

import UIKit
import SendbirdChatSDK
import SnapKit
class McnChannelListVC: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(McnChannelListCell.self)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var useCase: GroupChannelListUseCase = {
        let useCase = GroupChannelListUseCase()
        useCase.delegate = self
        return useCase
    }()

    private lazy var viewModel = McnViewModel()
    private lazy var influenceList : [InfluenceProfileDto] = []
    private lazy var timestampStorage = TimestampStorage()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chats"
        useCase.reloadChannels()
        setupUI()
        setupConstraints()
        loadInfluenceData()
    }

    private func setupUI() {
        view.addSubview(tableView)
    }

    private func loadInfluenceData(){
        if let id = User.shared.id{
            viewModel.loadInfluence(id: id){ result in
                switch result{
                case .success(let data):
                    self.influenceList = data
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource

extension McnChannelListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        influenceList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: McnChannelListCell = tableView.dequeueReusableCell(for: indexPath)
        let influence = influenceList[indexPath.row]
        var count = 0
        var unReadMessage = false
        
        useCase.channels.forEach { channel in
            let cachedMetaData = channel.getCachedMetaData()
            let value = cachedMetaData["influence_id"]
            if value == influence.memberId {
                count += 1 // 같다면 count를 1 증가
                let unreadMessageCount = channel.unreadMessageCount
                if channel.unreadMessageCount > 0 {
                    unReadMessage = true
                }
            }
        }
        cell.configure(with: influence, count: count, unReadMessage: unReadMessage)

        return cell
    }

}

// MARK: - UITableViewDelegate

extension McnChannelListVC: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) as? McnChannelListCell {
            // 셀의 nameLabel에서 텍스트 가져오기
            let id = cell.influenceId
            // 채널 뷰 컨트롤러 생성
            let channelViewController = McnChatListVC()
            channelViewController.influenceId = id
        
            // 뷰 컨트롤러 푸시
            navigationController?.pushViewController(channelViewController, animated: true)
            
        }
    }

}
extension McnChannelListVC: GroupChannelListUseCaseDelegate {

   func groupChannelListUseCase(_ groupChannelListUseCase: GroupChannelListUseCase, didReceiveError error: SBError) {
        DispatchQueue.main.async { [weak self] in
            // self?.presentAlert(error: error)
        }
   }

   func groupChannelListUseCase(_ groupChannelListUseCase: GroupChannelListUseCase, didUpdateChannels: [GroupChannel]) {
       DispatchQueue.main.async { [weak self] in
           self?.tableView.reloadData()
       }
   }

}
