//
//  MainView.swift
//  ByahtColor
//
//  Created by jaem on 2023/12/20.
//

import SkeletonView
import SnapKit
import UIKit
import Alamofire
import AlamofireImage
import FirebaseMessaging

class MainView: UIViewController, UIScrollViewDelegate {
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//    private let logoImageView = UIImageView()
//    private let discountImageView = UIImageView()
//    private let mainView = UIScrollView()
//    private let colorButton = UIButton()
//    private let snapLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Hôm nay\nmặc gì nhỉ?"
//        label.numberOfLines = 2
//        label.font = UIFont(name: "Pretendard-SemiBold", size: 24)
//        return label
//    }()
//    private let snapButton: UIButton = {
//        let button = UIButton()
//        button.tag = 0
//        button.setTitle("More >", for: .normal)
//        button.setTitleColor(UIColor(hex: "#535358"), for: .normal)
//        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
//        return button
//    }()
//    private let magazineButton: UIButton = {
//        let button = UIButton()
//        button.tag = 1
//        button.setTitle("More >", for: .normal)
//        button.setTitleColor(UIColor(hex: "#535358"), for: .normal)
//        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
//        return button
//    }()
//    private let snapView = UITableView()
//    private let magazineLabel: UILabel = {
//        let label = UILabel()
//        label.text = "tạp chí thời trang"
//        label.font = UIFont(name: "Pretendard-SemiBold", size: 24)
//        return label
//    }()
//    let imageContainerView = UIView()
//    private var contentHeight: CGFloat = 0
//    private var snapList: [CollabDto] = []
//    private let magazineScrollView = UIScrollView()
//    private var xOffset: CGFloat = 10
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        snapImageLoad {
//            self.configureView()
//        }
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        changeStatusBarBgColor(bgColor: .white)
//
//        // 로고 이미지 설정
//        logoImageView.image = UIImage(named: "logo2")
//        logoImageView.contentMode = .scaleAspectFit
//
//        // 컨테이너 뷰 생성
//        let containerView = UIView()
//
//        // 로고 이미지뷰의 크기 및 위치 조정
//        logoImageView.frame = CGRect(x: 10, y: 5, width: 60, height: 30) // Y 좌표는 세로 중앙 정렬을 위해 조정할 수 있음
//        containerView.addSubview(logoImageView)
//
//        // 컨테이너 뷰의 크기를 로고 이미지뷰 크기에 맞게 조정
//        containerView.frame = CGRect(x: 0, y: 0, width: logoImageView.frame.maxX + 20, height: 40) // 로고 오른쪽 여백 추가
//
//        // 컨테이너 뷰를 사용하여 UIBarButtonItem 생성
//        let barButtonItem = UIBarButtonItem(customView: containerView)
//        navigationItem.leftBarButtonItem = barButtonItem
//        navigationItem.title = ""
//
//        if #available(iOS 13.0, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = .clear // 원하는 배경색 설정
//            appearance.shadowColor = nil // 선을 없애기 위해 추가
//            // 네비게이션 바 타이틀과 아이템 색상 설정 (옵션)
//            appearance.titleTextAttributes = [.foregroundColor: UIColor.black] // 타이틀 색상
//            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black] // 대형 타이틀 색상
//
//            // appearance 적용
//            navigationController?.navigationBar.standardAppearance = appearance
//            navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        }
//
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        let height = view.frame.width * 3
//        mainView.contentSize = CGSize(width: view.frame.width, height: height)
//
//    }
//
//    private func configureView() {
//        view.backgroundColor = UIColor(hex: "#F4F5F8")
//        configureMainView()
//        configureDiscountImageView()
//        setColorView()
//        setSnapView()
//        setMagazineView()
//    }
//
//    private func setSnapView() {
//
//        snapButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//        mainView.addSubview(snapLabel)
//        mainView.addSubview(snapButton)
//        snapLabel.snp.makeConstraints {
//            $0.top.equalTo(colorButton.snp.bottom).offset(20)
//            $0.leading.equalToSuperview().offset(20)
//        }
//
//        snapButton.snp.makeConstraints {
//            $0.bottom.equalTo(snapLabel.snp.bottom)
//            $0.trailing.equalToSuperview().offset(-20)
//        }
//
//        // 이미지를 담을 컨테이너 뷰 생성
//
//        mainView.addSubview(imageContainerView)
//        let imageSideLength = (UIScreen.main.bounds.width - 60) / 3 // 화면 너비에 따라 이미지 크기 계산
//        let imageHeight = imageSideLength * 1.4
//        let height = imageHeight * 3 + 20
//        imageContainerView.snp.makeConstraints {
//            $0.top.equalTo(snapButton.snp.bottom).offset(20)
//            $0.leading.equalToSuperview().offset(20)
//            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.height.equalTo(height)
//        }
//
//        // 이미지 뷰들을 컨테이너 뷰에 추가
//
//        for i in 0..<snapList.count {
//            let row = i / 3
//            let column = i % 3
//            let imageView = UIImageView()
//
//            let path: String = snapList[i].imageList?.first ?? ""
//            let url = "\(Bundle.main.TEST_URL)/image\( path )"
//            DispatchQueue.main.async {
//                imageView.loadImage(from: url, resizedToWidth: imageSideLength)
//            }
//
//            imageView.backgroundColor = .white
//            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
//            imageView.isUserInteractionEnabled = true
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(snapImageTapped(_:)))
//            imageView.addGestureRecognizer(tapGesture)
//            imageView.tag = i
//            imageContainerView.addSubview(imageView)
//
//            imageView.snp.makeConstraints {
//                $0.width.equalTo(imageSideLength)
//                $0.height.equalTo(imageHeight)
//                $0.top.equalToSuperview().offset(CGFloat(row) * (imageHeight + 10)) // 세로 간격 추가
//                $0.leading.equalToSuperview().offset(CGFloat(column) * (imageSideLength + 10)) // 가로 간격 추가
//            }
//            let isliked = snapList[i].isLiked
//            let icon = UIButton()
//            if isliked ?? false {
//                icon.setImage(UIImage(named: "like_icon2"), for: .normal)
//            } else {
//                icon.setImage(UIImage(named: "icon_heart3"), for: .normal)
//            }
//
//            icon.imageView?.contentMode = .scaleAspectFit
//            imageView.addSubview(icon)
//            icon.tag = snapList[i].no ?? 0
//            icon.isUserInteractionEnabled = true
//            icon.addTarget(self, action: #selector(heartTappedButton), for: .touchUpInside)
//            icon.snp.makeConstraints {
//                $0.width.height.equalTo(24)
//                $0.top.equalToSuperview().offset(10)
//                $0.trailing.equalToSuperview().offset(-10)
//            }
//
//        }
//    }
//
//    private func setMagazineView() {
//        magazineButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//        mainView.addSubview(magazineLabel)
//        magazineLabel.snp.makeConstraints {
//            $0.top.equalTo(imageContainerView.snp.bottom).offset(20)
//            $0.leading.equalToSuperview().offset(20)
//        }
//
//        mainView.addSubview(magazineButton)
//        magazineButton.snp.makeConstraints {
//            $0.bottom.equalTo(magazineLabel.snp.bottom)
//            $0.trailing.equalToSuperview().offset(-20)
//        }
//
//        let imageWidth: CGFloat = view.frame.width - 40  // 이미지 너비 설정
//
//           magazineScrollView.showsHorizontalScrollIndicator = false
//           magazineScrollView.isScrollEnabled = true
//
//           mainView.addSubview(magazineScrollView)
//           magazineScrollView.snp.makeConstraints {
//               $0.top.equalTo(magazineLabel.snp.bottom).offset(20)
//               $0.leading.equalToSuperview()
//               $0.trailing.equalToSuperview()
//               $0.height.equalTo(imageWidth)  // 스크롤 뷰의 높이 설정
//           }
//
//        var lastImageView: UIImageView?
//        var imageSpacing = 10
//        let images = appDelegate.magazineImageList
//
//        for image in images {
//            let imageView = UIImageView()
//            imageView.image = image
//            imageView.layer.cornerRadius = 4
//            imageView.clipsToBounds = true
//            imageView.contentMode = .scaleAspectFit  // 이미지 콘텐츠 모드 설정
//
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(magazineTapped))
//            imageView.addGestureRecognizer(tapGesture)
//            imageView.isUserInteractionEnabled = true
//            magazineScrollView.addSubview(imageView)
//
//            imageView.snp.makeConstraints { make in
//                if let lastImageView = lastImageView {
//                    // 첫 번째 이미지가 아닌 경우, 이전 이미지 뷰의 trailing에 맞춥니다.
//                    make.leading.equalTo(lastImageView.snp.trailing).offset(imageSpacing)
//                } else {
//                    // 첫 번째 이미지의 경우, 스크롤 뷰의 leading에 맞춥니다.
//                    make.leading.equalToSuperview().offset(imageSpacing)
//                }
//                make.top.equalToSuperview()
//                make.height.equalTo(imageWidth)
//                make.width.equalTo(imageWidth)
//            }
//
//            // 마지막 이미지 뷰 업데이트
//            lastImageView = imageView
//        }
//
//        // 마지막 이미지 뷰의 trailing을 스크롤 뷰의 trailing에 맞추어야 합니다.
//        if let lastImageView = lastImageView {
//            lastImageView.snp.makeConstraints { make in
//                make.trailing.equalToSuperview().offset(-imageSpacing)
//            }
//        }
//
//    }
//
//    private func setColorView() {
//        colorButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
//        colorButton.backgroundColor = .white
//        colorButton.layer.cornerRadius = 16
//        mainView.addSubview(colorButton)
//        colorButton.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.leading.equalToSuperview().offset(20)
//            $0.trailing.equalToSuperview().offset(-20)
//            $0.top.equalTo(discountImageView.snp.bottom).offset(10)
//            $0.height.equalTo(72)
//        }
//
//        let icon = UIImageView(image: UIImage(named: "icon_palette"))
//        icon.contentMode = .scaleAspectFit
//        colorButton.addSubview(icon)
//        icon.snp.makeConstraints {
//            $0.width.height.equalTo(40)
//            $0.leading.equalToSuperview().offset(10)
//            $0.centerY.equalToSuperview()
//        }
//
//        let label1 = UILabel()
//        label1.text = "Personal color test"
//        label1.font = UIFont(name: "Pretendard-SemiBold", size: 16)
//
//        let label2 = UILabel()
//        label2.text = "Find my own season color type"
//        label2.font = UIFont(name: "Pretendard-Regular", size: 14)
//        label2.textColor = UIColor(hex: "#676975")
//
//        colorButton.addSubview(label1)
//        colorButton.addSubview(label2)
//
//        label1.snp.makeConstraints {
//            $0.top.equalTo(icon)
//            $0.leading.equalTo(icon.snp.trailing).offset(10)
//        }
//
//        label2.snp.makeConstraints {
//            $0.top.equalTo(label1.snp.bottom)
//            $0.leading.equalTo(icon.snp.trailing).offset(10)
//        }
//    }
//
//    private func configureMainView() {
//        // 메인 스크롤 뷰
//        mainView.delegate = self
//        mainView.showsVerticalScrollIndicator = true
//        mainView.isUserInteractionEnabled = true
//        mainView.isScrollEnabled = true
//
//        view.addSubview(mainView)
//
//        mainView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//
//        }
//
//    }
//
//    private func configureDiscountImageView() {
//        let image = UIImage(named: "banner")
//        let width = UIScreen.main.bounds.width - 40
//        discountImageView.image = image?.resized(toWidth: width)
//        discountImageView.contentMode = .scaleToFill
//        discountImageView.clipsToBounds = true
//        mainView.addSubview(discountImageView)
//
//        discountImageView.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalTo(mainView)
//            $0.width.equalTo(width)
//            $0.height.equalTo(width/6)
//        }
//    }
//
//    @objc private func colorButtonTapped() {
//        let vc = PersonalColorHomeView()
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    private func snapImageLoad(completion: @escaping () -> Void) {
//        let url = "\(Bundle.main.TEST_URL)/main/snap"
//
//        // 요청에 필요한 파라미터 설정
//        let parameters: [String: Any] = ["user_id": User.shared.id ?? ""]
//
//        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [CollabDto].self) { [weak self] response in
//            guard let self = self else { return }
//
//            switch response.result {
//            case .success(let snapVo):
//                // 성공적으로 데이터를 받아왔을 때
//
//                self.snapList = snapVo
//
//                // UI 작업을 메인 스레드에서 수행
//                DispatchQueue.main.async {
//                    // 다른 뷰들을 그리는 작업 또는 화면 전환 작업을 수행
//                    print("snapList.count : \(snapVo.count)")
//
//                    // completion handler 호출
//                    completion()
//                }
//
//            case .failure(let error):
//                // 요청 실패 또는 디코딩 실패
//                print("Error snapList: \(error)")
//                completion()
//
//            }
//        }
//    }
//
//    @objc private func heartTappedButton(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        print("sender.tag : \(sender.tag)")
//
//        let userId: String = User.shared.id ?? ""
//        let likeRequestDto = LikeDto(user_id: userId, snap_id: sender.tag )
//        // 상태에 따른 이미지 변경
//        if sender.isSelected {
//            sender.setImage(UIImage(named: "like_icon2"), for: .normal)
//            sendLikeRequest(likeRequestDto: likeRequestDto)
//        } else {
//            sender.setImage(UIImage(named: "icon_heart3"), for: .normal)
//            sendUnlikeRequest(likeRequestDto: likeRequestDto)
//        }
//    }
//
//    private func sendUnlikeRequest(likeRequestDto: LikeDto) {
//        let url = "\(Bundle.main.TEST_URL)/snap/like"
//        AF.request(url, method: .delete, parameters: likeRequestDto, encoder: JSONParameterEncoder.default)
//            .response { response in
//                switch response.result {
//                case .success(let data):
//                    // 요청 성공 처리
//                    print("Like request successful")
//                case .failure(let error):
//                    // 요청 실패 처리
//                    print("Error in like request: \(error)")
//                }
//            }
//    }
//
//    private func sendLikeRequest(likeRequestDto: LikeDto) {
//        let url = "\(Bundle.main.TEST_URL)/snap/like"
//        AF.request(url, method: .post, parameters: likeRequestDto, encoder: JSONParameterEncoder.default)
//            .response { response in
//                switch response.result {
//                case .success(let data):
//                    // 요청 성공 처리
//                    print("Like request successful")
//                case .failure(let error):
//                    // 요청 실패 처리
//                    print("Error in like request: \(error)")
//                }
//            }
//    }
//
//    @objc func snapImageTapped(_ sender: UITapGestureRecognizer) {
//
//        if let tappedImageView = sender.view as? UIImageView {
//               let imageIndex = tappedImageView.tag
//            let vc = CollabDetailVC()
//            vc.snapList.append(snapList[imageIndex])
//            self.navigationController?.pushViewController(vc, animated: true)
//           }
//
//       }
//
//    @objc private func buttonTapped(_ sender: UIButton) {
//        switch sender.tag {
//        case 0:
//            self.tabBarController?.selectedIndex = 1
//        case 1:
//            self.tabBarController?.selectedIndex = 2
//        default:
//            self.tabBarController?.selectedIndex = 1
//        }
//
//    }
//
//    @objc private func magazineTapped() {
//        self.tabBarController?.selectedIndex = 2
//    }
}
