//
//  NotificationVC.swift
//  ByahtColor
//
//  Created by jaem on 4/22/25.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class NotificationVC : UIViewController {
    
    private let viewModel = NotificationViewModel()
    private let scrollView = UIScrollView()
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .equalSpacing
        return view
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
    
    private var notificationList : [NotificationDataDto] = []
    private var unreadList: [Int] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setupUserData),
            name: .didReceiveNewNotification,
            object: nil
        )
        setupUserData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .didReceiveNewNotification, object: nil)
    }
    
    override func viewDidLoad(){
        self.navigationItem.title = "Notification"
        
        setupScrollView()
        setupStackView()
        setupEmptyView()
        setupConstraints()
    }
    
    private func setupEmptyView(){
        backgroundView.addSubview(emptyImage)
        backgroundView.addSubview(emptyLabel)
        view.addSubview(backgroundView)
    }
    
    private func setupConstraints(){
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.trailing.equalTo(scrollView.snp.leading)
            $0.trailing.equalTo(scrollView.snp.trailing)
            $0.bottom.equalTo(scrollView.snp.bottom) // 💥 필수!
            $0.width.equalTo(scrollView.frameLayoutGuide) // 💥 수직 스크롤만 가능하게
        }
        
        backgroundView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        emptyImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(88)
        }
        
        emptyLabel.snp.makeConstraints{
            $0.top.equalTo(emptyImage.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupInnerViews() {
        notificationList.forEach { notification in
            let id = Int(notification.id)
            unreadList.append(id)
            let innerView = makeInnerView(notification: notification)
            stackView.addArrangedSubview(innerView)
            innerView.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(94)
            }
        }
    }
    
    private func makeInnerView(notification: NotificationDataDto) -> UIView{
        let innerView = UIView()
        
        // 🧱 Horizontal StackView (전체)
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .center
        hStack.distribution = .fill
        hStack.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        // 🖼️ Left ImageView
        let leftImageView = UIImageView()
        loadImage(from: notification.imageUrl ?? "", into: leftImageView)
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.clipsToBounds = true
        leftImageView.snp.makeConstraints { $0.width.height.equalTo(46) }
        leftImageView.layer.cornerRadius = 23
        
        // 🏷️ Vertical Label Stack
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 4
        
        let titleLabel = UILabel()
        
        let elapsed = DateTimeUtils.elapsedTimeFromVietnamDate(notification.createdAt)
        titleLabel.text = elapsed
        
        
        titleLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        titleLabel.textColor = UIColor(hex: "#B5B8C2")
        
        let contentLabel = UILabel()
        contentLabel.text = notification.content
        contentLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
        contentLabel.numberOfLines = 2
        
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(contentLabel)
        
        // 🖼️ Right ImageView
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "back_icon")
        rightImageView.contentMode = .scaleAspectFit
        rightImageView.isUserInteractionEnabled = true
        rightImageView.snp.makeConstraints { $0.width.height.equalTo(20) }
        
        let tapGesture = UITapGestureRecognizer()
        rightImageView.addGestureRecognizer(tapGesture)
        tapGesture.addTargetClosure { [weak self] in
            self?.setupTapDelete(notificationID: notification.id)
        }
        // 📦 Add all to horizontal stack
        hStack.addArrangedSubview(leftImageView)
        hStack.addArrangedSubview(vStack)
        hStack.addArrangedSubview(rightImageView)
        
        innerView.backgroundColor = notification.read ? .white : UIColor(hex: "#FFEAF6")
        
        return innerView
    }
    
    private func setupScrollView(){
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupStackView(){
        scrollView.addSubview(stackView)
        
    }
  
    private func stateBackgroundView(){
        if self.notificationList.isEmpty {
            // 비어있으면 emptyImage만 보여주기
            self.backgroundView.isHidden = false
        } else {
            // 데이터가 있으면 emptyImage 숨기고, 항목 표시
            self.backgroundView.isHidden = true
        }
    }
    
    @objc private func setupUserData(){
        // 기존 뷰 정리
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        notificationList.removeAll()
        unreadList.removeAll()
        viewModel.requestNotifications() { result in
            switch result {
            case .success(let notifications):
                self.notificationList = notifications
                DispatchQueue.main.async {
                    self.stateBackgroundView()
                    self.setupInnerViews()
                }
                // 읽음 처리
                self.viewModel.markNotificationsAsRead(ids: self.unreadList) { _ in
                    // badge 아이콘 업데이트 등
                }
            case .failure(let error):
                print("에러 발생: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func setupTapDelete(notificationID: Int64) {
        viewModel.deleteNotification(id: notificationID) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self.notificationList.firstIndex(where: { $0.id == notificationID }) {
                        self.notificationList.remove(at: index)
                        
                        // 👉 스택뷰에서 제거할 뷰
                        let viewToRemove = self.stackView.arrangedSubviews[index]

                        // 👇 애니메이션 시작
                        UIView.animate(withDuration: 0.3, animations: {
                            viewToRemove.alpha = 0
                            viewToRemove.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                        }, completion: { _ in
                            self.stackView.removeArrangedSubview(viewToRemove)
                            viewToRemove.removeFromSuperview()
                        })
                        
                        // unreadList도 제거
                        if let unreadIndex = self.unreadList.firstIndex(of: Int(notificationID)) {
                            self.unreadList.remove(at: unreadIndex)
                        }
                    }
                    self.stateBackgroundView()

                case .failure(let error):
                    print("삭제 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}
private var tapGestureKey: UInt8 = 0
extension UITapGestureRecognizer {
    func addTargetClosure(_ closure: @escaping () -> Void) {
        objc_setAssociatedObject(self, &tapGestureKey, closure, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(self, action: #selector(handleTap))
    }
    
    @objc private func handleTap() {
        if let closure = objc_getAssociatedObject(self, &tapGestureKey) as? () -> Void {
            closure()
        }
    }
}
extension Notification.Name {
    static let didReceiveNewNotification = Notification.Name("didReceiveNewNotification")
}
