//
//  UserInfluenceVC.swift
//  ByahtColor
//
//  Created by jaem on 6/19/24.
//

import UIKit
import SnapKit
import SkeletonView
import FirebaseMessaging

class InfluenceHomeVC: UIViewController, UIScrollViewDelegate {

    private let logoImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "logo"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let topView = UIView()
    private let bottomView = UIView()
    private let topLabel = UILabel()
    private let topButton = UIButton()
    private let viewModel = InfluenceViewModel()
    private var collabList: [CollabDto] = []
    private var businessList: [BusinessDto] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleAccountUpdatedInHome), name: .dataChanged, object: nil)
    
    }

    @objc private func handleAccountUpdatedInHome(notification: NSNotification) {
        // 프로필 작성 뷰로 전환
        let profileWriteVC = InfluenceProfileWriteVC()
        profileWriteVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(profileWriteVC, animated: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .dataChanged, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupHomeData()
        setupUI()
        let nickname = User.shared.name ?? ""
        let homeValue = UserDefaults.standard.integer(forKey: "home")
        if User.shared.name == nil || User.shared.name == "" || nickname.contains("user"){
            setupOnboardingView()
        }
        
        if let assetId = User.shared.id {
            Messaging.messaging().subscribe(toTopic: assetId) { _ in
                self.log(message: "Subscribed to MediaConvertFCM \(assetId)")
            }
        }
        
        if homeValue != 1 && User.shared.id != "122101478408205849"{
            setupAlertView()
        }

    }

    private func setupAlertView() {
        let alertVC = RegistAlertVC()
        alertVC.onConfirm = {
            let vc = InfluenceProfileWriteVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
        }
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true, completion: nil)
    }
    
    private func setupOnboardingView() {
        let exampleVC = InfluenceOnboardingVC()
        exampleVC.modalPresentationStyle = .overFullScreen
        exampleVC.modalTransitionStyle = .crossDissolve
        present(exampleVC, animated: true, completion: nil)
    }

    private func setupHomeData() {
        if let id = User.shared.id {
            let nation = User.shared.nation ?? nil
            viewModel.getHomeData(nation: nation ) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self?.collabList = data.snapDtoList ?? []
                        self?.businessList = data.businessDtos ?? []

                        self?.setupUI()
                        self?.setupConstraints()
                    case .failure(let error):
                        print("통신 에러 : \(error)")
                        self?.setupUI()
                        self?.setupConstraints()
                    }
                }
            }
        }
    }

    // UI 컴포넌트를 구성하는 메소드
    private func setupUI() {
        view.addSubview(logoImage)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.isUserInteractionEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        setupTopView()
        setupBottomView()
        setupConstraints()
    }

    private func setupTopView() {
        contentView.addSubview(topView)
        topView.isUserInteractionEnabled = true
        let label1 = UILabel()
        label1.text = "influencehome_label1".localized
        label1.font = UIFont(name: "Pretendard-Regular", size: 14)
        label1.textColor = UIColor(hex: "#4E505B")

        let label2 = UILabel()
        label2.text = "influencehome_label2".localized
        label2.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label2.numberOfLines = 0
        label2.textColor = .black
        label2.setLineSpacing(lineSpacing: 4)

        let button = UIButton()
        button.setTitle("influencehome_button".localized, for: .normal)
        button.setTitleColor(UIColor(hex: "#009BF2"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.backgroundColor = .white
        button.tag = 0
        button.addTarget(self, action: #selector(snapButtonTapped), for: .touchUpInside)

        let horizontalScrollView = UIScrollView()
        horizontalScrollView.showsHorizontalScrollIndicator = false
        horizontalScrollView.isUserInteractionEnabled = true

        let horizontalContentView = UIView()
        horizontalContentView.isUserInteractionEnabled = true

        var previousImageView: UIImageView?

        for (index, collab) in collabList.enumerated() {
            let imageView = UIImageView()
            if let resource = collab.imageList?.first {
                let url = "\(Bundle.main.TEST_URL)/image\( resource )"
                imageView.loadImage(from: url)
            } else {
                DispatchQueue.main.async {
                    imageView.backgroundColor = .lightGray
                }
            }

            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.tag = index
            imageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(collabTapped(_:)))
            imageView.addGestureRecognizer(tapGesture)
            horizontalContentView.addSubview(imageView)

            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(286)
                if let previousImageView = previousImageView {
                    make.leading.equalTo(previousImageView.snp.trailing).offset(10)
                } else {
                    make.leading.equalToSuperview()
                }
            }
            previousImageView = imageView
        }

        if let previousImageView = previousImageView {
            previousImageView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-10)
            }
        }

        topView.addSubview(label1)
        topView.addSubview(label2)
        topView.addSubview(button)
        topView.addSubview(horizontalScrollView)
        horizontalScrollView.addSubview(horizontalContentView)

        horizontalScrollView.snp.makeConstraints {
            $0.top.equalTo(button.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(286)
            $0.bottom.equalToSuperview()
        }

        horizontalContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }

        label1.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(20)
        }

        label2.snp.makeConstraints {
            $0.top.equalTo(label1.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        button.snp.makeConstraints {
            $0.bottom.equalTo(label2.snp.bottom).offset(4)
            $0.trailing.equalToSuperview()
        }

    }

    @objc private func snapButtonTapped() {
        let vc = CollabVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // 기업
    private func setupBottomView() {
        contentView.addSubview(bottomView)
        contentView.isUserInteractionEnabled = true
        bottomView.isUserInteractionEnabled = true

        let label = UILabel()
        label.text = "influencehome_label3".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.numberOfLines = 0
        label.textColor = .black
        label.setLineSpacing(lineSpacing: 4)

        let button = UIButton()
        button.setTitle("influencehome_button".localized, for: .normal)
        button.setTitleColor(UIColor(hex: "#009BF2"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(swipeButtonTapped), for: .touchUpInside)
        button.tag = 0

        let verticalView = UIStackView()
        verticalView.axis = .vertical
        verticalView.spacing = 4
        verticalView.distribution = .fillEqually
        verticalView.isUserInteractionEnabled = true

        var currentStackView: UIStackView?

        for (index, business) in businessList.enumerated() {
            if index < 4 {
                let imageView = GradientImageView(frame: .zero)
                print("business.imagePath : \(business.imagePath)")
                if let resource = business.imagePath {
                    let url = "\(Bundle.main.TEST_URL)/business\( resource )"
                    print("resource : \(resource)")
                    imageView.loadImage(from: resource)
                } else {
                    imageView.image = UIImage(named: "sample_business_image")
                }
                imageView.layer.borderWidth = 1
                imageView.layer.borderColor = UIColor(hex: "#E5E6EA").cgColor
                imageView.isUserInteractionEnabled = true
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
                imageView.tag = index

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
                imageView.addGestureRecognizer(tapGesture)

                if index % 2 == 0 {
                    currentStackView = UIStackView()
                    currentStackView?.axis = .horizontal
                    currentStackView?.distribution = .fillEqually
                    currentStackView?.spacing = 4
                    currentStackView?.isUserInteractionEnabled = true
                    verticalView.addArrangedSubview(currentStackView!)
                }

                // 기업명
                let label = UILabel()
                label.text = business.businessName ?? ""
                label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
                label.textColor = .white
                imageView.addSubview(label)
                label.snp.makeConstraints {
                    $0.leading.equalToSuperview().offset(12)
                    $0.bottom.equalToSuperview().offset(-12)
                }

                currentStackView?.addArrangedSubview(imageView)
            }
        }

        bottomView.addSubview(label)
        bottomView.addSubview(button)
        bottomView.addSubview(verticalView)

        label.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(48)
        }

        button.snp.makeConstraints {
            $0.bottom.equalTo(label.snp.bottom).offset(4)
            $0.trailing.equalToSuperview()
        }

        verticalView.snp.makeConstraints {
            $0.top.equalTo(button.snp.bottom).offset(16)
            $0.width.equalToSuperview()
            $0.height.equalTo(bottomView.snp.width)
            $0.bottom.equalToSuperview()
        }
    }

    private func setupConstraints() {
        logoImage.snp.makeConstraints { make in
            make.width.equalTo(55)
            make.height.equalTo(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.greaterThanOrEqualTo(scrollView).priority(.low)
        }

        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        bottomView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }
    }

    @objc private func swipeButtonTapped() {
        let vc = InfluenceSwipeVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }

    @objc private func handleImageTap(_ sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag ?? 0
        let vc = InfluenceReportVC()
        vc.businessId = businessList[tag].memberId
        self.navigationController?.pushViewController(vc, animated: false)
    }

    @objc private func collabTapped(_ sender: UITapGestureRecognizer) {
        let tag: Int = sender.view?.tag ?? 0
        let vc = CollabDetailVC()
        vc.collab = collabList[tag]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
