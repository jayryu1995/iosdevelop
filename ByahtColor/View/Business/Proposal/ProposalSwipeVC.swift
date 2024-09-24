//
//  ProposalSwipeVC.swift
//  ByahtColor
//
//  Created by jaem on 8/21/24.
//

import FloatingPanel
import AVFoundation
import UIKit
import SnapKit
import SendbirdChatSDK

class ProposalSwipeVC: UIViewController {

    private var pageViewController: UIPageViewController!
    private var pages = [UIViewController]()
    private var currentPageIndex: Int = 0
    var profileList: [InfluenceProfileDto] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Proposal"
        setupBackButton()
        self.navigationController?.navigationBar.isHidden = false
        
        getProfileList()

    }
 
    private func setupSampleView() {
        let exampleVC = BusinessGuideVC()
        exampleVC.modalPresentationStyle = .overFullScreen
        exampleVC.modalTransitionStyle = .crossDissolve
        exampleVC.onDismiss = { [weak self] in
            self?.presentBusinessGuide2VC()
        }
        present(exampleVC, animated: true, completion: nil)

    }

    private func presentBusinessGuide2VC() {
        let vc = BusinessGuide2VC()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }

    private func getProfileList() {
        setupPageViewController()
    }

    private func navigationToChats(influenceId:String,businessId:String) {
        let params = GroupChannelCreateParams()
        params.name = "test Chat"

        let server: String = businessId
        let client: String = influenceId
        params.userIds = [server, client]
        params.isDistinct = true

        GroupChannel.createChannel(params: params) { channel, error in
            guard error == nil else {
                // Handle error.
                return
            }
            var timestampStorage = TimestampStorage()

            let vc = ChatsVC(channel: channel!, timestampStorage: timestampStorage)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

}

extension ProposalSwipeVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate, FloatingPanelControllerDelegate,
                           ProposalListUpdateDelegate{
    
    private func setupPageViewController() {
        if let pageViewController = pageViewController {
            pageViewController.willMove(toParent: nil)
            pageViewController.view.removeFromSuperview()
            pageViewController.removeFromParent()
        }

        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        // 모든 페이지를 한꺼번에 처리
        for profile in profileList {
            let page = BusinessSearchVC()
            page.profile = profile
            pages.append(page)

        }

        // 첫 번째 페이지 설정
        if let firstPage = pages.first {
            self.pageViewController.setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }

        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParent: self)
        self.pageViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    func didUpdateProposalList(memberId:String) {
        guard let currentViewController = pageViewController.viewControllers?.first,
              let currentIndex = pages.firstIndex(of: currentViewController) else {
            return
        }
        navigationToChats(influenceId: memberId, businessId: User.shared.id ?? "")
        let nextIndex = currentIndex + 1

        // 현재 페이지가 마지막 페이지인지 확인
        if nextIndex < pages.count {
            let nextViewController = pages[nextIndex]

            // 페이지 전환
            DispatchQueue.main.async {
                self.pageViewController.setViewControllers([nextViewController], direction: .forward, animated: true) { [weak self] completed in
                    if completed {
                        // 현재 페이지 제거
                        self?.pages.remove(at: currentIndex)
                        self?.currentPageIndex = nextIndex - 1 // 인덱스 업데이트
                    }
                }
            }
            
        } else {
            // 다음 페이지가 없을 경우의 처리 (예: 마지막 페이지일 경우)
            // 빈 페이지를 생성
            let emptyViewController = UIViewController()
            emptyViewController.view.backgroundColor = .white // 원하는 배경색 설정

            // UILabel 생성 및 설정
            let label = UILabel()
            label.text = "proposal_swipe_label".localized
            label.textColor = .black
            label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
            label.textAlignment = .center

            // Label을 뷰에 추가
            emptyViewController.view.addSubview(label)

            // Label의 위치 설정 (가운데 정렬)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.snp.makeConstraints{
                $0.center.equalToSuperview()
            }

            // 빈 페이지를 보여줌
            DispatchQueue.main.async {
                self.pageViewController.setViewControllers([emptyViewController], direction: .forward, animated: true, completion: nil)
            }

        }
        
        
    }

    
    
    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard pages.count > previousIndex else { return nil }

        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return nil }

        return pages[nextIndex]
    }

    // MARK: - UIPageViewControllerDelegate

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: visibleViewController) {
            currentPageIndex = index
        }
    }

    func floatingPanelWillBeginAttracting(_ fpc: FloatingPanelController, to state: FloatingPanelState) {
        if state == FloatingPanelState.half {
            self.navigationController?.navigationBar.isHidden = false
            fpc.removePanelFromParent(animated: true)
        }
    }

    func floatingPanelDidRemove(_ vc: FloatingPanelController) {
        self.navigationController?.navigationBar.isHidden = false
    }

    func floatingPanel(_ fpc: FloatingPanelController, didTapBackdrop backdropView: UIView) {
        // 패널 제거
        self.navigationController?.navigationBar.isHidden = false
        fpc.removePanelFromParent(animated: true)
    }
}
