import Foundation
import AVFoundation
import UIKit
import SnapKit

class BusinessSwipeVC: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

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
        getProfileList()

        if UserDefaults.standard.object(forKey: "sample") == nil {
            print("setupSampleView")
            setupSampleView()
        }
    }

    private func setupSampleView() {
        let exampleVC = BusinessSampleVC()
        exampleVC.modalPresentationStyle = .overFullScreen
        exampleVC.modalTransitionStyle = .crossDissolve
        present(exampleVC, animated: true, completion: nil)
    }

    private func getProfileList() {
        viewModel.getSearchProfile { [weak self] result in
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
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        // profileList의 각 요소에 대해 페이지 생성
        for profile in profileList {
            let page = BusinessSearchVC()
            if let path = profile.imagePath {
                let str = path.split(separator: ".").last ?? ""
                if str.contains("mp4") {
                    let mediaPath = URL(string: "\(Bundle.main.TEST_URL)\( profile.imagePath ?? "" )")
                    page.playerItem = AVPlayerItem(url: mediaPath!)
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
}
