//
//  ProfileVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/12.
//

import SnapKit
import UIKit
import Alamofire

class ProfileVC: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    // pageControl
    private var pageViewController: UIPageViewController!
    private var pages = [UIViewController]()
    private var stackView: UIStackView!
    private let separatorLine = UIView()
    private let snapButtonBorderLayer = CALayer()
    private let followButtonBorderLayer = CALayer()
    private let topView = RadiusUIView()

    private var postsCount = 0
    private var followerCount = 0
    private var followingCount = 0

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_profile2")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.textAlignment = .center
        return label
    }()

    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        return label
    }()

    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(UIColor(hex: "#535358"), for: .normal)
        button.layer.cornerRadius = 4
        button.backgroundColor = UIColor(hex: "#F7F7F7")
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return button
    }()

    let snapButton: UIButton = {
        let button = UIButton()
        button.setTitle("My Snap", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitleColor(UIColor.black, for: .selected)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        button.backgroundColor = .white
        button.tag = 0
        return button
    }()

    let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("My Posts", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitleColor(UIColor.black, for: .selected)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        button.backgroundColor = .white
        button.tag = 1
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

    }

    private func loadData(completion: @escaping () -> Void) {
        if let userId = User.shared.id {
            let url = "\(Bundle.main.TEST_URL)/user/sel"

            let parameters: [String: Any] = ["user_id": userId]

            AF.request(url, method: .post, parameters: parameters)
                .responseDecodable(of: UserDto.self) { response in
                    switch response.result {
                    case .success(let userDto):
                        DispatchQueue.main.async {
                            // 서버 응답 처리
                            self.label.text = userDto.nickname
                            self.bodyLabel.text = "\(userDto.height ?? 0) cm • \(userDto.weight ?? 0) kg"
                            self.contentLabel.text = "\(userDto.bio ?? "")"
                            self.followerCount = userDto.followers ?? 0
                            self.followingCount = userDto.following ?? 0
                            self.postsCount = userDto.posts ?? 0
                            let userId = userDto.id ?? ""
                            let path = "/\(userId)/\(userId).jpg"
                            let url = "\(Bundle.main.TEST_URL)/profile\( path )"
                            print("url  = \(url)")
                            self.imageView.loadImage(from: url, resizedToWidth: 64)
                            self.imageView.layer.cornerRadius = 32

                            completion()
                        }

                    case .failure(let error):
                        // 오류 처리
                        print("Error: \(error)")
                        completion()
                    }
                }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData {
            self.setViewConfig()
        }
        // imageView.layer.cornerRadius = imageView.frame.size.width / 2
        updateButtonBottomLayerFrame(snapButton, snapButtonBorderLayer)
        updateButtonBottomLayerFrame(followButton, followButtonBorderLayer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        updateButtonBottomLayerFrame(snapButton, snapButtonBorderLayer)
        updateButtonBottomLayerFrame(followButton, followButtonBorderLayer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 레이아웃이 완전히 설정된 후에 레이어의 프레임을 업데이트
        updateButtonBottomLayerFrame(snapButton, snapButtonBorderLayer)
        updateButtonBottomLayerFrame(followButton, followButtonBorderLayer)

    }

    private func setViewConfig() {
        setTopView()
        setTopRadiusView()
        setEditButton()

        // 페이징
        setupPages()
        setupButtons()
        setupPageViewController()
        setupSeparatorLine()
        setupButtonBorderLayers()

        // 초기 선택된 버튼의 레이어를 표시
        updateButtonSelection(selectedIndex: 0)
    }

    private func setupPages() {
        let page1 = MySnapVC()

        let page2 = MyPostsVC()

        pages.append(page1)
        pages.append(page2)
    }

    private func setupButtons() {
        snapButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        followButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)

        stackView = UIStackView(arrangedSubviews: [snapButton, followButton])
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
            make.top.equalTo(editButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().dividedBy(2).offset(20)
            make.height.equalTo(60)
        }
    }

    private func setEditButton() {
        editButton.addTarget(self, action: #selector(tapEditButton), for: .touchUpInside)
        view.addSubview(editButton)

        editButton.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(topView)
            $0.height.equalTo(40)
        }
    }

    private func setTopView() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2

        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.height.equalTo(64)
            make.leading.equalToSuperview().offset(20)
        }

        view.addSubview(label)
        view.addSubview(bodyLabel)
        view.addSubview(contentLabel)
        label.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.centerY).offset(-5)
            make.leading.equalTo(imageView.snp.trailing).offset(15)
        }

        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.centerY).offset(5)
            make.leading.equalTo(imageView.snp.trailing).offset(15)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
    }

    private func setTopRadiusView() {
        topView.backgroundColor = UIColor(hex: "#F7F7F7")
        topView.layer.cornerRadius = 4
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }

        let topStackView = createStackView(axis: .horizontal, distribution: .fill)
        topView.addSubview(topStackView)
        topStackView.snp.makeConstraints { $0.edges.equalToSuperview() }

        let verticalViews = [UIStackView(), UIStackView(), UIStackView()]
        for (index, verticalView) in verticalViews.enumerated() {
            setupVerticalView(verticalView, in: topStackView)
            addLabels(to: verticalView, index: index)
        }
    }

    private func createStackView(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.distribution = distribution
        return stackView
    }

    private func setupVerticalView(_ verticalView: UIStackView, in stackView: UIStackView) {
        verticalView.axis = .vertical
        verticalView.spacing = 0
        verticalView.distribution = .fill
        verticalView.alignment = .center
        stackView.addArrangedSubview(verticalView)
        verticalView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(3)
        }
    }

    private func addLabels(to verticalView: UIStackView, index: Int) {
        let label1 = UILabel()
        label1.text = index == 0 ? "\(postsCount)" : (index == 1 ? "\(self.followerCount)" : "\(self.followingCount)" )
        label1.textColor = .black
        verticalView.addArrangedSubview(label1)

        let label2 = UILabel()
        label2.text = index == 0 ? "Posts" : (index == 1 ? "Followers" : "Following")
        label2.textColor = UIColor(hex: "#BCBDC0")
        verticalView.addArrangedSubview(label2)
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

    private func updateButtonBottomLayerFrame(_ button: UIButton, _ layer: CALayer) {
        layer.frame = CGRect(x: 0, y: button.frame.height - 3, width: button.frame.width, height: 3)
    }

    @objc private func tapEditButton() {
        let vc = MyProfileVC()
        vc.hidesBottomBarWhenPushed = true

        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func tabButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index >= 0 && index < pages.count else {
            return
        }
        pageViewController.setViewControllers([pages[index]], direction: .forward, animated: false, completion: nil)
        updateButtonSelection(selectedIndex: index)
    }

    private func updateButtonSelection(selectedIndex: Int) {
        snapButton.isSelected = selectedIndex == 0
        followButton.isSelected = selectedIndex == 1
        snapButtonBorderLayer.isHidden = !snapButton.isSelected
        followButtonBorderLayer.isHidden = !followButton.isSelected
    }

    // 버튼 layer
    private func setupButtonBorderLayers() {
        snapButtonBorderLayer.backgroundColor = UIColor.black.cgColor
        followButtonBorderLayer.backgroundColor = UIColor.black.cgColor

        let borderHeight: CGFloat = 3 // 테두리 높이
        snapButtonBorderLayer.frame = CGRect(x: 0, y: snapButton.frame.height - borderHeight, width: snapButton.frame.width, height: borderHeight)
        followButtonBorderLayer.frame = CGRect(x: 0, y: followButton.frame.height - borderHeight, width: followButton.frame.width, height: borderHeight)

        snapButton.layer.addSublayer(snapButtonBorderLayer)
        followButton.layer.addSublayer(followButtonBorderLayer)
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
