//
//  BusinessOnboardingVC.swift
//  ByahtColor
//
//  Created by jaem on 9/9/24.
//

import Foundation
import UIKit
import SnapKit

class BusinessOnboardingVC: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private let logoImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "logo"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    private var pageViewController: UIPageViewController!
    private var pages = [UIViewController]()
    private var currentPageIndex: Int = 0
    private let pageControl = UIPageControl()

    deinit {
        NotificationCenter.default.removeObserver(self, name: .dataChanged, object: nil)
       }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(handleAccountUpdated), name: .dataChanged, object: nil)
    }

    @objc private func handleAccountUpdated(notification: NSNotification) {
        dismiss(animated: false)
    }

    private func setupUI() {
        setupLogo()
        setupPages()
        setupPageViewController()
        setupPageControl()
        setupConstraints()
    }

    private func setupLogo() {
        view.addSubview(logoImage)
    }

    private func setupPages() {
        let firstView = BusinessFirstOnboardingVC()
        let secondView = BusinessSecondOnboardingVC()
        let thridView = BusinessThirdOnboardingVC()
        let fourthView = BusinessFourthOnboardingVC()
        pages.append(firstView)
        pages.append(secondView)
        pages.append(thridView)
        pages.append(fourthView)
    }

    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        if let firstPage = pages.first {
            pageViewController.setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }

    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = currentPageIndex
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = UIColor(hex: "#009BF2")
        view.addSubview(pageControl)
    }

    private func setupConstraints() {
        logoImage.snp.makeConstraints { make in
            make.width.equalTo(55)
            make.height.equalTo(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        pageControl.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(38)
            make.centerX.equalToSuperview()
        }

        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
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
        guard pages.count > nextIndex else { return nil }
        return pages[nextIndex]
    }

    // Optional: Update page control current page indicator
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: currentViewController) {
            currentPageIndex = index
            pageControl.currentPage = currentPageIndex
        }
    }
}
