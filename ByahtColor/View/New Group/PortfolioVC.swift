//
//  PortfolioVC.swift
//  ByahtColor
//
//  Created by jaem on 4/10/25.
//
import UIKit
import Foundation
import SnapKit
import WebKit
class PortfolioVC : UIViewController , WKNavigationDelegate {
    
    private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let view = WKWebView(frame: .zero, configuration: config)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy private var chatButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "chat_button"), for: .normal)
        view.imageView?.contentMode = .scaleAspectFill
        view.layer.shadowColor = UIColor.black.cgColor          // 그림자 색
        view.layer.shadowOpacity = 0.3                          // 불투명도
        view.layer.shadowOffset = CGSize(width: 0, height: 4)   // 그림자 위치
        view.layer.shadowRadius = 6                             // 흐림 정도
        view.layer.masksToBounds = false
        view.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return view
    }()
    
    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.9) // 살짝 반투명도 예뻐
        view.isUserInteractionEnabled = false
        
        let activity = UIActivityIndicatorView(style: .large)
        activity.startAnimating()
        view.addSubview(activity)
        
        activity.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        return view
    }()
    
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        setupWebView()
        view.addSubview(chatButton)
        view.addSubview(loadingView)
        setupConstraints()
    }
    
    
    
    private func setupConstraints(){
        webView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        
        chatButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-70)
            $0.width.height.equalTo(view.snp.width).multipliedBy(0.25)
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview() // ✅ 전체 화면 덮게
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.removeFromSuperview()
    }
    
    @objc private func buttonTapped(_Sender : UIButton){
        self.navigationController?.popViewController(animated: false)
    }
    
    private func setupWebView() {
        
        webView.navigationDelegate = self
        view.addSubview(webView)
        // ✅ 여기서 User-Agent 설정 → 완료되면 load 실행
        webView.evaluateJavaScript("navigator.userAgent") { [weak self] result, error in
            guard let self = self else { return }
            
            if let defaultUA = result as? String {
                self.webView.customUserAgent = defaultUA + " wv"
            } else {
                print("기본 User-Agent 가져오기 실패: \(error?.localizedDescription ?? "알 수 없음")")
            }
            
            // ✅ customUserAgent 설정 후 로드 시작
            self.loadURLWithToken()
        }
    }
    
    private func loadURLWithToken() {
        let lang = getLanguage()
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        
        guard let url = URL(string: "https://glowb-frontend-glowb-ai.vercel.app/\(lang)/portfolio/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("accessToken=\(token)", forHTTPHeaderField: "Cookie")
        request.cachePolicy = .returnCacheDataElseLoad
        webView.load(request)
    }
    
}
