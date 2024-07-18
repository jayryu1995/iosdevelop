//
//  DiscountVC.swift
//  ByahtColor
//
//  Created by jaem on 5/13/24.
//

import SnapKit
import UIKit
import Alamofire

class UserDiscountVC: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private var pageViewController: UIPageViewController!
    private var pages = [UIViewController]()
    private let clinicButton = UIButton()
    private let beautyButton = UIButton()
    private var stackView: UIStackView!
    private let separatorLine = UIView()
    private let clinicButtonBorderLayer = CALayer()
    private let beautyButtonBorderLayer = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white

        setupPages()
        setupButtons()
        setupPageViewController()
        setupSeparatorLine()
        setupButtonBorderLayers()
        // 초기 선택된 버튼의 레이어를 표시
        updateButtonSelection(selectedIndex: 0)
        setupButtonInBottomRightCorner()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        updateButtonBottomLayerFrame()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 화면 이동 이전에 네비게이션 바를 다시 표시
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateButtonBottomLayerFrame()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 레이아웃이 완전히 설정된 후에 레이어의 프레임을 업데이트
        updateButtonBottomLayerFrame()

    }

    private func setupPages() {
        let page1 = UserDiscountBeautyVC()
        let page2 = UserDiscountFashionVC()

        pages.append(page1)
        pages.append(page2)
    }

    private func setupButtons() {
        clinicButton.setTitle("Fashion", for: .normal)
        beautyButton.setTitle("Beauty", for: .normal)
        clinicButton.setTitleColor(.gray, for: .normal)
        clinicButton.setTitleColor(.black, for: .selected)
        clinicButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        beautyButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        beautyButton.setTitleColor(.gray, for: .normal)
        beautyButton.setTitleColor(.black, for: .selected)

        beautyButton.tag = 0
        clinicButton.tag = 1

        clinicButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        beautyButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)

        stackView = UIStackView(arrangedSubviews: [beautyButton, clinicButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.backgroundColor = .white

        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = UIColor.gray.cgColor
        let borderWidth = 1.0 / UIScreen.main.scale
        bottomBorder.frame = CGRect(x: 0, y: stackView.frame.size.height - borderWidth, width: stackView.frame.size.width, height: borderWidth)
        stackView.layer.addSublayer(bottomBorder)

        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().dividedBy(2)
            make.height.equalTo(44)
        }
    }

    private func updateButtonBottomLayerFrame() {
        [beautyButton, clinicButton].forEach { button in
            // 버튼의 타이틀 라벨 크기를 조정
            button.titleLabel?.sizeToFit()

            if let titleLabel = button.titleLabel {
                // 타이틀 라벨의 너비를 바탕으로 바텀 레이어의 프레임 설정
                let layerWidth = titleLabel.frame.width
                let layer = button.tag == 0 ? beautyButtonBorderLayer : clinicButtonBorderLayer
                let layerYPosition = button.frame.height - 3 // 레이어의 y 위치
                layer.frame = CGRect(x: (button.frame.width - layerWidth) / 2, y: layerYPosition, width: layerWidth, height: 3)
            }
        }
    }

    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        if let firstPage = pages.first {
            pageViewController.setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
        }
    }

    @objc private func tabButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index >= 0 && index < pages.count else {
            return
        }
        pageViewController.setViewControllers([pages[index]], direction: .forward, animated: false, completion: nil)
        updateButtonSelection(selectedIndex: index)

    }

    // 버튼 layer
    private func setupButtonBorderLayers() {
        clinicButtonBorderLayer.backgroundColor = UIColor.black.cgColor
        beautyButtonBorderLayer.backgroundColor = UIColor.black.cgColor

        beautyButton.layer.addSublayer(beautyButtonBorderLayer)
        clinicButton.layer.addSublayer(clinicButtonBorderLayer)

    }

    private func setupSeparatorLine() {
        separatorLine.backgroundColor = UIColor(hex: "#F4F5F8") // 구분선 색상 설정
        view.addSubview(separatorLine)

        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom) // 스택 뷰 바로 아래에 위치
            make.leading.trailing.equalToSuperview() // 좌우로 꽉 차게
            make.height.equalTo(1) // 구분선 높이 설정
        }

        // 페이지 뷰 컨트롤러 뷰의 레이아웃 업데이트
        pageViewController.view.snp.remakeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom) // 구분선 아래에 시작
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func updateButtonSelection(selectedIndex: Int) {
        beautyButton.isSelected = selectedIndex == 0
        clinicButton.isSelected = selectedIndex == 1
        clinicButtonBorderLayer.isHidden = !clinicButton.isSelected
        beautyButtonBorderLayer.isHidden = !beautyButton.isSelected
    }

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

    private func setupButtonInBottomRightCorner() {
        let uploadButton: UIButton = {
            let button = UIButton()
            button.isUserInteractionEnabled = true
            button.setTitle("등록하기", for: .normal)
            button.setImage(UIImage(named: "icon_hands"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
            button.imageView?.contentMode = .scaleAspectFit
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
            button.backgroundColor = .black
            button.layer.cornerRadius = 19
            button.alpha = 0.7
            button.isHidden = true
            return button
        }()

        if User.shared.auth == 2 {
            uploadButton.isHidden = false
        }

        uploadButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        view.addSubview(uploadButton)

        uploadButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20) // 하단 여백
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20) // 오른쪽 여백
            make.height.equalTo(40)
            make.width.equalToSuperview().inset(40).dividedBy(2)
        }
    }

    @objc private func actionButtonTapped() {
        // 버튼 클릭 시 수행할 작업
        let vc = UserDiscountWriteVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
