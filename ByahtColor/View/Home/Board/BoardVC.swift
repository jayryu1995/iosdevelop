//
//  BeautyVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/12.
//

import UIKit
import Alamofire
import SnapKit

class BoardVC: UIViewController {
    private var loadingIndicator: UIActivityIndicatorView?
    private var mainScrollView: UIScrollView!
    private var boardList: [ReceiveBoard] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 화면 이동 이전에 네비게이션 바를 다시 표시
        self.navigationController?.setNavigationBarHidden(false, animated: false)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .white
        findAllBoard {   self.setView()     }

    }

    private func setView() {
        setupLoadingIndicator()
        setConfigScrollView()
        configureBoardView()
        setupButton()
    }

    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator?.center = self.view.center
        self.view.addSubview(loadingIndicator!)

        loadingIndicator?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureBoardView() {

        var contentOffsetY: CGFloat = 20

        for i in 0..<boardList.count {
            print("boardList : \(i)")
            let board = createBoard(index: i )

            self.mainScrollView.addSubview(board)
            board.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(contentOffsetY)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.width.equalTo(mainScrollView.snp.width).offset(-40)

            }
            contentOffsetY += 20.0
            let grayLayer = UIView()
            grayLayer.backgroundColor = UIColor(hex: "#F7F7F7")
            board.addSubview(grayLayer)

            // 회색 레이어의 제약조건 설정
            grayLayer.snp.makeConstraints { make in
                make.height.equalTo(1.0)
                make.bottom.equalToSuperview().offset(10)
                make.leading.trailing.equalToSuperview()
            }

            // 레이아웃을 즉시 업데이트하여 board의 높이를 가져옵니다.
            self.view.layoutIfNeeded()
            contentOffsetY += board.frame.height
        }

        let contentSize = CGSize(width: CGFloat(view.frame.width), height: contentOffsetY)
        // Set content size for 'mainScrollView'
        mainScrollView.contentSize = contentSize

    }

    private func setConfigScrollView() {

        let textView = UITextView()
        textView.text = "Talk"
        textView.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        view.addSubview(textView)

        mainScrollView = UIScrollView()
        mainScrollView.backgroundColor = .white
        mainScrollView.isPagingEnabled = false
        mainScrollView.showsVerticalScrollIndicator = true

        view.addSubview(mainScrollView)

        let layer = UIView()
        layer.backgroundColor = UIColor.black

        view.addSubview(layer)

        layer.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom)
            $0.leading.trailing.equalTo(textView)
            $0.height.equalTo(1)
        }

        textView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }

        mainScrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(textView.snp.bottom).offset(10)
        }

    }

    private func setupButton() {
        let button = UIButton()
        button.setTitle("Write", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
        button.setImage(UIImage(named: "pen_icon"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        // 이미지와 텍스트의 간격 설정
        let spacing: CGFloat = 5 // 원하는 간격
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)

        button.backgroundColor = .black // 색상은 예시입니다.
        button.layer.cornerRadius = 20

        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20) // 아래쪽 여백 20
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20) // 오른쪽 여백 20
            make.height.equalTo(40)
            make.width.equalTo(90)
        }
    }

    private func createBoard(index: Int) -> UIView {
        // board 설정 코드...
        // 스크롤 뷰와 페이지 컨트롤 설정 코드...
        let board = UIView()
        board.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(boardTapped(_:)))
        board.addGestureRecognizer(tapGesture)
        board.isUserInteractionEnabled = true // 뷰가 사용자 입력을 받을 수 있도록 설정
        board.tag = index // 각 board 뷰를 구분하기 위한 태그 설정
        // label 설정
        let titlelabel = UILabel()
        titlelabel.text = boardList[index].title
        titlelabel.textColor = .black
        titlelabel.font =  UIFont(name: "Pretendard-SemiBold", size: 16)

        let contentLabel = UILabel()
        contentLabel.text = boardList[index].content
        contentLabel.textColor = UIColor(hex: "#535358")
        contentLabel.numberOfLines = 2
        contentLabel.font =  UIFont(name: "Pretendard-Regular", size: 14)

        // likeButton 설정
        let likeButton = UIButton()
        likeButton.setImage(UIImage(named: "like_icon"), for: .normal)
        let likeCount = boardList[index].like_count ?? 0
        likeButton.setTitle("\(likeCount)", for: .normal)
        likeButton.setTitleColor(UIColor(hex: "#535358"), for: .normal)

        // commentButton 설정
        let commentButton = UIButton()
        let commentCount = boardList[index].comment_count ?? 0
        commentButton.setImage(UIImage(named: "icon_comment"), for: .normal)
        commentButton.setTitle("\(commentCount)", for: .normal)
        commentButton.setTitleColor(UIColor(hex: "#535358"), for: .normal)

        let date = boardList[index].regi_date ?? ""

        let writer = boardList[index].nickname ?? ""
        let textLabel = UILabel()
        textLabel.text = "| \(date.dateToString()) | \(writer)"
        textLabel.textColor = UIColor(hex: "#BCBDC0")
        textLabel.font = UIFont(name: "Pretendard-Regular", size: 12)

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        var getImage = false
        let imageSideLength = (UIScreen.main.bounds.width - 40) / 4

        if let imageList = boardList[index].imageList, !imageList.isEmpty, let firstImagePath = imageList.first, !firstImagePath.isEmpty {
            let url = "\(Bundle.main.TEST_URL)/board\(firstImagePath)"
            imageView.loadImage(from: url, resizedToWidth: imageSideLength)
            getImage = true
        }

        board.addSubview(titlelabel)
        board.addSubview(contentLabel)
        board.addSubview(likeButton)
        board.addSubview(commentButton)
        board.addSubview(textLabel)
        board.addSubview(imageView)

        titlelabel.snp.makeConstraints {make in
            make.top.equalToSuperview().offset(5)
            if getImage {
                make.leading.equalTo(board)
                make.trailing.equalTo(board).multipliedBy(0.7)
            } else {
                make.leading.trailing.equalTo(board)
            }

        }

        contentLabel.snp.makeConstraints {make in
            make.top.equalTo(titlelabel.snp.bottom).offset(2)
            if getImage {
                make.leading.equalTo(board)
                make.trailing.equalTo(board).multipliedBy(0.7)
            } else {
                make.leading.trailing.equalTo(board)
            }
        }

        likeButton.snp.makeConstraints {make in
            make.top.equalTo(contentLabel.snp.bottom).offset(3)
            make.leading.equalTo(board)
            make.width.equalTo(40)
            make.bottom.equalToSuperview().offset(-5)
        }

        commentButton.snp.makeConstraints {make in
            make.top.equalTo(contentLabel.snp.bottom).offset(3)
            make.leading.equalTo(likeButton.snp.trailing).offset(5)
            make.width.equalTo(40)
        }

        textLabel.snp.makeConstraints {
            $0.centerY.equalTo(commentButton.snp.centerY)
            $0.leading.equalTo(commentButton.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().offset(-20)
        }

        if getImage {
            imageView.snp.makeConstraints {
                $0.top.equalTo(titlelabel.snp.top)
                $0.leading.equalTo(contentLabel.snp.trailing).offset(10)
                $0.bottom.equalTo(textLabel.snp.bottom)
                $0.height.equalTo(imageSideLength)
            }
        }

        return board
    }

    // 매거진 리스트 불러오기
    private func findAllBoard(completion: @escaping () -> Void) {
        loadingIndicator?.startAnimating()
        let url = "\(Bundle.main.TEST_URL)/board/sel"

        // 요청에 필요한 파라미터 설정
        let parameters: [String: Any] = ["user_id": User.shared.id ?? ""]

        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [ReceiveBoard].self) { response in
            switch response.result {
            case .success(let snapVo):
                // 성공적으로 데이터를 받아왔을 때
                self.boardList = snapVo
                self.loadingIndicator?.stopAnimating()

                completion()
            case .failure(let error):
                // 요청 실패 또는 디코딩 실패
                print("Error snapList: \(error)")
                self.loadingIndicator?.stopAnimating()
                completion()
            }
        }
    }

    @objc private func buttonAction() {
        // 버튼이 탭될 때 수행할 작업
        let vc = WriteBoardVC()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func boardTapped(_ sender: UITapGestureRecognizer) {
        guard let boardIndex = sender.view?.tag else { return }
        let vc = ReadBoardVC()
        vc.board = boardList[boardIndex]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
