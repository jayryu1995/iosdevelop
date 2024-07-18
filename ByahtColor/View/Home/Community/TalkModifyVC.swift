//
//  ModifyBoardVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/02/15.
//

import UIKit
import SnapKit
import Alamofire
import SkeletonView

class TalkModifyVC: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let topView = UIView()
    private let uploadButton = UIButton()
    private var tableView: UITableView!
    private let titleTextView: UITextView = {
        let view = UITextView()
        view.font = UIFont(name: "Pretendard-Bold", size: 20)
        view.backgroundColor = UIColor(hex: "#F7F7F7")
        return view
    }()
    private let contentTextView: UITextView = {
        let view = UITextView()
        view.textColor = UIColor(hex: "#535358")
        view.font = UIFont(name: "Pretendard-Regular", size: 14)
        view.backgroundColor = UIColor(hex: "#F7F7F7")
        return view
    }()
    private var selectedImages: [UIImage] = []
    var board: Talk?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadImagesIntoSelectedImages()
        configureViews()
        setupNavigationBar()
        setupBackButton()
        setupTableView()
    }

    private func loadImagesIntoSelectedImages() {
        guard let imageList = board?.imageList else { return }

        for imageUrl in imageList {
            let fullUrl = "\(Bundle.main.TEST_URL)/board\(imageUrl)"
            loadImageAndAppendToSelected(from: fullUrl)
        }
    }

    private func loadImageAndAppendToSelected(from urlString: String) {
        if let cachedImage = ImageCacheManager.shared.image(for: urlString) {
            self.selectedImages.append(cachedImage)
            return
        }

        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.selectedImages.append(image)
                }
            }
        }.resume()
    }

    private func setupNavigationBar() {
            self.navigationItem.title = "Modify"
            let uploadBarButtonItem = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(uploadButtonTapped))
            self.navigationItem.rightBarButtonItem = uploadBarButtonItem
        }

    private func configureViews() {
            titleTextView.delegate = self
            contentTextView.delegate = self
            view.backgroundColor = UIColor(hex: "#F7F7F7")
            setupTapGesture()
        }

    private func setupTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        }

    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(hex: "#F7F7F7")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    @objc private func uploadButtonTapped() {

        let url = "\(Bundle.main.TEST_URL)/board/update"
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        let nickname: String = User.shared.name ?? ""
        let user_id = User.shared.id ?? ""
        let no = String(board?.no ?? 0)

        // MultipartFormData를 사용하여 요청 생성
        AF.upload(multipartFormData: { multipartFormData in
            // 텍스트 데이터 추가
            multipartFormData.append(Data(no.utf8), withName: "no")
            multipartFormData.append(Data(user_id.utf8), withName: "user_id")
            multipartFormData.append(Data(nickname.utf8), withName: "nickname")
            multipartFormData.append(Data(self.contentTextView.text.utf8), withName: "content")
            multipartFormData.append(Data(self.titleTextView.text.utf8), withName: "title")

            // 이미지 데이터 추가
            for (index, image) in self.selectedImages.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 1080) {
                    multipartFormData.append(imageData, withName: "images", fileName: "image\(index).jpg", mimeType: "image/jpg")
                }
            }
        }, to: url, method: .post, headers: headers).responseString { response in
            switch response.result {
            case .success(let stringValue):

                self.navigationController?.popViewController(animated: true)

            case .failure(let error):
                print("Upload failed with error: \(error)")
            }
        }
    }

    // 이미지 제거 메소드
    @objc private func removeImage(_ sender: UIButton) {
        print("삭제")
        let index = sender.tag
        if !selectedImages.isEmpty {
            selectedImages.remove(at: index)
        }
        let sectionIndex = IndexSet(integer: 2)
        tableView.reloadSections(sectionIndex, with: .automatic)
    }

}

extension TalkModifyVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // 예: 타이틀, 콘텐츠, 이미지
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 2: return 1
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(hex: "#F7F7F7")
        switch indexPath.section {
        case 0:
            cell.contentView.addSubview(titleTextView)
            titleTextView.backgroundColor = UIColor(hex: "#F7F7F7")
            titleTextView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(5)
                make.leading.trailing.equalToSuperview().inset(20)
            }
            titleTextView.text = board?.title ?? "제목 입력"
        case 1:
            cell.contentView.addSubview(contentTextView)
            contentTextView.backgroundColor = UIColor(hex: "#F7F7F7")
            contentTextView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(5)
                make.leading.trailing.equalToSuperview().inset(20)
            }
            contentTextView.text = board?.content ?? "내용 입력"
        case 2:
            if !selectedImages.isEmpty {
                let scrollView = UIScrollView()
                scrollView.backgroundColor = UIColor(hex: "#F7F7F7")
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.showsVerticalScrollIndicator = false
                scrollView.isPagingEnabled = true  // 페이지 단위 스크롤을 원한다면 활성화
                cell.contentView.addSubview(scrollView)
                scrollView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                    make.height.equalTo(UIScreen.main.bounds.width)
                }

                // contentView 추가
                let contentView = UIView()
                scrollView.addSubview(contentView)
                contentView.snp.makeConstraints { make in
                    make.edges.equalTo(scrollView)
                    make.height.equalTo(scrollView)
                }

                var previousView: UIView?

                // selectedImages 배열을 사용해 이미지 뷰를 스크롤 뷰에 추가
                for (index, image) in selectedImages.enumerated() {
                    let imageView = UIImageView(image: image)
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    imageView.isUserInteractionEnabled = true
                    imageView.tag = index

                    // 제거 버튼 추가
                    let removeButton = UIButton()
                    removeButton.setImage(UIImage(named: "icon_close"), for: .normal)
                    removeButton.addTarget(self, action: #selector(removeImage), for: .touchUpInside)
                    removeButton.tag = index
                    imageView.addSubview(removeButton)

                    // 제거 버튼 제약 조건
                    removeButton.snp.makeConstraints { make in
                        make.top.right.equalToSuperview().inset(10)
                        make.width.height.equalTo(30)
                    }

                    // contentView에 이미지 뷰 추가
                    contentView.addSubview(imageView)
                    imageView.snp.makeConstraints { make in
                        make.top.bottom.equalTo(contentView)
                        make.width.equalTo(scrollView.snp.width)
                        if let previous = previousView {
                            make.leading.equalTo(previous.snp.trailing)
                        } else {
                            make.leading.equalTo(contentView.snp.leading)
                        }

                        if index == selectedImages.count - 1 {
                            make.trailing.equalTo(contentView.snp.trailing)
                        }
                    }

                    previousView = imageView
                }

                // 스크롤 뷰의 콘텐츠 크기를 동적으로 설정
                contentView.snp.makeConstraints { make in
                    make.trailing.equalTo(previousView!.snp.trailing) // 마지막 이미지 뷰가 contentView의 마지막과 맞추어 콘텐츠 사이즈를 결정
                }
            }
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 64
        case 1: return 210
        case 2: return UITableView.automaticDimension // 이미지 뷰 높이
        default: return UITableView.automaticDimension
        }

    }

    func loadImage(from urlString: String, for imageView: UIImageView) {
        imageView.isSkeletonable = true
        imageView.showAnimatedGradientSkeleton()
        if let cachedImage = ImageCacheManager.shared.image(for: urlString) {
            imageView.image = cachedImage
            self.selectedImages.append(cachedImage)
            imageView.hideSkeleton()
            imageView.layer.cornerRadius = 4
            return
        }

        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    imageView.image = image
                    self.selectedImages.append(image) // 이미지를 selectedImages 배열에 추가
                }
            }
        }.resume()
        imageView.hideSkeleton()
    }
}
