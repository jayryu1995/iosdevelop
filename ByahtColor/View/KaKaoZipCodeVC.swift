//
//  KaKaoZipCodeVC.swift
//  ByahtColor
//
//  Created by jaem on 6/17/24.
//

import UIKit
import WebKit
import SnapKit

class KakaoZipCodeVC: UIViewController {

    // MARK: - Properties
    var webView: WKWebView?
    let indicator = UIActivityIndicatorView(style: .medium)
    let closeButton = UIButton()
    var address = ""

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - UI
    private func configureUI() {
        view.backgroundColor = .white
        setAttributes()
        setContraints()
    }

    private func setAttributes() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callBackHandler")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView?.navigationDelegate = self

        guard let url = URL(string: "https://glowb-gitlab-io-jayryu-c93984486e8b68c6cc1703997e390eeaace0faa8.gitlab.io"),
              let webView = webView
        else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        indicator.startAnimating()
        closeButton.setImage(UIImage(named: "icon_Arrow"), for: .normal)
        closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
    }

    private func setContraints() {
        guard let webView = webView else { return }
        view.addSubview(webView)
        view.addSubview(closeButton)
        webView.addSubview(indicator)

        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }

        webView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(closeButton.snp.bottom).offset(10)
        }

    }

    @objc private func handleCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension KakaoZipCodeVC: WKScriptMessageHandler, WKNavigationDelegate {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let data = message.body as? [String: Any] {
            address = data["roadAddress"] as? String ?? ""
        }
        if let navController = self.presentingViewController as? UINavigationController,
           let presentingVC = navController.topViewController as? BusinessSignUpVC {
            presentingVC.address = address
            self.dismiss(animated: true, completion: nil)
        } else {
            print("Failed to pass address")
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}
