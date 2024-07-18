//
//  RequestCollabVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/03/05.
//

import UIKit
import SnapKit
import FloatingPanel
import Alamofire
import FirebaseMessaging

class RequestCollabVC: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate {
    weak var delegate: RequestCollabVCDelegate?
    private let scrollView = UIScrollView()

    private let snsLabel: UILabel = {
        let label = UILabel()
        label.text = "Nền tảng MXH của bạn"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Địa chỉ email"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let emailField: UnderlinedTextField = {
        let field = UnderlinedTextField()
        field.configure(withPlaceholder: "Nhập địa chỉ email", font: UIFont(name: "Pretendard-Regular", size: 14))
        return field
    }()

    private let linkLabel: UILabel = {
        let label = UILabel()
        label.text = "Link tài khoản MXH"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let linkField: UnderlinedTextField = {
        let field = UnderlinedTextField()
        field.configure(withPlaceholder: "Nhập địa chỉ Link", font: UIFont(name: "Pretendard-Regular", size: 14))
        return field
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Họ và tên"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let nameField: UnderlinedTextField = {
        let field = UnderlinedTextField()
        field.configure(withPlaceholder: "Nhập tên đầy đủ", font: UIFont(name: "Pretendard-Regular", size: 14))
        return field
    }()

    private let bankLabel: UILabel = {
        let label = UILabel()
        label.text = "Ngân hàng"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let bankButton: UIButton = {
        let button = UIButton()
        button.setTitle("Chọn ngân hành", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        button.setTitleColor(UIColor(hex: "#BCBDC0"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "#BCBDC0").cgColor
        button.setImage(UIImage(named: "arrow_down"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    private let refundsLabel: UILabel = {
        let label = UILabel()
        label.text = "Số tài khoản"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let refundsField: UnderlinedTextField = {
        let field = UnderlinedTextField()
        field.configure(withPlaceholder: "Nhập số tài khoản ngân hàng", font: UIFont(name: "Pretendard-Regular", size: 14))
        field.keyboardType = .numberPad
        return field
    }()

    private let telLabel: UILabel = {
        let label = UILabel()
        label.text = "Số điện thoại"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let telField: UnderlinedTextField = {
        let field = UnderlinedTextField()
        field.configure(withPlaceholder: "Nhập số điện thoại có thể liên lạc được với chủ tài khoản", font: UIFont(name: "Pretendard-Regular", size: 14))
        field.keyboardType = .numberPad
        return field
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Địa chỉ"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let addressField: UnderlinedTextField = {
        let field = UnderlinedTextField()
        field.configure(withPlaceholder: "Nhập địa chỉ chủ tài khoản", font: UIFont(name: "Pretendard-Regular", size: 14))
        return field
    }()

    private let submitButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.backgroundColor = UIColor(hex: "#BCBDC0")
        button.setTitleColor(.white, for: .normal)
        button.setTitle("ĐĂNG KÝ", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Mideum", size: 14)
        button.layer.cornerRadius = 4
        return button
    }()
    private var snsButtons = [UIButton]()
    private var selectedSns: String = ""
    private var activityIndicator: UIActivityIndicatorView!
    var tags: [String] = []
    var collab_no = 0

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // 버튼의 너비에 따라 이미지의 edge insets을 설정합니다.
        // 여기서는 이미지의 너비를 24로 가정하고 오른쪽 여백을 16으로 가정합니다.
        if (bankButton.imageView?.frame.width) != nil {
            bankButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            bankButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: bankButton.bounds.width - 30, bottom: 0, right: 0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBackButton2()
        self.navigationItem.title = "ĐĂNG KÝ"
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        emailField.delegate = self
        linkField.delegate = self
        nameField.delegate = self
        refundsField.delegate = self
        telField.delegate = self
        addressField.delegate = self

        view.addSubview(scrollView)
        view.addSubview(submitButton)

        scrollView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview()
        }

        submitButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().offset(-20)
        }

        setScrollContentView()

        // 화면 탭 시 키보드 숨김 추가
        setupHideKeyboardOnTap()

        // 스피너 초기화 및 설정
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
    }

    private func setScrollContentView() {

        bankButton.addTarget(self, action: #selector(bankButtonTapped), for: .touchUpInside)

        submitButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)

        scrollView.addSubview(emailField)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(linkField)
        scrollView.addSubview(linkLabel)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(nameField)
        scrollView.addSubview(telLabel)
        scrollView.addSubview(telField)
        scrollView.addSubview(addressLabel)
        scrollView.addSubview(addressField)

        // SNS 필터 뷰 추가
        let snsFilterView = snsFilterView(tags: tags)
        scrollView.addSubview(snsFilterView)

        snsFilterView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        emailLabel.snp.makeConstraints {
            $0.top.equalTo(snsFilterView.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }

        emailField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }

        linkLabel.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }

        linkField.snp.makeConstraints {
            $0.top.equalTo(linkLabel.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(linkField.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }

        nameField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }

        telLabel.snp.makeConstraints {
            $0.top.equalTo(nameField.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }

        telField.snp.makeConstraints {
            $0.top.equalTo(telLabel.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }

        addressLabel.snp.makeConstraints {
            $0.top.equalTo(telField.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }

        addressField.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().offset(-102)
        }

    }

    // 유효성 검사
    private func validateSubmissionCriteria() {
        let textFieldsAreValid = !(emailField.text?.isEmpty ?? true) &&
        !(nameField.text?.isEmpty ?? true) &&
        // !(refundsField.text?.isEmpty ?? true) &&
        !(telField.text?.isEmpty ?? true) &&
        !(addressField.text?.isEmpty ?? true) &&
        !(emailField.text?.isEmpty ?? true) &&
        !(linkField.text?.isEmpty ?? true)

        let snsIsSelected = !(selectedSns.isEmpty)

        submitButton.isEnabled = textFieldsAreValid && snsIsSelected
        submitButton.backgroundColor = submitButton.isEnabled ? UIColor.black : .gray
        if submitButton.isEnabled {
            submitButton.setTitle("ĐĂNG KÝ", for: .normal)
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }

    private func createHorizontalStackView(tags: [String]) -> UIStackView {
           let horizontalStackView = UIStackView()
           horizontalStackView.axis = .horizontal
           horizontalStackView.distribution = .fillProportionally
           horizontalStackView.alignment = .fill
           horizontalStackView.spacing = 5
           horizontalStackView.isUserInteractionEnabled = true
           for tagName in tags {
               let tagButton = UIButton()
               tagButton.setTitle(tagName, for: .normal)
               tagButton.backgroundColor = .white
               tagButton.setTitleColor(.black, for: .normal)
               tagButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
               tagButton.layer.cornerRadius = 16
               tagButton.layer.borderWidth = 1
               tagButton.layer.borderColor = UIColor.darkGray.cgColor
               tagButton.isUserInteractionEnabled = true

               tagButton.addTarget(self, action: #selector(snsButtonTapped), for: .touchUpInside)
               horizontalStackView.addArrangedSubview(tagButton)
               snsButtons.append(tagButton)

               tagButton.snp.makeConstraints {
                   $0.height.equalTo(32)
               }
           }

           return horizontalStackView
       }

    // SNS 선택
    @objc private func snsButtonTapped(_ sender: UIButton) {
        // 선택된 스타일의 상태를 업데이트합니다.
        if sender.isSelected {
            // 현재 버튼이 이미 선택된 상태라면 선택을 해제합니다.
            sender.isSelected = false
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            selectedSns = ""
        } else {
            // 모든 버튼을 순회하며 상태를 업데이트합니다.
            snsButtons.forEach { button in
                // 현재 탭된 버튼만 선택된 상태로 설정하고, 나머지는 해제합니다.
                let isSelected = (button == sender)
                button.isSelected = isSelected
                button.backgroundColor = isSelected ? .black : .white
                button.setTitleColor(isSelected ? .white : .black, for: .normal)

                // 선택된 SNS를 업데이트합니다.
                if isSelected {
                    selectedSns = sender.titleLabel?.text ?? ""
                }
            }
        }
        validateSubmissionCriteria()
    }

    @objc private func bankButtonTapped() {
        showFloatingPanel()
    }

    private func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // 이 옵션은 다른 컨트롤(예: 버튼)에 대한 탭을 방해하지 않도록 설정
        view.addGestureRecognizer(tapGesture)
    }

    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }

    private func snsFilterView(tags: [String]) -> UIView {
        let container = createFilterViewContainer(withTitle: "Nền tảng của ảnh đã đăng", tags: tags)
        return container
    }

    private func createFilterViewContainer(withTitle title: String, tags: [String]) -> UIView {
        let container = UIView()
        container.isUserInteractionEnabled = true

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        container.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalSpacing
        verticalStackView.alignment = .fill
        verticalStackView.spacing = 10
        verticalStackView.isUserInteractionEnabled = true

        // 모든 태그를 처리하도록 개선
        let rows = tags.chunked(into: tags.count) // 태그 배열을 4개 단위로 분할
        for rowTags in rows {
            let rowStackView = createHorizontalStackView(tags: rowTags)
            verticalStackView.addArrangedSubview(rowStackView)
        }

        container.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview() // VerticalStackView의 바텀을 container의 바텀에 연결
        }

        return container
    }

    // 업로드 버튼 액션
    private func uploadContents() {

        self.activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false

        let url = "\(Bundle.main.TEST_URL)/collab/application/insert"
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        let user_id = User.shared.id ?? ""
        let name: String = nameField.text!
        let sns: String = selectedSns
        let email: String = emailField.text!
        let link: String = linkField.text!
        let bank: String = bankButton.titleLabel?.text ?? ""
        let account: String = "0"
        let tel: String = telField.text!
        let address: String = addressField.text!
        let collab_no: String = "\(collab_no)"

        // MultipartFormData를 사용하여 요청 생성
        AF.upload(multipartFormData: { multipartFormData in
            // 텍스트 데이터 추가
            multipartFormData.append(Data(user_id.utf8), withName: "user_id")
            multipartFormData.append(Data(collab_no.utf8), withName: "collab_no")
            multipartFormData.append(Data(name.utf8), withName: "name")
            multipartFormData.append(Data(sns.utf8), withName: "sns")
            multipartFormData.append(Data(email.utf8), withName: "email")
            multipartFormData.append(Data(link.utf8), withName: "link")
            multipartFormData.append(Data(bank.utf8), withName: "bank")
            multipartFormData.append(Data(account.utf8), withName: "account")
            multipartFormData.append(Data(address.utf8), withName: "address")
            multipartFormData.append(Data(tel.utf8), withName: "tel")

        }, to: url, method: .post, headers: headers).responseString { response in
            switch response.result {
            case .success(let stringValue):
                self.view.isUserInteractionEnabled = true
                self.delegate?.didCompleteDataTransfer(data: true)
                self.navigationController?.popViewController(animated: true)

            case .failure(let error):
                self.view.isUserInteractionEnabled = true
                self.log(message: "Upload failed with error: \(error)")
            }
        }
    }

    @objc private func uploadButtonTapped() {
        let alertVC = ApplicationAlertVC()
        alertVC.modalPresentationStyle = .overCurrentContext // 현재 뷰 컨트롤러 위에 표시
        alertVC.modalTransitionStyle = .crossDissolve // 부드러운 전환 효과
        alertVC.onSuccess = { [weak self] in
            // 확인 버튼을 탭했을 때 실행할 코드
            self?.uploadContents()
            Messaging.messaging().subscribe(toTopic: "\(self!.collab_no)") { _ in
                self?.log(message: "Subscribed to \(self!.collab_no) topic")
            }
        }
        self.present(alertVC, animated: true, completion: nil)
    }
}

protocol RequestCollabVCDelegate: AnyObject {
    func didCompleteDataTransfer(data: Bool) // 필요한 데이터 타입으로 변경 가능
}

extension RequestCollabVC: FloatingPanelControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == telField {
            // 숫자와 삭제(backspace) 허용
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet) || string.isEmpty
        }

        if textField == refundsField {
            // 숫자와 삭제(backspace) 허용
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet) || string.isEmpty
        }

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        validateSubmissionCriteria()
    }

    func floatingPanelWillBeginAttracting(_ fpc: FloatingPanelController, to state: FloatingPanelState) {

        if state == FloatingPanelState.tip {
            fpc.removePanelFromParent(animated: true)
        }
    }

    func showFloatingPanel() {
        let fpc = FloatingPanelController()
        fpc.delegate = self
        let contentVC = BankVC() // 패널에 표시할 컨텐츠 뷰 컨트롤러
        contentVC.onBankSelected = { selectedBank in
            print(selectedBank)
            self.bankButton.setTitle("\(selectedBank)", for: .normal)
            self.bankButton.setTitleColor(.black, for: .normal)
            self.view.layoutIfNeeded()
        }
        fpc.set(contentViewController: contentVC)
        fpc.layout = CustomFloatingPanel()
        fpc.move(to: .full, animated: true) // 패널을 반 정도의 높이로 이동
        fpc.addPanel(toParent: self)
    }

    // UITextFieldDelegate 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드를 숨깁니다.
        return true
    }

}
