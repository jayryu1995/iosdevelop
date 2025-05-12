//
//  ChatsListVC.swift
//  ByahtColor
//
//  Created by jaem on 7/23/24.
//

import UIKit
import SendbirdChatSDK
import SnapKit
class ChatsListVC: UIViewController {

    private lazy var tableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GroupChannelListCell.self)
        tableView.separatorStyle = .none
        return tableView
    }()
    private let emptyImage = {
        let view = UIImageView(image:UIImage(named: "icon_box"))
        return view
    }()
    private let backgroundView = UIView()
    private let emptyLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "현재 진행중인 채팅이 없습니다."
        lbl.textColor = .gray
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        lbl.numberOfLines = 0
        return lbl
    }()
    private lazy var useCase: GroupChannelListUseCase = {
        let useCase = GroupChannelListUseCase()
        useCase.delegate = self
        return useCase
    }()
    private lazy var timestampStorage = TimestampStorage()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chats"
        
        setupUI()
        setupConstraints()
        useCase.reloadChannels()
    }

    private func setupUI() {
        view.addSubview(tableView)
        
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateEmptyState() {
        backgroundView.addSubview(emptyImage)
        backgroundView.addSubview(emptyLabel)
        tableView.backgroundView = useCase.channels.isEmpty ? backgroundView : nil
        
        emptyImage.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.width.height.equalTo(88)
        }
        
        emptyLabel.snp.makeConstraints{
            $0.top.equalTo(emptyImage.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
    }
}

// MARK: - UITableViewDataSource

extension ChatsListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        useCase.channels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GroupChannelListCell = tableView.dequeueReusableCell(for: indexPath)
        let channel = useCase.channels[indexPath.row]
        cell.configure(with: channel)

        return cell
    }

}

// MARK: - UITableViewDelegate

extension ChatsListVC: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let cell = tableView.cellForRow(at: indexPath) as? GroupChannelListCell {
                // 셀의 nameLabel에서 텍스트 가져오기
                let name = cell.name

                // 데이터 모델에서 channel 가져오기
                let channel = useCase.channels[indexPath.row]

                // 채널 뷰 컨트롤러 생성
                let channelViewController = ChatsVC(channel: channel, timestampStorage: timestampStorage)
                channelViewController.hidesBottomBarWhenPushed = true
                channelViewController.name = name

                // 뷰 컨트롤러 푸시
                navigationController?.pushViewController(channelViewController, animated: true)
            }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let leaveAction = UIContextualAction(style: .destructive, title: "Leave") { [weak self] _, _, completion in
            guard let self = self else { return }

            let channel = self.useCase.channels[indexPath.row]

            self.useCase.leaveChannel(channel) { result in
                switch result {
                case .success:
                    completion(true)
                case .failure:
                    completion(false)
                }
            }
        }

        return UISwipeActionsConfiguration(actions: [leaveAction])
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            useCase.loadNextPage()
        }
    }

}
// MARK: - GroupChannelListUseCaseDelegate

extension ChatsListVC: GroupChannelListUseCaseDelegate {

   func groupChannelListUseCase(_ groupChannelListUseCase: GroupChannelListUseCase, didReceiveError error: SBError) {
        DispatchQueue.main.async { [weak self] in
            self?.presentAlert(error: error)
        }
   }

   func groupChannelListUseCase(_ groupChannelListUseCase: GroupChannelListUseCase, didUpdateChannels: [GroupChannel]) {
       DispatchQueue.main.async { [weak self] in
           self?.tableView.reloadData()
           self?.updateEmptyState()
       }
   }

}
