//
//  TestResultView3.swift
//  ByahtColor
//
//  Created by jaem on 2023/12/28.
//

import UIKit
import SnapKit
import Alamofire

class TestResultView3: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let cardView = UIView()
    private let imageView = UIImageView()
    private let seasonLabel = UILabel()
    private let nextButton = NextButton()
    private let buttonStackView = UIStackView()
    private let shareButton = UIButton()
    private let installButton = UIButton()
    private let bottomView = UIView()
    private let bottomViewLabel = UILabel()
    private let scrollView = UIScrollView()
    private var magazineList: [UIImage] = []
    var seasonTon = ""
    var receiveImage: UIImage?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupViews()
//        setupConstraints()
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        view.backgroundColor = .white
//
//        // 처음으로 버튼
//        if User.shared.color != ""{
//            setupPopButton4()
//        } else {
//            setupPopButton3()
//        }
//
//        self.navigationItem.title = "Personal Color"
//    }
//
//    private func setupViews() {
//        setupImageView()
//        setButtonView()
//        setupBottomView()
//        setupScrollView()
//    }
//
//    private func setupScrollView() {
//        let magazineButton = UIButton()
//        magazineButton.layer.cornerRadius = 4
//        magazineButton.layer.borderWidth = 1
//        magazineButton.layer.borderColor = UIColor(hex: "#BCBDC0").cgColor
//        magazineButton.setTitle("Xem thêm tạp chí 👀", for: .normal)
//        magazineButton.setTitleColor(.black, for: .normal)
//        magazineButton.backgroundColor = .white
//        magazineButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
//        magazineButton.addTarget(self, action: #selector(magazineTapped), for: .touchUpInside)
//        bottomView.addSubview(magazineButton)
//        magazineButton.snp.makeConstraints {
//            $0.top.equalTo(bottomViewLabel.snp.bottom).offset(20)
//            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.height.equalTo(40)
//        }
//
//        let snapButton = UIButton()
//        snapButton.layer.cornerRadius = 4
//        snapButton.layer.borderWidth = 1
//        snapButton.layer.borderColor = UIColor(hex: "#BCBDC0").cgColor
//        snapButton.setTitle("Xem thêm Snap 🕶️", for: .normal)
//        snapButton.setTitleColor(.black, for: .normal)
//        snapButton.backgroundColor = .white
//        snapButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
//        snapButton.addTarget(self, action: #selector(snapTapped), for: .touchUpInside)
//        bottomView.addSubview(snapButton)
//        snapButton.snp.makeConstraints {
//            $0.top.equalTo(magazineButton.snp.bottom).offset(10)
//            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.height.equalTo(40)
//        }
//
////        scrollView.showsHorizontalScrollIndicator = false
////        scrollView.isUserInteractionEnabled = true
////        // 가로로 아이템들을 정렬할 UIStackView 생성
////        let stackView = UIStackView()
////        stackView.axis = .horizontal
////        stackView.spacing = 8 // 원하는 간격 설정
////        stackView.alignment = .fill
////        stackView.distribution = .fillEqually
////        stackView.isUserInteractionEnabled = true
////        // 스택 뷰를 스크롤 뷰에 추가
////        scrollView.addSubview(stackView)
////
////        // 스택 뷰에 아이템 뷰들을 추가
////        for i in 0..<magazineList.count { // 예시로 5개의 뷰를 추가
////            let itemView = UIImageView()
////            itemView.image = magazineList[i]
////            itemView.contentMode = .scaleAspectFit
////            itemView.backgroundColor = .lightGray // 색상은 예시입니다.
////            itemView.layer.cornerRadius = 10 // 모서리 둥글기
////            itemView.clipsToBounds = true
////            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(magazineTapped))
////            itemView.addGestureRecognizer(tapGesture)
////            itemView.isUserInteractionEnabled = true
////            stackView.addArrangedSubview(itemView)
////
////            itemView.snp.makeConstraints { make in
////                make.width.equalTo(120) // 너비는 고정값으로 설정
////                make.height.equalTo(120) // 높이는 스크롤 뷰와 동일하게 설정
////            }
////        }
////
////        // 뷰에 스크롤 뷰 추가
////        view.addSubview(scrollView)
////        view.isUserInteractionEnabled = true
////        // 스택 뷰의 제약 조건 설정
////        stackView.snp.makeConstraints { make in
////            make.top.bottom.equalTo(scrollView)
////            make.leading.trailing.equalTo(scrollView.contentLayoutGuide) // 스크롤 가능한 콘텐츠 영역에 스택 뷰를 맞춤
////            // 스택 뷰의 높이를 스크롤 뷰의 높이와 동일하게 설정
////            make.height.equalTo(scrollView)
////        }
////
////        // 스크롤 뷰의 제약 조건 설정
////        scrollView.snp.makeConstraints { make in
////            make.top.equalTo(bottomViewLabel.snp.bottom).offset(20)
////            make.leading.trailing.equalToSuperview().inset(20)
////            make.bottom.equalTo(view.snp.bottom).inset(20) // 스크롤 뷰의 높이 설정
////        }
//    }
//
//    private func setupBottomView() {
//        bottomView.backgroundColor = .white
//        bottomView.layer.cornerRadius = 20
//        cardView.addSubview(bottomView)
//
//        bottomViewLabel.text = "Bài viết liên quan"
//        bottomViewLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
//        bottomView.addSubview(bottomViewLabel)
//        bottomViewLabel.snp.makeConstraints { make in
//            make.top.leading.equalToSuperview().offset(20)
//        }
//    }
//
//    private func setButtonView() {
//
//        buttonStackView.axis = .horizontal
//        buttonStackView.spacing = 5
//        buttonStackView.distribution = .fill
//        buttonStackView.alignment = .fill
//        buttonStackView.backgroundColor = UIColor(hex: "#F4F5F8")
//
//        nextButton.setTitle("Lưu", for: .normal)
//        nextButton.addTarget(self, action: #selector(buttonNextTapped), for: .touchUpInside)
//
//        shareButton.setImage(UIImage(named: "icon_shared"), for: .normal)
//        shareButton.imageView?.contentMode = .scaleAspectFit
//        shareButton.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
//        installButton.setImage(UIImage(named: "icon_install"), for: .normal)
//        installButton.imageView?.contentMode = .scaleAspectFit
//        installButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
//
//        buttonStackView.addArrangedSubview(nextButton)
//        buttonStackView.addArrangedSubview(shareButton)
//        buttonStackView.addArrangedSubview(installButton)
//
//        nextButton.snp.makeConstraints { make in
//            make.width.equalTo(buttonStackView.snp.width).multipliedBy(0.7)
//
//        }
//
//        shareButton.snp.makeConstraints { make in
//            make.width.equalTo(buttonStackView.snp.width).multipliedBy(0.15)
//        }
//
//        installButton.snp.makeConstraints { make in
//            make.width.equalTo(buttonStackView.snp.width).multipliedBy(0.15)
//
//        }
//        cardView.addSubview(buttonStackView)
//    }
//
//    @objc private func saveImage() {
//        // 이미지 컨텍스트를 시작합니다.
//        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, UIScreen.main.scale)
//
//        // 이미지 뷰의 레이어를 컨텍스트에 렌더링합니다.
//        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
//
//        // 이미지 컨텍스트로부터 이미지를 생성합니다.
//        guard let fullImage = UIGraphicsGetImageFromCurrentImageContext() else {
//            UIGraphicsEndImageContext()
//            return
//        }
//
//        // 이미지 컨텍스트를 종료합니다.
//        UIGraphicsEndImageContext()
//
//        // 생성된 이미지를 사진 앨범에 저장합니다.
//        UIImageWriteToSavedPhotosAlbum(fullImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
//    }
//
//    @objc private func shareImage() {
//        // imageView에서 이미지를 가져옵니다.
//        guard let imageToShare = imageView.image else { return }
//        // 공유 액티비티 뷰 컨트롤러를 설정합니다.
//        let activityController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
//        // iPad에서는 popover로 표시해야 합니다.
//        if let popoverController = activityController.popoverPresentationController {
//            popoverController.sourceView = self.view // 버튼의 뷰를 sourceView로 설정할 수 있습니다.
//        }
//        // 액티비티 뷰 컨트롤러를 표시합니다.
//        self.present(activityController, animated: true, completion: nil)
//    }
//
//    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
//        // 저장이 완료되면 사용자에게 알립니다.
//        if let error = error {
//            // 에러가 있을 경우
//            let alert = UIAlertController(title: "저장 실패", message: error.localizedDescription, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "확인", style: .default))
//            present(alert, animated: true)
//        } else {
//            // 저장에 성공했을 경우
//            let alert = UIAlertController(title: "저장 성공", message: "이미지가 사진 앨범에 저장되었습니다.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "확인", style: .default))
//            present(alert, animated: true)
//        }
//    }
//
//    private func setupImageView() {
//        cardView.backgroundColor = UIColor(hex: "#F4F5F8")
//        view.addSubview(cardView)
//
//        let imageName = seasonTon.replacingOccurrences(of: " ", with: "")
//        print(imageName)
//        imageView.image = UIImage(named: "\(imageName)")
//        imageView.contentMode = .scaleAspectFit
//        cardView.addSubview(imageView)
//
//    }
//
//    @objc private func buttonNextTapped() {
//        if User.shared.color != ""{
//            let customAlertVC = CustomAlertViewController2()
//            customAlertVC.modalPresentationStyle = .overCurrentContext
//            customAlertVC.modalTransitionStyle = .crossDissolve
//
//            customAlertVC.onSuccess = {
//                User.shared.updateColor(color: self.seasonTon)
//                let url = Bundle.main.TEST_URL + "/color/update"
//                AF.request(url, method: .post, parameters: User.shared, encoder: JSONParameterEncoder.default).response { response in
//                    switch response.result {
//                    case .success:
//                        print("데이터 전송 성공")
//
//                    case .failure(let error):
//                        print("오류 발생: \(error)")
//
//                    }
//                }
//            }
//
//            self.present(customAlertVC, animated: true, completion: nil)
//        } else {
//            User.shared.updateColor(color: seasonTon)
//            let url = Bundle.main.TEST_URL + "/color/update"
//            AF.request(url, method: .post, parameters: User.shared, encoder: JSONParameterEncoder.default).response { response in
//                switch response.result {
//                case .success:
//                    print("데이터 전송 성공")
//
//                case .failure(let error):
//                    print("오류 발생: \(error)")
//
//                }
//            }
//
//        }
//
//    }
//
//    private func setupConstraints() {
//
//        cardView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide)
//            make.bottom.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//        }
//
//        imageView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().inset(20)
//        }
//
//        buttonStackView.snp.makeConstraints { make in
//            make.top.equalTo(imageView.snp.bottom).offset(20)
//            make.centerX.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.9)
//            make.height.equalTo(50)
//        }
//
//        bottomView.snp.makeConstraints { make in
//            make.top.equalTo(buttonStackView.snp.bottom).offset(10)
//            make.bottom.leading.trailing.equalToSuperview()
//        }
//
//    }
//
//    @objc private func magazineTapped() {
//        self.tabBarController?.selectedIndex = 2
//    }
//
//    @objc private func snapTapped() {
//        self.tabBarController?.selectedIndex = 1
//    }
}
