//
//  InfluenceProfileCell.swift
//  ByahtColor
//
//  Created by jaem on 7/11/24.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation

class InfluenceProfileCell: UITableViewCell {
    private let image: GradientImageView = {
        let iv = GradientImageView(frame: .zero)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor(hex: "#E5E6EA").cgColor
        iv.isUserInteractionEnabled = true
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

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Bold", size: 24)
        return label
    }()

    private let nationIcon = UIImageView()

    private let iconView: UIStackView = {
        let iconView = UIStackView()
        iconView.axis = .horizontal
        iconView.distribution = .equalSpacing
        iconView.spacing = 8
        iconView.isUserInteractionEnabled = true
        return iconView
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Pretendard-Bold", size: 14)
        label.numberOfLines = 2
        return label
    }()

    private let icon_facebook: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "facebook"))
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()

    private let icon_instagram: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "instagram"))
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()

    private let icon_tiktok: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "tiktok"))
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()
    private let icon_naver: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "naver"))
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()
    private let icon_youtube: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "youtube"))
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()
    private let viewModel = BusinessViewModel()
    private var videoURL: URL?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var tiktokLink = ""
    private var instaLink = ""
    private var facebookLink = ""
    private var naverLink = ""
    private var youtubeLink = ""

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        setupConstraints()
        // 알림 등록
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }

    deinit {
           // 알림 해제
           NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
       }

    private func setupUI() {
        contentView.addSubview(image)
        image.addSubview(nameLabel)
        image.addSubview(infoLabel)
        image.addSubview(iconView)
        image.addSubview(nationIcon)
        iconView.addArrangedSubview(icon_instagram)
        iconView.addArrangedSubview(icon_facebook)
        iconView.addArrangedSubview(icon_naver)
        iconView.addArrangedSubview(icon_tiktok)
        iconView.addArrangedSubview(icon_youtube)

        // 제스처 인식기 추가
        let tapGestureInstagram = UITapGestureRecognizer(target: self, action: #selector(tappedIcon(_:)))
        let tapGestureFacebook = UITapGestureRecognizer(target: self, action: #selector(tappedIcon(_:)))
        let tapGestureTiktok = UITapGestureRecognizer(target: self, action: #selector(tappedIcon(_:)))
        let tapGestureNaver = UITapGestureRecognizer(target: self, action: #selector(tappedIcon(_:)))

        icon_instagram.addGestureRecognizer(tapGestureInstagram)
        icon_facebook.addGestureRecognizer(tapGestureFacebook)
        icon_tiktok.addGestureRecognizer(tapGestureTiktok)
        icon_naver.addGestureRecognizer(tapGestureNaver)
    }

    private func setupConstraints() {
        image.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
            $0.height.equalTo(image.snp.width).multipliedBy(525.0 / 350.0)
        }

        infoLabel.snp.makeConstraints {
            $0.bottom.equalTo(image.snp.bottom).offset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        iconView.snp.makeConstraints {
            $0.bottom.equalTo(infoLabel.snp.top).offset(-8)
            $0.leading.equalToSuperview().inset(20)
        }

        nameLabel.snp.makeConstraints {
            $0.bottom.equalTo(iconView.snp.top).offset(-8)
            $0.leading.equalToSuperview().inset(20)
        }

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

    @objc private func playerDidFinishPlaying(_ notification: Notification) {
        // 재생 완료 시 호출
        DispatchQueue.main.async {
            self.replayButton.isHidden = false
        }
    }

    @objc private func replayButtonTapped() {
        // 재생 버튼 클릭 시 호출
        player?.seek(to: .zero)
        player?.play()
        replayButton.isHidden = true
    }

    private func makeIconView(list: [Sns]) {
        var hasTikTokLink = false
        var hasInstaLink = false
        var hasFacebookLink = false
        var hasNaverLink = false
        var hasYoutubeLink = false

        list.forEach { it in
            switch it.sns {
            case 0:
                tiktokLink = it.link ?? ""
                hasTikTokLink = !tiktokLink.isEmpty
            case 1:
                instaLink = it.link ?? ""
                hasInstaLink = !instaLink.isEmpty
            case 2:
                facebookLink = it.link ?? ""
                hasFacebookLink = !facebookLink.isEmpty
            case 3:
                naverLink = it.link ?? ""
                hasNaverLink = !naverLink.isEmpty
            case 4:
                youtubeLink = it.link ?? ""
                hasYoutubeLink = !youtubeLink.isEmpty
            default:
                break
            }
        }

        DispatchQueue.main.async {
            self.icon_tiktok.isHidden = !hasTikTokLink
            self.icon_instagram.isHidden = !hasInstaLink
            self.icon_facebook.isHidden = !hasFacebookLink
            self.icon_naver.isHidden = !hasNaverLink
            self.icon_youtube.isHidden = !hasYoutubeLink
        }
    }

    @objc private func tappedIcon(_ sender: UITapGestureRecognizer) {
        var urlString: String?
        switch sender.view {
        case icon_tiktok:
            urlString = tiktokLink
        case icon_instagram:
            urlString = instaLink
        case icon_facebook:
            urlString = facebookLink
        case icon_naver:
            urlString = naverLink
        case icon_youtube:
            urlString = youtubeLink
        default:
            break
        }
        if let urlString = urlString, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func configure(with profile: InfluenceProfileDto?) {
        // profile이 nil일 경우 기본 값 설정
        nameLabel.text = profile?.name ?? "No Name"
        infoLabel.text = profile?.intro ?? "No Information"

        if let getList = profile?.snsList {
            makeIconView(list: getList)
        } else {
            // snsList가 nil일 경우 기본 처리를 추가할 수 있습니다.
            // 예를 들어, makeIconView(list: [])와 같이 빈 리스트를 전달하거나, 아이콘을 숨길 수 있습니다.
            makeIconView(list: [])
        }

        if let path = profile?.imagePath {
            if path.contains("video") {
                let width = UIScreen.main.bounds.width - 40
                let height = width * (525.0 / 350.0)
                let url = "\(Bundle.main.TEST_URL)\( path )"
                if let videoURL = URL(string: url) {
                    player = AVPlayer(url: videoURL)
                    playerLayer = AVPlayerLayer(player: player)
                    playerLayer?.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
                    playerLayer?.videoGravity = .resizeAspectFill
                    if let sublayers = image.layer.sublayers {
                        var index = 0
                        for layer in sublayers {
                            if layer is AVPlayerLayer {
                                // Remove any existing AVPlayerLayer
                                layer.removeFromSuperlayer()
                            }
                            index += 1
                        }
                        image.layer.insertSublayer(playerLayer!, at: UInt32(index))
                    } else {
                        image.layer.addSublayer(playerLayer!)
                    }
                    image.layer.addSublayer(playerLayer!)

                    // replayButton 액션 추가
                    image.addSubview(replayButton)
                    replayButton.addTarget(self, action: #selector(replayButtonTapped), for: .touchUpInside)
                    replayButton.snp.makeConstraints {
                        $0.center.equalTo(image)
                        $0.width.height.equalTo(50)
                    }
                    // 비디오 재생 시작
                    player?.play()
                }
            } else {
                // 기존의 player와 playerLayer 제거
                player?.pause()
                player = nil
                playerLayer?.removeFromSuperlayer()
                playerLayer = nil
                // sublayers 안전하게 제거
                if let sublayers = image.layer.sublayers {
                    for layer in sublayers {
                        if layer is AVPlayerLayer {
                            layer.removeFromSuperlayer()
                        }
                    }
                }

                let url = "\(Bundle.main.TEST_URL)/img\( path )"
                image.loadImage2(from: url)
            }

            // 국가 아이콘설정
            if let nation = profile?.nation {
                setupNationIcon(nation: nation)
                nationIcon.contentMode = .scaleAspectFit
            }

            // 아이콘과 라벨들을 다시 최상위 레이어로 올리기
            image.bringGradientLayerToFront()
            image.bringSubviewToFront(nameLabel)
            image.bringSubviewToFront(nationIcon)
            image.bringSubviewToFront(infoLabel)
            image.bringSubviewToFront(iconView)
        } else {
            // imagePath가 nil일 경우 기본 이미지 또는 처리를 추가합니다.
            player?.pause()
            player = nil
            playerLayer?.removeFromSuperlayer()
            playerLayer = nil
            image.image = UIImage(named: "defaultImage") // 기본 이미지 설정
        }
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

    override func prepareForReuse() {
        super.prepareForReuse()
        player?.pause()
    }
}
