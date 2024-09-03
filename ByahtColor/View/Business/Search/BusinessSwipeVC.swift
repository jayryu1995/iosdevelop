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

        getProfileList()

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

    private func getProfileList() {
        viewModel.getSearchProfile(sns: nil, category: nil, nation: nil) { [weak self] result in
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

    private func setupPageViewController() {
        if let pageViewController = pageViewController {
            pageViewController.willMove(toParent: nil)
            pageViewController.view.removeFromSuperview()
            pageViewController.removeFromParent()
        }

        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        // profileList의 각 요소에 대해 페이지 생성
        for (index, profile) in profileList.enumerated() {
            let page = BusinessSearchVC()

            // profile.imagePath가 있는지 확인
            if let path = profile.imagePath {
                let str = path.split(separator: ".").last ?? ""

                // path에 "mp4"가 포함되어 있는지 확인
                if str.contains("mp4") {
                    if let mediaUrl = URL(string: "\(Bundle.main.TEST_URL)\(path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
                        
                        //let testURL = URL(string: "http://d3mp6eqt0w2808.cloudfront.net/vod/hls/7563567570439524.m3u8")
                        // 첫 페이지에 대한 추가 디버깅 메시지 출력
                        if index == 0 {
                            let item = AVPlayerItem(url: mediaUrl)
                            item.preferredForwardBufferDuration = TimeInterval(1.0)
                            page.playerItem = item
                            
                        }
                        // 비디오 캐시
                        VideoCacheManager.shared.cacheVideo(from: mediaUrl) { [weak page] localUrl in
                            guard let localUrl = localUrl else { return }
                            DispatchQueue.main.async {
                                    page?.playerItem = AVPlayerItem(url: localUrl)
                            }
                        }
                    }
                } else if str.contains("jpg") {
                    let mediaPath = "\(Bundle.main.TEST_URL)/img\(path)"
                    page.imageView.loadImage(from: mediaPath)
                    
                } else {
                    page.imageView.image = UIImage(named: "sample_image")
                    
                }
            }

            page.profile = profile

            pages.append(page)
        }

        if let firstPage = pages.first {
            pageViewController.setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension BusinessSwipeVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate, FloatingPanelControllerDelegate, InfluenceFilterVCDelegate {
    func didTapButton(SnsArray array: [String], CategoryArray2 array2: [String], NationArray3 array3: [String]) {
        profileList.removeAll()
        pages.removeAll()

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
