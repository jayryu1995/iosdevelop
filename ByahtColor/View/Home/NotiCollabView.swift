//
//  NotiCollabView.swift
//  ByahtColor
//
//  Created by jaem on 2/13/25.
//

import Kingfisher
import UIKit
import SnapKit

class NotiCollabView: UIViewController {
    private lazy var label1 = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        return label
    }()
    
    private lazy var label2: UILabel = {
        let label = UILabel()
        label.text = "noti_collab_label_text".localized
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()
    
    private lazy var imageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    private var titleText: String
    private var imageUrl: String
    private var collab: CollabDto
    
    init(titleText: String, imageUrl: String, collab: CollabDto) {
        self.titleText = titleText
        self.imageUrl = imageUrl
        self.collab = collab
        super.init(nibName: nil, bundle: nil)
    }

    // ✅ 필수 생성자 (Storyboard/XIB를 사용할 경우 필요)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStackView()
        setupConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    private func setupStackView(){
        view.addSubview(stackView)
        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(label2)
        stackView.addArrangedSubview(imageView)
        
        let url = URL(string: imageUrl)
        imageView.kf.setImage(with: url)
        label1.text = titleText
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
    
    @objc private func imageTapped(){
        print("이미지 탭")
        let vc = CollabDetailVC()
        vc.collab = collab
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
