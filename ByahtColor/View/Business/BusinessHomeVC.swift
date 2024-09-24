//
//  BusinessHomeVC.swift
//  ByahtColor
//
//  Created by jaem on 6/29/24.
//

import Alamofire
import Combine
import UIKit
import AVFoundation
import SkeletonView
import SendbirdChatSDK
import Kingfisher

class BusinessHomeVC: UIViewController, UIScrollViewDelegate {

    private let logoImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "logo"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let topView = UIView()
    private let bottomView = UIView()
    private let topButton = UIButton()
    private let image1 = UIImageView()
    private let image2 = UIImageView()
    private let image3 = UIImageView()
    private let image4 = UIImageView()
    private let viewModel = BusinessViewModel()
    private var collabList: [CollabDto] = []
    private var influenceList: [InfluenceProfileDto] = []

    private var videoURL: URL?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleAccountUpdatedInHome), name: .dataChanged, object: nil)
    
    }

    @objc private func handleAccountUpdatedInHome(notification: NSNotification) {
        // 프로필 작성 뷰로 전환
        let profileWriteVC = BusinessProfileWriteVC()
        profileWriteVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(profileWriteVC, animated: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .dataChanged, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        setupHomeData()

        
        if User.shared.intro == nil || User.shared.intro?.isEmpty == true {
            setupOnboardingView()
        }else if UserDefaults.standard.integer(forKey: "home") == 0  && User.shared.id != "admin"{
            setupAlertView()
        }
        
    }

    private func setupOnboardingView() {
        let exampleVC = BusinessOnboardingVC()
        exampleVC.modalPresentationStyle = .overFullScreen
        exampleVC.modalTransitionStyle = .crossDissolve
        present(exampleVC, animated: true, completion: nil)
    }
    
    private func setupAlertView() {
        let alertVC = RegistAlertBusinessVC()
        alertVC.onConfirm = {
            let vc = BusinessProfileWriteVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
        }
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true, completion: nil)
    }

    private func setupHomeData() {
        if let id = User.shared.id {
            viewModel.getHomeData(id: id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):

                        self?.collabList = data.snapDtoList ?? []
                        self?.influenceList = data.influenceProfileDtos ?? []
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

    }

    private func setupBottomView() {
        contentView.addSubview(bottomView)

        let label1 = UILabel()
        label1.text = "businesshome_label2".localized
        label1.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label1.textColor = .black

        let label2 = UILabel()
        label2.text = "businesshome_label3".localized
        label2.font = UIFont(name: "Pretendard-Regular", size: 14)
        label2.textColor = UIColor(hex: "#4E505B")

        let button = UIButton()
        button.setTitle("influencehome_button".localized, for: .normal)
        button.setTitleColor(UIColor(hex: "#009BF2"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(snapButtonTapped), for: .touchUpInside)

        let horizontalScrollView = UIScrollView()
        horizontalScrollView.showsHorizontalScrollIndicator = false

        let horizontalContentView = UIView()

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

        bottomView.addSubview(label1)
        bottomView.addSubview(label2)
        bottomView.addSubview(button)
        bottomView.addSubview(horizontalScrollView)
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

        if User.shared.id == "byaht" || User.shared.id == "admin" {
            let vc = AdminCollabVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = CollabVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    @objc private func influenceButtonTapped() {
        let desiredIndex = 1
           // 탭 바 컨트롤러에 접근하여 특정 탭으로 이동
           if let tabBarController = self.tabBarController {
               tabBarController.selectedIndex = desiredIndex
           }
    }

    //
    private func setupTopView() {
        contentView.addSubview(topView)
        contentView.isUserInteractionEnabled = true
        topView.isUserInteractionEnabled = true

        let label = UILabel()
        label.text = "businesshome_label".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.numberOfLines = 0
        label.textColor = .black
        label.setLineSpacing(lineSpacing: 4)

        let button = UIButton()
        button.setTitle("influencehome_button".localized, for: .normal)
        button.setTitleColor(UIColor(hex: "#009BF2"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(influenceButtonTapped), for: .touchUpInside)

        let verticalView = UIStackView()
        verticalView.axis = .vertical
        verticalView.spacing = 4
        verticalView.distribution = .fillEqually
        verticalView.isUserInteractionEnabled = true

        var currentStackView: UIStackView?

        for (index, influence) in influenceList.enumerated() {
            let imageView = GradientImageView(frame: .zero)

            if let resource = influence.video {
                let str = resource.split(separator: ".").last ?? ""
                if str == "jpg" {
                    if let url = URL(string:resource){
                        imageView.kf.setImage(with: url)
                    }
                } else {
                    if let url = URL(string:influence.imagePath ?? ""){
                        imageView.kf.setImage(with: url)
                    }
                }
            } else {
                imageView.image = UIImage(named: "sample_image")
            }
            
            
            let label = UILabel()
            label.text = "\(influence.name ?? "")"
            label.textColor = .white
            label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
            imageView.addSubview(label)
            label.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(12)
                $0.bottom.equalToSuperview().inset(12)
            }

            imageView.layer.cornerRadius = 4
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor(hex: "#E5E6EA").cgColor
            imageView.contentMode = .scaleAspectFill
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

            currentStackView?.addArrangedSubview(imageView)
        }

        topView.addSubview(label)
        topView.addSubview(button)
        topView.addSubview(verticalView)

        verticalView.snp.makeConstraints {
            $0.top.equalTo(button.snp.bottom).offset(16)
            $0.width.equalToSuperview()
            $0.height.equalTo(topView.snp.width).multipliedBy(524 / 390.0)
            $0.bottom.equalToSuperview()
        }

        label.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(48)
        }

        button.snp.makeConstraints {
            $0.bottom.equalTo(label.snp.bottom).offset(4)
            $0.trailing.equalToSuperview()
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

    @objc private func handleImageTap(_ sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag ?? 0
        let vc = BusinessReportVC()
        vc.profile = influenceList[tag]
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
