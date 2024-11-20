import FloatingPanel
import AVFoundation
import UIKit
import SnapKit

protocol ProfilePageDataLoaderDelegate: AnyObject {
    func didStartDataLoading()
    func didFinishDataLoading()
}

class BusinessSwipeVC: UIViewController, ProfilePageDataLoaderDelegate {
    
    private let filterButton: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "icon_filter"))
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private var pageViewController: UIPageViewController!
    private var currentPageIndex: Int = 0
    private let viewModel = BusinessViewModel()
    private var profileList: [InfluenceProfileDto] = []
    private var isTransitioning = false
    private var page = 1
    private var nation : [String]? = nil
    private var sns : [String]? = nil
    private var category : [String]? = nil
    private var lastFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.isHidden = false
        let filterBarButtonItem = UIBarButtonItem(customView: filterButton)
        self.navigationItem.rightBarButtonItem = filterBarButtonItem

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(filterButtonTapped))
        filterButton.addGestureRecognizer(tapGestureRecognizer)

        if let list = Globals.shared.searchList {
            self.profileList = list
            setupPageViewController()
        }
        
        if UserDefaults.standard.integer(forKey: "sample") == 0 {
            setupSampleView()
        }
        
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
    }

    @objc private func filterButtonTapped() {
        self.navigationController?.navigationBar.isHidden = true
        showFloatingPanel()
    }

    private func showFloatingPanel() {
        let fpc = FloatingPanelController()
        fpc.delegate = self

        let contentVC = InfluenceFilterVC()
        contentVC.delegate = self
        fpc.set(contentViewController: contentVC)
        fpc.layout = CustomFloatingPanel()
        fpc.isRemovalInteractionEnabled = true
        fpc.surfaceView.backgroundColor = .clear
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        fpc.surfaceView.appearance.cornerRadius = 20
        fpc.addPanel(toParent: self)
        fpc.move(to: .full, animated: true)
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
    
    private func setupPageViewController() {
        pageViewController?.willMove(toParent: nil)
        pageViewController?.view.removeFromSuperview()
        pageViewController?.removeFromParent()

        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        print("currentPageIndex : \(currentPageIndex)")
        if let firstPage = viewControllerAt(index: currentPageIndex) {
            pageViewController.setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - ProfilePageDataLoaderDelegate
    
    func didStartDataLoading() {
        loadingIndicator.startAnimating()
        pageViewController.dataSource = nil // 데이터 로딩 중 스와이프 차단
    }
    
    func didFinishDataLoading() {
        loadingIndicator.stopAnimating()
        pageViewController.dataSource = self // 로딩 후 스와이프 재허용
        // 페이지 갱신 및 현재 인덱스 위치 조정
        let previousCount = self.profileList.count
        if let currentVC = self.viewControllerAt(index: self.currentPageIndex) {
            // 새 데이터가 추가된 후에도 `currentPageIndex`가 올바른 위치를 가리키도록 설정
            self.pageViewController.setViewControllers([currentVC], direction: .forward, animated: false, completion: { _ in
                // 새로 추가된 데이터가 반영되도록 인덱스 위치 재확인
                if self.currentPageIndex >= previousCount {
                    self.currentPageIndex = previousCount - 1
                }
                
            })
        }
    }
    
    private func loadMoreDataIfNeeded() {
        print("loadMoreDataIfNeeded 실행")
        guard !isTransitioning else { return }
        
        didStartDataLoading() // 로딩 시작 알림
        isTransitioning = true // 전환 중 상태 설정
        self.page += 1
        print("page: \(page)")
        viewModel.getSearchProfilePage(sns: sns, category: category, nation: nation, page: page) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isTransitioning = false // 전환 상태 해제

                switch result {
                case .success(let data):
                    // 기존 profileList의 memberId를 Set으로 저장하여 중복 체크를 빠르게 수행
                    let existingIds = Set(self.profileList.map { $0.memberId })
                    
                    // 새로운 데이터에서 중복되지 않은 항목만 필터링
                    let uniqueData = data.filter { newProfile in
                        !existingIds.contains(newProfile.memberId)
                    }
                    // 중복이 제거된 데이터를 profileList에 추가
                    if !uniqueData.isEmpty {
                        self.profileList.append(contentsOf: uniqueData)
                        
                        print("더 많은 데이터 로드됨. 총 데이터 수: \(self.profileList.count)")
                        self.didFinishDataLoading() // 로딩 완료 알림
                    }else{
                        self.lastFlag = true
                    }
                    self.loadingIndicator.stopAnimating()
                    self.pageViewController.dataSource = self // 로딩 후 스와이프 재허용
                    
                    
                case .failure(let error):
                    print("데이터 로딩 실패: \(error)")
                    self.loadingIndicator.stopAnimating()
                    self.pageViewController.dataSource = self // 로딩 후 스와이프 재허용
                }
            }
        }

    }

    private func viewControllerAt(index: Int) -> BusinessSearchVC? {
        guard index >= 0, index < profileList.count else { return nil }
        print("profileList.count : \(profileList.count)")
        let vc = BusinessSearchVC()
        vc.profile = profileList[index]
        return vc
    }
}

extension BusinessSwipeVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate, FloatingPanelControllerDelegate, InfluenceFilterVCDelegate {
    func didTapButton(SnsArray array: [String], CategoryArray2 array2: [String], NationArray3 array3: [String]) {
        profileList.removeAll()
        currentPageIndex = 0
        page = 1
        sns = array
        category = array2
        nation = array3
        
        viewModel.getSearchProfilePage(sns: sns, category: category, nation: nation, page: page) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    
                    self?.profileList = data
                    print("Updated profileList count: \(self?.profileList.count)")
                    self?.setupPageViewController()
                    
                case .failure(let error):
                    print("통신 에러 : \(error)")
                }
            }
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard !isTransitioning,
              let businessVC = viewController as? BusinessSearchVC,
              let profileID = businessVC.profile?.memberId,
              let index = profileList.firstIndex(where: { $0.memberId == profileID }) else {
            return nil
        }
        return viewControllerAt(index: index - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let businessVC = viewController as? BusinessSearchVC,
              let profileID = businessVC.profile?.memberId,
              let index = profileList.firstIndex(where: { $0.memberId == profileID }) else {
            return nil
        }

        let nextIndex = index + 1
        
        if nextIndex >= profileList.count, lastFlag == false {
            loadMoreDataIfNeeded()
            return nil
        }
        
        return viewControllerAt(index: nextIndex)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
              let visibleVC = pageViewController.viewControllers?.first as? BusinessSearchVC,
              let profileID = visibleVC.profile?.memberId,
              let index = profileList.firstIndex(where: { $0.memberId == profileID }) else { return }

        currentPageIndex = index
        print("전환 후 인덱스 업데이트: \(index)")
        isTransitioning = false
    }


    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        isTransitioning = true
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
        self.navigationController?.navigationBar.isHidden = false
        fpc.removePanelFromParent(animated: true)
    }
}
