//
//  BusinessSearchVC.swift
//  ByahtColor
//
//  Created by jaem on 6/29/24.
//

import Foundation
import UIKit
import SnapKit
import AVKit
import AVFoundation
import Combine
import SendbirdChatSDK
import Kingfisher

class BusinessSearchVC: UIViewController {
    
    var imageView: GradientImageView = {
        let iv = GradientImageView(frame: .zero)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.isUserInteractionEnabled = true
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor(hex: "#E5E6EA").cgColor
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Bold", size: 24)
        return label
    }()
    
    private let icon_facebook: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "facebook"))
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    private let icon_instagram: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "instagram"))
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    private let icon_tiktok: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "tiktok"))
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    private let icon_naver: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "naver"))
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    private let icon_youtube: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "youtube"))
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    private let replayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon_replay"), for: .normal)
        button.contentMode = .center
        button.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        button.layer.cornerRadius = 8
        button.isHidden = true
        button.isUserInteractionEnabled = true
        return button
    }()
    private let introLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Bold", size: 14)
        label.numberOfLines = 2
        return label
    }()
    
    private let subtitle1: UILabel = {
        let label = UILabel()
        label.text = "influence_profile_subtitle1".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.textColor = .black
        return label
    }()
    
    private let subtitle2: UILabel = {
        let label = UILabel()
        label.text = "influence_profile_subtitle2".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.textColor = .black
        return label
    }()
    
    private let subtitle3: UILabel = {
        let label = UILabel()
        label.text = "influence_profile_subtitle3".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.textColor = .black
        return label
    }()
    
    private let reportView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F4F5F8")
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let chatButton: UIImageView = {
        let button = UIImageView()
        button.isUserInteractionEnabled = true
        button.image = UIImage(named: "chat_button")
        button.contentMode = .scaleAspectFill
        return button
    }()
    private let nationIcon = UIImageView()
    private var genderView = UIView()
    private var categoryView = UIView()
    private var ageView = UIView()
    private var nationView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let iconView = UIStackView()
    private var experienceStackView = UIStackView()
    private var payStackView = UIStackView()
    private var targetView = UIView()
    private let viewModel = BusinessViewModel()
    private var snsList: [Sns] = []
    private var experienceList: [Experience] = []
    private var payList: [Pay] = []
    private var selectedGender: [String] = []
    private var selectedNation: [String] = []
    private var selectedCategory: [String] = []
    private var selectedAge: [String] = []
    private var mediaPath: String = ""
    private var videoURL: URL?
    private var playerLayer: AVPlayerLayer?
    private var loadingIndicator = UIActivityIndicatorView(style: .large)
    private var tiktokLink = ""
    private var facebookLink = ""
    private var instaLink = ""
    private var naverLink = ""
    private var youtubeLink = ""
    private var player: AVPlayer?
    var profile: InfluenceProfileDto?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPlayer()
        setupProfile()
    }
    
    private func setupPlayer(){
        loadingIndicator.center = imageView.center
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        if let path = profile?.video {
            if path.contains(".m3u8"), let mediaUrl = URL(string: path) {
                let item = AVPlayerItem(url: mediaUrl)
                item.preferredForwardBufferDuration = TimeInterval(1)
                player = AVPlayer(playerItem: item)
                
                if let url = URL(string:profile?.imagePath ?? ""){
                    imageView.kf.setImage(with: url)
                }
                
                loadingIndicator.stopAnimating()
            } else if path.contains("jpg") {
                if let url = URL(string: path) {
                    imageView.kf.setImage(with: url)
                    loadingIndicator.stopAnimating()
                }
                
            } else {
                imageView.image = UIImage(named: "sample_image")
                loadingIndicator.stopAnimating()
            }
        } else {
            imageView.image = UIImage(named: "sample_image")
            loadingIndicator.stopAnimating()
        }
    }
    
    
    private func setupProfile() {
        snsList = profile?.snsList ?? []
        experienceList = profile?.experienceList ?? []
        payList = profile?.payList ?? []
        nameLabel.text = "\(profile?.name ?? "")"
        introLabel.text = "\(profile?.intro ?? "")"
        selectedGender = profile?.gender?.components(separatedBy: ",") ?? []
        selectedNation = profile?.nation?.components(separatedBy: ",") ?? []
        selectedAge = profile?.age?.components(separatedBy: ",") ?? []
        selectedCategory = profile?.category?.components(separatedBy: ",") ?? []
        // 국가 아이콘설정
        if let nation = profile?.nation {
            setupNationIcon(nation: nation)
            nationIcon.contentMode = .scaleAspectFit
        }
        setupUI()
        setupConstraints()
        if let list = profile?.snsList {
            setupIconView(list: list)
        }
        
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        view.addSubview(chatButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigationToChats))
        chatButton.addGestureRecognizer(tapGesture)
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
        setupTempletView()
        setupReportView()
        
    }
    
    private func setupReportView() {
        contentView.addSubview(reportView)
        reportView.addSubview(subtitle1)
        reportView.addSubview(subtitle2)
        reportView.addSubview(subtitle3)
        experienceStackView = makeExperienceStackView(list: experienceList)
        payStackView = makePayStackView(index: payList)
        makeTargetStackView()
        reportView.addSubview(experienceStackView)
        reportView.addSubview(payStackView)
        reportView.addSubview(targetView)
        
    }
    
    private func setupTempletView() {
        contentView.addSubview(imageView)
        
        if let player = player {
            let width = UIScreen.main.bounds.width - 40
            let height = width * (16.0 / 9.0)
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
            playerLayer?.videoGravity = .resizeAspectFill
            
            if let playerLayer = playerLayer {
                imageView.layer.addSublayer(playerLayer)
            }
            
            imageView.bringGradientLayerToFront()
            
            // replayButton 액션 추가
            imageView.addSubview(replayButton)
            replayButton.addTarget(self, action: #selector(replayButtonTapped), for: .touchUpInside)
            replayButton.snp.makeConstraints {
                $0.width.height.equalTo(60)
                $0.center.equalToSuperview()
            }
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(playerDidFinishPlaying),
                name: .AVPlayerItemDidPlayToEndTime,
                object: player.currentItem
            )
        }
        
        // 아이콘 스택뷰 설정
        imageView.addSubview(nameLabel)
        imageView.addSubview(introLabel)
        imageView.addSubview(nationIcon)
        
        iconView.axis = .horizontal
        iconView.distribution = .equalSpacing
        iconView.spacing = 8
        
        iconView.addArrangedSubview(icon_instagram)
        iconView.addArrangedSubview(icon_facebook)
        iconView.addArrangedSubview(icon_tiktok)
        iconView.addArrangedSubview(icon_naver)
        iconView.addArrangedSubview(icon_youtube)
        imageView.addSubview(iconView)
        
        nationIcon.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel.snp.centerY)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(8)
            $0.top.bottom.equalTo(nameLabel)
        }
        
        icon_instagram.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        icon_tiktok.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        icon_facebook.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        icon_naver.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        icon_youtube.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
    }
    
    // 0: 틱톡 1: 인스타그램 2: 페이스북 3: 네이버 4: 유튜브
    private func setupIconView(list: [Sns]) {
        list.forEach { it in
            var iconView: UIImageView?
            
            switch it.sns {
            case 0:
                iconView = icon_tiktok
                tiktokLink = it.link ?? ""
            case 1:
                iconView = icon_instagram
                instaLink = it.link ?? ""
            case 2:
                iconView = icon_facebook
                facebookLink = it.link ?? ""
            case 3:
                iconView = icon_naver
                naverLink = it.link ?? ""
            case 4:
                iconView = icon_youtube
                youtubeLink = it.link ?? ""
            default:
                break
            }
            
            if let iconView = iconView {
                iconView.isHidden = false
                iconView.isUserInteractionEnabled = true
                iconView.tag = it.sns ?? 0
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedIcon(_:)))
                iconView.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    @objc private func tappedIcon(_ sender: UITapGestureRecognizer) {
        print("touch on")
        var urlString: String?
        let tag = sender.view?.tag
        switch tag {
        case 0:
            urlString = tiktokLink
        case 1:
            urlString = instaLink
        case 2:
            urlString = facebookLink
        case 3:
            urlString = naverLink
        case 4:
            urlString = youtubeLink
        default:
            break
        }
        
        if let urlString = urlString, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func setupConstraints() {
        chatButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            // $0.width.height.equalTo(80)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.greaterThanOrEqualTo(scrollView).priority(.low)
        }
        
        // Templet
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(imageView.snp.width).multipliedBy(16.0 / 9.0)
        }
        
        iconView.snp.makeConstraints {
            $0.bottom.equalTo(introLabel.snp.top).offset(-8)
            $0.leading.equalToSuperview().offset(20)
        }
        
        introLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints {
            $0.bottom.equalTo(iconView.snp.top).offset(-8)
            $0.leading.equalToSuperview().offset(20)
        }
        
        // 보고서
        reportView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
        
        subtitle1.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        experienceStackView.snp.makeConstraints {
            $0.top.equalTo(subtitle1.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        subtitle2.snp.makeConstraints {
            $0.top.equalTo(experienceStackView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        payStackView.snp.makeConstraints {
            $0.top.equalTo(subtitle2.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        subtitle3.snp.makeConstraints {
            $0.top.equalTo(payStackView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        targetView.snp.makeConstraints {
            $0.top.equalTo(subtitle3.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
    private func makeTargetStackView() {
        
        let label = UILabel()
        label.text = "influence_profile_target".localized
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        
        let label2 = UILabel()
        label2.text = "influence_profile_target2".localized
        label2.font = UIFont(name: "Pretendard-Medium", size: 16)
        
        let label3 = UILabel()
        label3.text = "influence_profile_target3".localized
        label3.font = UIFont(name: "Pretendard-Medium", size: 16)
        
        let label4 = UILabel()
        label4.text = "influence_profile_target4".localized
        label4.font = UIFont(name: "Pretendard-Medium", size: 16)
        
        categoryView = createCategoryView(titles: Globals.shared.categories, selected: selectedCategory)
        ageView = createCategoryView(titles: Globals.shared.ages, selected: selectedAge)
        genderView = createCategoryView(titles: Globals.shared.genders, selected: selectedGender)
        nationView = createCategoryView(titles: Globals.shared.nations, selected: selectedNation)
        
        targetView.addSubview(label)
        targetView.addSubview(label2)
        targetView.addSubview(label3)
        targetView.addSubview(label4)
        targetView.addSubview(categoryView)
        targetView.addSubview(ageView)
        targetView.addSubview(genderView)
        targetView.addSubview(nationView)
        
        label.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        categoryView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        label2.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        ageView.snp.makeConstraints {
            $0.top.equalTo(label2.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        label3.snp.makeConstraints {
            $0.top.equalTo(ageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        genderView.snp.makeConstraints {
            $0.top.equalTo(label3.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        label4.snp.makeConstraints {
            $0.top.equalTo(genderView.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        nationView.snp.makeConstraints {
            $0.top.equalTo(label4.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func createCategoryView(titles: [String], selected: [String]) -> UIView {
        let view = UIView()
        let maxWidth = UIScreen.main.bounds.width - 80
        var currentRowView = UIView()
        var currentRowWidth: CGFloat = 0
        var rowIndex = 0
        for (index, title) in titles.enumerated() {
            
            let button = UIButton()
            if selected.contains(index.toString()) {
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .black
            } else {
                button.setTitleColor(UIColor(hex: "#4E505B"), for: .normal)
                button.backgroundColor = .white
            }
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
            button.layer.cornerRadius = 16
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(hex: "#D3D4DA").cgColor
            button.titleEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.5
            button.titleLabel?.lineBreakMode = .byTruncatingTail
            
            let buttonWidth: CGFloat = max(48, (title as NSString).size(withAttributes: [.font: UIFont(name: "Pretendard-Regular", size: 14)!]).width + 16) // 16 for padding
            
            if currentRowWidth + buttonWidth + 4 > maxWidth { // 4 for spacing
                view.addSubview(currentRowView)
                
                currentRowView.snp.makeConstraints { make in
                    make.top.equalTo(view).offset(rowIndex * 36) // Adjust the top offset for each row
                    make.left.equalTo(view)
                    make.right.equalTo(view)
                    make.height.equalTo(36)
                    
                }
                
                currentRowView = UIView()
                currentRowWidth = 0
                rowIndex += 1
            }
            
            currentRowView.addSubview(button)
            button.snp.makeConstraints { make in
                make.left.equalTo(currentRowView).offset(currentRowWidth)
                make.centerY.equalTo(currentRowView)
                make.width.equalTo(buttonWidth)
                make.height.equalTo(32)
            }
            
            currentRowWidth += buttonWidth + 4
        }
        
        if !currentRowView.subviews.isEmpty {
            view.addSubview(currentRowView)
            currentRowView.snp.makeConstraints { make in
                make.top.equalTo(view).offset(rowIndex * 36) // Adjust the top offset for each row
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.height.equalTo(36)
                make.bottom.equalToSuperview()
            }
        }
        
        return view
    }
    
    private func makePayStackView(index: [Pay]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        
        index.forEach { i in
            let view = UIView()
            stackView.addArrangedSubview(view)
            view.snp.makeConstraints {
                $0.height.equalTo(42)
            }
            var icon: UIImageView
            if i.sns == 0 {
                icon = UIImageView(image: UIImage(named: "tiktok"))
            } else if i.sns == 1 {
                icon = UIImageView(image: UIImage(named: "instagram"))
            } else if i.sns == 2 {
                icon = UIImageView(image: UIImage(named: "facebook"))
            } else if i.sns == 3 {
                icon = UIImageView(image: UIImage(named: "naver"))
            } else {
                icon = UIImageView(image: UIImage(named: "youtube"))
            }
            
            let lbl = UILabel()
            lbl.text = i.cash ?? ""
            lbl.font = UIFont(name: "Pretendard-Medium", size: 16)
            
            var type = ""
            if i.type == 1 {
                type = "influence_profile_photo".localized
            } else {
                type = "influence_profile_video".localized
            }
            
            let lbl2 = UILabel()
            lbl2.text = "\(i.negotiable! ? "influence_profile_negotiable".localized : "influence_profile_non_negotiable".localized) | \(type)"
            lbl2.font = UIFont(name: "Pretendard-Regular", size: 12)
            lbl2.textColor = UIColor(hex: "#4E505B")
            
            view.addSubview(icon)
            view.addSubview(lbl)
            view.addSubview(lbl2)
            
            icon.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
                $0.width.height.equalTo(20)
            }
            
            lbl.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalTo(icon.snp.trailing).offset(4)
            }
            
            lbl2.snp.makeConstraints {
                $0.top.equalTo(icon.snp.bottom).offset(4)
                $0.leading.equalToSuperview()
            }
        }
        
        return stackView
    }
    
    private func makeExperienceStackView(list: [Experience]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        
        list.forEach { i in
            let view = UIView()
            stackView.addArrangedSubview(view)
            view.snp.makeConstraints {
                $0.height.equalTo(42)
                $0.leading.trailing.equalToSuperview()
            }
            var icon: UIImageView
            if i.sns == 0 {
                icon = UIImageView(image: UIImage(named: "tiktok"))
            } else if i.sns == 1 {
                icon = UIImageView(image: UIImage(named: "instagram"))
            } else if i.sns == 2 {
                icon = UIImageView(image: UIImage(named: "facebook"))
            } else {
                icon = UIImageView(image: UIImage(named: "naver"))
            }
            
            let button = UIButton()
            button.isUserInteractionEnabled = true
            if let image = UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate) {
                button.setImage(image, for: .normal)
            }
            button.tintColor = UIColor(hex: "#4E505B")
            button.addTarget(self, action: #selector(iconTapped), for: .touchUpInside)
            button.accessibilityHint = i.link
            
            let lbl = UILabel()
            lbl.text = i.contents
            lbl.font = UIFont(name: "Pretendard-Medium", size: 16)
            
            let lbl2 = UILabel()
            lbl2.text = "\(i.business ?? "")"
            lbl2.font = UIFont(name: "Pretendard-Regular", size: 12)
            lbl2.textColor = UIColor(hex: "#4E505B")
            
            view.addSubview(icon)
            view.addSubview(lbl)
            view.addSubview(lbl2)
            view.addSubview(button)
            
            icon.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
                $0.width.height.equalTo(20)
            }
            
            lbl.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalTo(icon.snp.trailing).offset(4)
                $0.trailing.equalTo(button.snp.leading)
            }
            
            lbl2.snp.makeConstraints {
                $0.top.equalTo(icon.snp.bottom).offset(4)
                $0.leading.equalToSuperview()
                $0.trailing.equalTo(button.snp.leading)
            }
            
            button.snp.makeConstraints {
                $0.width.height.equalTo(16)
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview()
            }
        }
        
        if list.isEmpty {
            let nullView = UILabel()
            nullView.text = " - "
            nullView.font = UIFont(name: "Pretendard-SemiBold", size: 20)
            stackView.addArrangedSubview(nullView)
            nullView.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.height.equalTo(40)
            }
        }
        return stackView
    }
    
    private func setupNationIcon(nation: String) {
        switch nation {
        case "0": nationIcon.image = UIImage(named: "icon_ko")
        case "1": nationIcon.image = UIImage(named: "icon_jp")
        case "2": nationIcon.image = UIImage(named: "icon_th")
        case "3": nationIcon.image = UIImage(named: "icon_ph")
        case "4": nationIcon.image = UIImage(named: "icon_vi")
        case "5": nationIcon.image = UIImage(named: "icon_sg")
        default:
            nationIcon.image = nil
        }
    }
    
    @objc private func playerDidFinishPlaying(notification: Notification) {
        print("영상종료")
        replayButton.isHidden = false
    }
    
    @objc private func iconTapped(_ sender: UIButton) {
        if let urlString = sender.accessibilityHint, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func replayButtonTapped() {
        replayButton.isHidden = true
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    @objc private func navigationToChats(_ sender: UIButton) {
        let params = GroupChannelCreateParams()
        params.name = "test Chat"
        
        let server: String = User.shared.id ?? ""
        let client: String = profile?.memberId ?? ""
        params.userIds = [server, client]
        params.isDistinct = true
        
        GroupChannel.createChannel(params: params) { channel, error in
            guard error == nil else {
                // Handle error.
                return
            }
            var timestampStorage = TimestampStorage()
            
            let vc = ChatsVC(channel: channel!, timestampStorage: timestampStorage)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
