//
//  ChatsVC.swift
//  ByahtColor
//
//  Created by jaem on 7/23/24.
//

import Foundation
import UIKit
import SendbirdChatSDK
import SnapKit

class ChatsVC: UIViewController {

    private enum Constant {
        static let loadMoreThreshold: CGFloat = 100
    }

    var name: String? = ""

    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.register(BasicMessageCell.self)
        tableView.register(BasicFileCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
        return tableView
    }()

    private lazy var messageInputView: MessageInputView = {
        let messageInputView = MessageInputView()
        messageInputView.delegate = self
        return messageInputView
    }()

    private var messageInputBottomConstraint: Constraint?
    private var messageInputHeightConstraint: Constraint?

    var targetMessageForScrolling: BaseMessage?

    let channel: GroupChannel

    private let timestampStorage: TimestampStorage

    public private(set) lazy var imagePickerRouter: ImagePickerRouter = {
        let imagePickerRouter = ImagePickerRouter(target: self, sourceTypes: [.photoLibrary, .photoCamera, .videoCamera])
        imagePickerRouter.delegate = self
        return imagePickerRouter
    }()

    public private(set) lazy var messageListUseCase: GroupChannelMessageListUseCase = {
        let messageListUseCase = GroupChannelMessageListUseCase(channel: channel, timestampStorage: timestampStorage)
        messageListUseCase.delegate = self
        return messageListUseCase
    }()

    public private(set) lazy var userMessageUseCase = GroupChannelUserMessageUseCase(channel: channel)

    public private(set) lazy var fileMessageUseCase = GroupChannelFileMessageUseCase(channel: channel)

    private lazy var keyboardObserver: KeyboardObserver = {
        let keyboardObserver = KeyboardObserver()
        keyboardObserver.delegate = self
        return keyboardObserver
    }()

    init(channel: GroupChannel, timestampStorage: TimestampStorage) {
        self.channel = channel
        self.timestampStorage = timestampStorage
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupBackButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupBackButton()

        view.addSubview(messageInputView)
        // messageInputBottomConstraint 설정
        messageInputView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            messageInputHeightConstraint = make.height.equalTo(44).constraint
            messageInputBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).constraint
        }
        messageListUseCase.loadInitialMessages()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(10)
            make.bottom.equalTo(messageInputView.snp.top)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)

        // 메시지가 로드된 후 스크롤을 가장 아래로 이동
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollToBottom(animated: false)
        }
    }

    @objc private func removeKeyboard() {
        view.endEditing(true)
        self.scrollToBottom(animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        keyboardObserver.add()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        messageListUseCase.markAsRead()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        keyboardObserver.remove()
    }

    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }

        let touchPoint = sender.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: touchPoint) else { return }

        let message = messageListUseCase.messages[indexPath.row]

        handleLongPress(for: message)
    }

    private func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            let contentHeight = self.tableView.contentSize.height
            let tableHeight = self.tableView.bounds.height
            let bottomInset = self.tableView.adjustedContentInset.bottom
            let yOffset = max(contentHeight - tableHeight + bottomInset, 0)
            
            self.tableView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: false)
        }
    }

}

// MARK: - UITableViewDataSource

extension ChatsVC: UITableViewDataSource, BasicMessageCellDelegate {
    func didTapCell(_ cell: BasicMessageCell, withProfile profile: InfluenceProfileDto) {
        
        let portfolioVC = PortfolioVC()
        
        portfolioVC.id = "113946131317224674659"
        self.navigationController?.pushViewController(portfolioVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messageListUseCase.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messageListUseCase.messages[indexPath.row]
        
        if let fileMessage = message as? FileMessage {
            let cell: BasicFileCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: fileMessage)
            return cell
        } else {
            let cell: BasicMessageCell = tableView.dequeueReusableCell(for: indexPath)
            cell.selectionStyle = .none
            cell.delegate = self
            if indexPath.row != 0 {
                let firstMessage = messageListUseCase.messages[indexPath.row - 1]
                
                if Date.sbu_from(message.createdAt).sbu_toString(format: .yyyyMMdd) != Date.sbu_from(firstMessage.createdAt).sbu_toString(format: .yyyyMMdd ) {
                    cell.addHeader(date: Date.sbu_from(message.createdAt).sbu_toString(format: .yyyyMMdd, localizedFormat: true))
                }

            } else if indexPath.row ==  0 {
                cell.addHeader(date: Date.sbu_from(message.createdAt).sbu_toString(format: .yyyyMMdd, localizedFormat: true))
            }

            if let fileMessage = message as? FileMessage {
                cell.configure(with: fileMessage)
            } else {
                cell.configure(with: message)
            }
            
            let currentTime = Date.sbu_from(message.createdAt).sbu_toString(format: .yyyyMMddhhmm)
            
            if indexPath.row < messageListUseCase.messages.count - 1 {
                let nextMessage = messageListUseCase.messages[indexPath.row + 1]
                let nextTime = Date.sbu_from(nextMessage.createdAt).sbu_toString(format: .yyyyMMddhhmm)
                if nextTime == currentTime {
                    cell.hideTime()
                }
                
                
            }

            
            let unreadCount = channel.getUnreadMemberCount(message)
            if unreadCount == 0 {
                cell.checked(check: true)
            } else {
                cell.checked(check: false)
            }
            return cell
        }
        
    }

}

// MARK: - UITableViewDelegate

extension ChatsVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y - Constant.loadMoreThreshold <= 0 {
            messageListUseCase.loadPreviousMessages()
        }

        if scrollView.contentOffset.y + Constant.loadMoreThreshold >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            messageListUseCase.loadNextMessages()
        }
    }

}

// MARK: - GroupChannelMessageListUseCaseDelegate

extension ChatsVC: GroupChannelMessageListUseCaseDelegate {

    func groupChannelMessageListUseCase(_ useCase: GroupChannelMessageListUseCase, didReceiveError error: SBError) {
        presentAlert(error: error)
    }

    func groupChannelMessageListUseCase(_ useCase: GroupChannelMessageListUseCase, didUpdateMessages messages: [BaseMessage]) {
        
        tableView.reloadData()
        scrollToFocusMessage()
        
    }

    private func scrollToFocusMessage() {
        guard messageListUseCase.messages.count > 0 else {
            print("메시지가 없습니다. 스크롤 실행하지 않음")
            return
        }

        let focusMessageIndexPath = IndexPath(row: messageListUseCase.messages.count - 1, section: 0)
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: focusMessageIndexPath, at: .bottom, animated: false)
        }
        
    }

    // 새로운 메시지인지 확인하는 함수
    private func isNewMessages(_ messages: [BaseMessage]) -> Bool {
        // 기존 메시지의 마지막 메시지 ID 가져오기
        guard let lastExistingMessageId = messageListUseCase.messages.last?.messageId else {
            // 기존 메시지가 없으면 새 메시지로 간주
            return true
        }
        
        if messageListUseCase.messages.last?.messageId != targetMessageForScrolling?.messageId {
            return true
        }else{
            return false
        }
        
    }


    
    func groupChannelMessageListUseCase(_ useCase: GroupChannelMessageListUseCase, didUpdateChannel channel: GroupChannel) {
        title = name
    }

    func groupChannelMessageListUseCase(_ useCase: GroupChannelMessageListUseCase, didDeleteChannel channel: GroupChannel) {
        presentAlert(title: "This channel has been deleted", message: nil) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

}

// MARK: - MessageInputViewDelegate

extension ChatsVC: MessageInputViewDelegate {
    func messageInputView(_ messageInputView: MessageInputView, didChangeHeight newHeight: CGFloat) {
            messageInputHeightConstraint?.update(offset: newHeight)
        print(newHeight)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }

            scrollToBottom(animated: true)
        }

    func messageInputView(_ messageInputView: MessageInputView, didTouchUserMessageButton sender: UIButton, message: String) {
        messageInputHeightConstraint?.update(offset: 44)
        targetMessageForScrolling = userMessageUseCase.sendMessage(message) { [weak self] result in
            switch result {
            case .success(let sendedMessage):
                self?.targetMessageForScrolling = sendedMessage
            case .failure(let error):
                self?.presentAlert(error: error)
            }
        }
//        targetMessageForScrolling = fileMessageUseCase.sendFile() { [weak self] result in
//            switch result {
//            case .success(let sendedMessage):
//                self?.targetMessageForScrolling = sendedMessage
//            case .failure(let error):
//                self?.presentAlert(error: error)
//            }
//        }
        print("input on")
    }

    func messageInputView(_ messageInputView: MessageInputView, didTouchSendFileMessageButton sender: UIButton) {
        presentAttachFileAlert()
    }

}

// MARK: - KeyboardObserverDelegate

extension ChatsVC: KeyboardObserverDelegate {

    func keyboardObserver(_ keyboardObserver: KeyboardObserver, willShowKeyboardWith keyboardInfo: KeyboardInfo) {
        let keyboardHeight = keyboardInfo.height - view.safeAreaInsets.bottom
        messageInputBottomConstraint?.update(offset: -keyboardHeight)
        keyboardInfo.animate { [weak self] in
            self?.view.layoutIfNeeded()
            self?.scrollToBottom(animated: false)
        }
    }

    func keyboardObserver(_ keyboardObserver: KeyboardObserver, willHideKeyboardWith keyboardInfo: KeyboardInfo) {
        messageInputBottomConstraint?.update(offset: 0)

        keyboardInfo.animate { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

}
