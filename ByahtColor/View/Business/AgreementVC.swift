//
//  AgreementVC.swift
//  ByahtColor
//
//  Created by jaem on 7/5/24.
//

import UIKit
import SnapKit
import Foundation

class AgreementVC: UIViewController, UIScrollViewDelegate {
    weak var delegate: AgreementVCDelegate?
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("agree".localized, for: .normal)
        button.setBackgroundColor(UIColor.black, for: .normal)
        return button
    }()

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let content: [(String, String)] = [("agree_1".localized, "agree_1_1".localized), ("agree_2".localized, "agree_2_1".localized)]
    var index = 0

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        view.backgroundColor = .white

        setupBackButton2()
        setupUI()
        setupContent()
        setupConstraints()
    }

    private func setupContent() {
        let selectedContent = content[index]
        label.text = selectedContent.0
        contentLabel.text = selectedContent.1
    }

    private func setupUI() {
        view.addSubview(scrollView)
        view.addSubview(button)
        scrollView.addSubview(contentView)
        contentView.addSubview(label)
        contentView.addSubview(contentLabel)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.greaterThanOrEqualTo(scrollView).priority(.low)
        }

        label.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-120)
        }

        button.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().inset(62)
        }
    }

    @objc private func buttonTapped() {
            delegate?.didAgree(with: index)
            navigationController?.popViewController(animated: true)
        }
}
protocol AgreementVCDelegate: AnyObject {
    func didAgree(with index: Int)
}
