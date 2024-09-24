import FloatingPanel
import AVFoundation
import UIKit
import SnapKit

class BusinessSwipeVC: UIViewController {
    private let filterButton: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "icon_filter"))
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()
    private var pageViewController: UIPageViewController!
    private var pages = [UIViewController]()
    private var currentPageIndex: Int = 0
    private let viewModel = BusinessViewModel()
    private var profileList: [InfluenceProfileDto] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.isHidden = false
        let filterBarButtonItem = UIBarButtonItem(customView: filterButton)
        self.navigationItem.rightBarButtonItem = filterBarButtonItem

        // 필터 버튼에 제스처 인식기 추가
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(filterButtonTapped))
        filterButton.addGestureRecognizer(tapGestureRecognizer)

        if let list = Globals.shared.searchList{
            self.profileList = list
            setupPageViewController()
        }
        
        if UserDefaults.standard.integer(forKey: "sample") == 0 {
            setupSampleView()
        }
    }

    @objc private func filterButtonTapped() {
        self.navigationController?.navigationBar.isHidden = true
        showFloatingPanel()
    }

    private func showFloatingPanel() {
        let fpc = FloatingPanelController()
        fpc.delegate = self

        let contentVC = InfluenceFilterVC() // 패널에 표시할 컨텐츠 뷰 컨트롤러
        contentVC.delegate = self
        fpc.set(contentViewController: contentVC)
        fpc.layout = CustomFloatingPanel()
        fpc.isRemovalInteractionEnabled = true
        fpc.surfaceView.backgroundColor = .clear  // 추가: 투명한 배경 설정
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true  // 추가: 탭 제스처 인식기 활성화
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
}

extension BusinessSwipeVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate, FloatingPanelControllerDelegate, InfluenceFilterVCDelegate {
    func didTapButton(SnsArray array: [String], CategoryArray2 array2: [String], NationArray3 array3: [String]) {
        profileList.removeAll()

        viewModel.getSearchProfile(sns: array, category: array2, nation: array3) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    print(data.count)
                    self?.profileList = data
                    self?.setupPageViewController()
                case .failure(let error):
                    print("통신 에러 : \(error)")
                }
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
