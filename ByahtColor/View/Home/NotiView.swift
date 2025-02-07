//
//  NotiView.swift
//  ByahtColor
//
//  Created by jaem on 2/6/25.
//

import Kingfisher
import UIKit
import SnapKit

class NotiView: UIViewController {
    private lazy var label1 = {
        let label = UILabel()
        label.text = "noti_label1_text".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        return label
    }()
    
    private lazy var label2: UILabel = {
        let label = UILabel()
        let fullText = "noti_label2_text".localized
        let attributedString = NSMutableAttributedString(string: fullText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping

        // UIFont 설정
        let font = UIFont(name: "Pretendard-SemiBold", size: 14)!
        
        // 전체 텍스트에 기본 속성 설정
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

        // 첫 번째 줄의 NSRange 계산
        if let firstLineEndIndex = fullText.firstIndex(of: "\n") {
            let firstLineRange = NSRange(fullText.startIndex..<firstLineEndIndex, in: fullText)
            // 첫 번째 줄에만 색상 적용
            attributedString.addAttribute(.foregroundColor, value: UIColor(hex: "#EF369B"), range: firstLineRange)
        } else {
            // 줄바꿈 문자가 없을 경우 전체 텍스트를 첫 번째 줄로 처리
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: attributedString.length))
        }

        label.numberOfLines = 0
        label.attributedText = attributedString
        return label
    }()
    
    private lazy var imageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStackView()
        setupConstraints()
    }
    
    private func setupStackView(){
        view.addSubview(stackView)
        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(label2)
        stackView.addArrangedSubview(imageView)
        
        let nation = getLanguage()
        let url = URL(string: "https://d3mp6eqt0w2808.cloudfront.net/noti/\(nation).png")
        imageView.kf.setImage(with: url)
    }
    
    private func setupConstraints(){
        stackView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        label1.snp.makeConstraints{
            $0.top.equalToSuperview().offset(15)
        }
        
        imageView.snp.makeConstraints{
            $0.top.equalTo(label2.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.width)
        }
    }
    func requiredHeight() -> CGFloat {
        // 임시로 고정된 값을 반환하거나, 복잡한 높이 계산 로직 구현
        return 480  
    }
}



