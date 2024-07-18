//
//  BankVC.swift
//  ByahtColor
//
//  Created by jaem on 2024/03/06.
//

import UIKit
import Alamofire
import SnapKit

class BankVC: UIViewController {
    private let bankList: [String] = [
        "SAIGONBANK (Sài Gòn Công Thương)",
        "SHB BANK (Sài Gòn Hà Nội)",
        "SACOMBANK (Sài Gòn Thương Tín)",
        "TECHCOMBANK (Kỹ thương Việt Nam)",
        "TPBANK (Tiên Phong)",
        "VIETA BANK (Việt Á)",
        "VIETCOMBANK (Ngoại Thương Việt Nam)",
        "VIB BANK (Quốc tế Việt Nam)",
        "VP BANK (Việt Nam Thịnh Vượng)",
        "VIETINBANK (Công Thương Việt Nam)",
        "LIEN VIET POST BANK (Bưu Điện Liên Việt)",
        "MB BANK (Quân Đội)",
        "NAM A BANK (Nam Á)",
        "OCB BANK (Phương Đông)",
        "SCB BANK (TMCP Sài Gòn)",
        "AGRIBANK (Nông nghiệp &amp; Phát triển Nông thôn Việt Nam)",
        "BAC A BANK (Bắc Á)",
        "BIDV BANK (Đầu tư và Phát triển Việt Nam)",
        "DONGA BANK (Đông Á)",
        "HD BANK (TMCP Phát Triển HCM)",
        "HSBC BANK",
        "Standard Chartered Bank Vietnam (SCVN)",
        "SEABANK (Đông Nam Á)",
        "VIETBANK (Việt Nam Thương Tín)",
        "MSB BANK (Hàng Hải Việt nam)",
        "OCEANBANK (Đại Dương)",
        "PUBLIC BANK VIETNAM (PBVN)",
        "PG BANK (Xăng Dầu Petrolimex)",
        "PVCOMBANK (Đại Chúng Việt Nam)",
        "CCF (Quỹ Tín dụng Nhân dân Trung ương)",
        "VID PUBLIC (Ngân hàng Liên doanh VID Public)",
        "STANDARD CHARTERED (SCVN)",
        "ANZ BANK (ANZ Việt Nam)",
        "CITI BANK (Citibank Việt Nam)",
        "SOUTHERN BANK (Phương Nam)",
        "VBSP BANK (Ngân hàng Chính sách Xã hội Việt Nam)",
        "VDB BANK (Phát triển Việt Nam)",
        "ABBANK (An Bình)",
        "ACB BANK (Á Châu)",
        "BAOVIET BANK (Bảo Việt)",
        "CBBANK (Xây Dựng Việt Nam )",
        "CIMB BANK",
        "EXIMBANK (Xuất nhập khẩu Việt Nam)",
        "GP BANK (Dầu Khí Toàn Cầu)",
        "DBS Bank Ltd - Chi nhanh TP.HCM - Chuyển thường (Regular)",
        "SHINHAN BANK (Shinhan Việt Nam)",
        "VIET CAPITAL BANK (Bản Việt)",
        "INDOVINA BANK (IVB)",
        "KIENLONG BANK (Kiên Long)",
        "NCB BANK (Quốc Dân)",
        "NONGHYUP BANK - Chi nhánh Hà Nội",
        "KEB Hana Bank - Chuyển thường (Regular)",
        "WOORI BANK (Woori Việt Nam)",
        "IBK - Hà Nội (Công Nghiệp Hàn Quốc)",
        "IBK - HCM (Công Nghiệp Hàn Quốc)",
        "UNITED OVERSEAS BANK (UOB)",
        "MIZUHO (Mizuho)",
        "Ca-CIB (Crédit Agricole)",
        "VIET - LAO BANK (Ngân hàng Việt - Lào)",
        "VRB BANK (Ngân hàng Việt - Nga)",
        "VIET - THAI BANK (Ngân hàng Việt - Thái)",
        "SUMITOMO MITSUI BANK",
        "Cong nghiep Han Quoc - Chuyển thường (Regular)",
        "CO-OP BANK - Chuyển thường (Regular)",
        "VRB BANK (Liên doanh Việt Nga)",
        "COMMONWEALTH BANK",
        "TRUSTBANK (Đại Tín)",
        "DEUTSCHE BANK VIETNAM",
        "BIDC (Đầu tư và Phát triển Campuchia)",
        "CCF BANK (Quĩ Tín dụng Nhân dân Trung Ương (CCF))",
        "HONG LEONG BANK (HLBVN)",
        "TOKYO -MITSUBISHI (Tokyo-Mitsubishi UFJ)",
        "HONG LEONG BANK (HLBVN)"
    ]
    private var filteredBankList: [String] = []
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let searchField = UnderlinedTextField()
    private let submitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_submit"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private var selectedBank = ""
    var onBankSelected: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTitleLabel()
        setupSearchField()
        setupTableView()
        setSubmitButton()
    }

    private func setupSearchField() {
        searchField.delegate = self
        filteredBankList = bankList // 초기에는 모든 은행 목록을 표시
        searchField.configure(withPlaceholder: "Nhập tên ngân hàng.", font: UIFont(name: "Pretendard-Regular", size: 14))
        view.addSubview(searchField)
        searchField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.height.equalTo(40)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    private func setSubmitButton() {
        submitButton.backgroundColor = .black
        submitButton.setTitle("Áp dụng nào", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 4
        submitButton.titleLabel?.font = UIFont(name: "Pretendard-Mideum", size: 14)
        submitButton.titleLabel?.textAlignment = .center
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func setupTitleLabel() {
        // titleLabel 설정
        titleLabel.text = "Ngân hàng"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    private func setupTableView() {

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
        }

        // TableView 기본 설정
        tableView.register(BankTableViewCell.self, forCellReuseIdentifier: "BankTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc private func submitButtonTapped() {
        onBankSelected?(selectedBank)
        dismiss(animated: true)
    }
}

extension BankVC: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 사용자가 셀을 탭했을 때의 처리
        selectedBank = filteredBankList[indexPath.row]
        print(selectedBank)
        // 선택된 은행 이름을 처리하거나 다음 화면으로 넘기는 로직을 여기에 추가
    }

    // 테이블 뷰 데이터 소스 메서드: 섹션당 행의 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return filteredBankList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀을 재사용 큐에서 가져옴
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankTableViewCell", for: indexPath) as! BankTableViewCell

        cell.label.text = "\(filteredBankList[indexPath.row])"
        return cell
    }

    // UITextFieldDelegate 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드를 숨깁니다.
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        filterContentForSearchText(searchText)
        return true
    }

    // 검색 실행 로직
    func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            filteredBankList = bankList
        } else {
            filteredBankList = bankList.filter { bankName in
                return bankName.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData() // 테이블 뷰 갱신
    }
}
