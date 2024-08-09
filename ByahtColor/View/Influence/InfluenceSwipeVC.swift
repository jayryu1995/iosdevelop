//
//  InfluenceSwipeVC.swift
//  ByahtColor
//
//  Created by jaem on 6/28/24.
//

import Foundation
import UIKit
import SnapKit

class InfluenceSwipeVC: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private var viewModel = InfluenceViewModel()
    private var pageViewController: UIPageViewController!
    private var pages = [UIViewController]()
    private var currentPageIndex: Int = 0
    private var businessList: [BusinessDetailDto] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.isHidden = false
        setupBackButton()
        getProfileList()
        if UserDefaults.standard.integer(forKey: "sample") == 0 {
            setupSampleView()
        }

    }

    private func setupSampleView() {
        let exampleVC = InfluenceSampleVC()
        exampleVC.modalPresentationStyle = .overFullScreen
        exampleVC.modalTransitionStyle = .crossDissolve
        present(exampleVC, animated: true, completion: nil)
    }

    private func getProfileList() {
        viewModel.getSearchBusiness { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.log(message: "\(data.count)")
                    self?.businessList = data
                    self?.setupPageViewController()
                case .failure(let error):
                    self?.log(message: "통신 에러 : \(error)")
                }
            }
        }
    }

    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        // profileList의 각 요소에 대해 페이지 생성
        for business in businessList {
            let page = InfluenceSearchVC()
            page.business = business
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
