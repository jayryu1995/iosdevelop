//
//  FindAccountVC.swift
//  ByahtColor
//
//  Created by jaem on 6/19/24.
//

import Foundation
import SnapKit
import UIKit

class FindAccountVC: UIViewController {

    private var pageViewController: UIPageViewController!
    lazy private var pages = [UIViewController]()
    lazy private var userButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.setTitle("find_account_id".localized, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.setTitleColor(UIColor(hex: "#B5B8C2"), for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    lazy private var businessButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.setTitle("find_account_password".localized, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.setTitleColor(UIColor(hex: "#B5B8C2"), for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()

    private var stackView: UIStackView!
    lazy private var separatorLine = UIView()
    lazy private var layer1 = CALayer()
    lazy private var layer2 = CALayer()

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateButtonBottomLayerFrame()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateButtonBottomLayerFrame()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "login_find_account".localized
        setupBackButton()
        setupPages()
        setupButtons()
        setupPageViewController()
        setupButtonBorderLayers()
        setupConstraints()
        setupSeparatorLine()
        // 초기 선택된 버튼의 레이어를 표시
        updateButtonSelection(selectedIndex: 0)
    }

    private func setupConstraints() {
        view.addSubview(stackView)
        view.addSubview(pageViewController.view)

        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            $0.height.equalTo(34)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

    }

    private func setupButtons() {
        userButton.tag = 0
        businessButton.tag = 1
        userButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        businessButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)

        stackView = UIStackView(arrangedSubviews: [userButton, businessButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
    }

    @objc private func tabButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index >= 0 && index < pages.count else { return }
        pageViewController.setViewControllers([pages[index]], direction: .forward, animated: false, completion: nil)
        updateButtonSelection(selectedIndex: index)
    }

    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        addChild(pageViewController)

        pageViewController.didMove(toParent: self)

        if let firstPage = pages.first {
            pageViewController.setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
        }
    }

    private func setupPages() {
        let page1 = FindIdVC()
        let page2 = FindPasswordVC()

        pages.append(page1)
        pages.append(page2)
    }

    private func setupSeparatorLine() {
        separatorLine.backgroundColor = UIColor(hex: "#F4F5F8")
        view.addSubview(separatorLine)

        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
    }

    private func updateButtonSelection(selectedIndex: Int) {
        userButton.isSelected = selectedIndex == 0
        businessButton.isSelected = selectedIndex == 1
        layer1.isHidden = !userButton.isSelected
        layer2.isHidden = !businessButton.isSelected
    }

    // 버튼 layer
    private func setupButtonBorderLayers() {
        layer1.backgroundColor = UIColor.black.cgColor
        layer2.backgroundColor = UIColor.black.cgColor
        userButton.layer.addSublayer(layer1)
        businessButton.layer.addSublayer(layer2)
    }

    private func updateButtonBottomLayerFrame() {
        [userButton, businessButton].forEach { button in
            // 버튼의 타이틀 라벨 크기를 조정

                // 타이틀 라벨의 너비를 바탕으로 바텀 레이어의 프레임 설정
                let layerWidth = button.frame.width
                let layer = button.tag == 0 ? layer1 : layer2
                let layerYPosition = button.frame.height - 3 // 레이어의 y 위치
                layer.frame = CGRect(x: (button.frame.width - layerWidth) / 2, y: layerYPosition, width: layerWidth, height: 3)

        }
    }
}

extension FindAccountVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController), viewControllerIndex > 0 else {
            return nil
        }
        return pages[viewControllerIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController), viewControllerIndex < pages.count - 1 else {
            return nil
        }
        return pages[viewControllerIndex + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: currentViewController) {
            updateButtonSelection(selectedIndex: index)
        }
    }
}
