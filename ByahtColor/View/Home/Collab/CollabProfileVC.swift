//
//  SnapProfileVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/02/02.
//

import SnapKit
import UIKit
import Alamofire

class CollabProfileVC: UIViewController {

    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_profile2")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let nickname: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        return label
    }()

    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    private let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("UnFollow", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 4
        button.backgroundColor = .lightGray
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return button
    }()

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        return tableView
    }()

    private var postCount = 0
    private var followingCount = 0
    private var followerCount = 0
    private let topView = RadiusUIView()
    private var snapList: [CollabDto] = []
    var userDto: UserDto!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupBackButton()
        self.navigationItem.title = "Profile"

        profileImage.loadImage(from: userDto.image_path ?? "", resizedToWidth: 64)
        nickname.text = userDto.nickname
        bioLabel.text = userDto.bio
        bodyLabel.text = "\(userDto.height ?? 0)cm . \(userDto.weight ?? 0)kg"
        postCount = userDto.posts ?? 0
        followerCount = userDto.followers ?? 0
        followingCount = userDto.posts ?? 0
        loadData()
        self.setViewConfig()

    }

    private func setViewConfig() {
        setTopView()
        setTopRadiusView()
        setTableView()

    }

    private func setTopView() {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2

        view.addSubview(profileImage)
        view.addSubview(nickname)
        view.addSubview(bodyLabel)
        view.addSubview(bioLabel)

        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.height.equalTo(64)
            make.leading.equalToSuperview().offset(20)
        }

        nickname.snp.makeConstraints { make in
            make.bottom.equalTo(profileImage.snp.centerY).offset(-5)
            make.leading.equalTo(profileImage.snp.trailing).offset(15)
        }

        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.centerY).offset(5)
            make.leading.equalTo(profileImage.snp.trailing).offset(15)
        }

        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
    }

    private func setTopRadiusView() {
        topView.backgroundColor = UIColor(hex: "#F7F7F7")
        topView.layer.cornerRadius = 4
        view.addSubview(topView)
        view.addSubview(followButton)

        topView.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }

        followButton.addTarget(self, action: #selector(followTapped), for: .touchUpInside)
        followButton.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(34)
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
        label1.text = index == 0 ? "\(postCount)" : (index == 1 ? "\(followerCount)" : "\(followingCount)" )
        label1.textColor = .black
        verticalView.addArrangedSubview(label1)

        let label2 = UILabel()
        label2.text = index == 0 ? "Posts" : (index == 1 ? "Followers" : "Following")
        label2.textColor = UIColor(hex: "#BCBDC0")
        verticalView.addArrangedSubview(label2)
    }

    private func setTableView() {
        // 테이블 뷰 초기화 및 설정
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CollabProfileTableCell.self, forCellReuseIdentifier: "CollabProfileTableCell")

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(followButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

}

/// 기능 ///
extension CollabProfileVC: UITableViewDataSource, UITableViewDelegate, CollabProfileTableCellDelegate {
    // 테이블 뷰 데이터 소스 메서드: 섹션당 행의 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contentCount = snapList.count / 2
        return contentCount+1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSideLength = (UIScreen.main.bounds.width - 60) / 3 // 화면 너비에 따라 이미지 크기 계산
        let imageHeight = imageSideLength * 1.4
        let cellHeight = imageHeight
        return cellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀을 재사용 큐에서 가져옴
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollabProfileTableCell", for: indexPath) as! CollabProfileTableCell
        cell.selectionStyle = .none
        cell.delegate = self

        // 각 셀에 할당할 이미지 인덱스를 계산
        let firstImageIndex = indexPath.row * 3
        let secondImageIndex = firstImageIndex + 1
        let thirdImageIndex = firstImageIndex + 2

        // 셀에 할당할 이미지 배열 초기화
        var snapsForCell = [CollabDto]()

        // 첫 번째 Snap 추가
        if firstImageIndex < snapList.count {
            let firstData = snapList[firstImageIndex]
            snapsForCell.append(firstData)
        }
        // 두 번째 Snap 추가
        if secondImageIndex < snapList.count {
            let secondData = snapList[secondImageIndex]
            snapsForCell.append(secondData)
        }
        // 세 번째 Snap 추가
        if thirdImageIndex < snapList.count {
            let thirdData = snapList[thirdImageIndex]
            snapsForCell.append(thirdData)
        }

        // 셀의 이미지 뷰 설정 함수 호출
        cell.setupImageViews(list: snapsForCell)

        return cell
    }

    func didTapCell(_ cell: CollabProfileTableCell, withNo no: Int) {
        // no 값을 사용하여 해당 페이지를 전환
        let detailVC = CollabDetailVC()
        print("withNo : \(no)")
        if let selectedSnap = snapList.first(where: { $0.no == no }) {
            detailVC.snapList.append(selectedSnap)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    private func loadData() {
        let url = "\(Bundle.main.TEST_URL)/mypage/snap/select"

        // 요청에 필요한 파라미터 설정
        let parameters: [String: Any] = ["followerId": userDto.id, "user_id": User.shared.id ?? 0]

        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [CollabDto].self) { response in
            switch response.result {
            case .success(let snapVo):
                self.snapList = snapVo
                self.updateUI()

            case .failure(let error):
                self.log(message: "Error snapList: \(error)")
            }
        }
    }

    private func updateUI() {
        // UI 업데이트를 메인 스레드에서 수행
        DispatchQueue.main.async {
            // 여기에서 테이블 뷰 리로드 또는 다른 UI 업데이트 수행
            self.tableView.reloadData()
        }
    }

    @objc private func followTapped() {
        followButton.isSelected = !followButton.isSelected
        let follower_id = self.userDto.id ?? ""
        if followButton.isSelected {
            self.updateUnFollow(follower_id: follower_id)
        } else {
            self.updateFollow(follower_id: follower_id)
        }
    }

    private func updateFollow(follower_id: String) {
        let url = "\(Bundle.main.TEST_URL)/follow"

        // 요청에 필요한 파라미터 설정follower_id
        let parameters: [String: Any] = ["follower_id": follower_id, "followee_id": User.shared.id ?? ""]
        AF.request(url, method: .post, parameters: parameters)
            .response { [weak self] response in
                switch response.result {
                case .success(let data):
                    // 요청 성공 처리
                    self?.followButton.setTitle("UnFollow", for: .normal)
                    self?.followButton.backgroundColor = .lightGray
                    self?.followerCount += 1

                case .failure(let error):
                    // 요청 실패 처리
                    self?.log(message: "Error in like request: \(error)")
                }
            }
    }

    private func updateUnFollow(follower_id: String) {
        let url = "\(Bundle.main.TEST_URL)/follow"

        // 요청에 필요한 파라미터 설정
        let parameters: [String: Any] = ["follower_id": follower_id, "followee_id": User.shared.id ?? ""]
        AF.request(url, method: .delete, parameters: parameters)
            .response { [weak self] response in
                switch response.result {
                case .success(let data):
                    self?.followButton.setTitle("Follow", for: .normal)
                    self?.followButton.backgroundColor = .black
                    self?.followerCount -= 1

                case .failure(let error):
                    self?.log(message: "Error in like request: \(error)")
                }
            }
    }
}
