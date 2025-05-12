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
    
    private let shareButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "icon_share"), for: .normal)
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = false
        view.layer.shadowColor   = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2           // alpha 0.2
        view.layer.shadowOffset  = CGSize(width: 0, height: 3.12)
        view.layer.shadowRadius  = 11.25
        return view
    }()
    
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if User.shared.auth ?? 0 > 1 {
            setupBackButton()
        }
        setupWebView()
        
        view.addSubview(loadingView)
        
        setupButtons()
        setupConstraints()
    }
    
    private func setupButtons(){
        view.addSubview(shareButton)
        
        
        // 탭 제스처 생성 및 연결
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(didTapShareButton))
        // 필요하면 탭 횟수나 터치 수 설정 가능
        tapGesture.numberOfTapsRequired = 1
        
        shareButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapShareButton() {
        print("Share 버튼이 눌렸습니다.")
        guard let currentURL = webView.url else {
                    // URL이 아직 로드되지 않았다면 무시
                    return
                }
        
        // 클립보드에 복사
        UIPasteboard.general.string = currentURL.absoluteString
        self.showToast(message: "링크가 복사되었습니다.")

    }
    
    private func setupConstraints(){
        webView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        shareButton.snp.makeConstraints{
            $0.width.height.equalTo(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
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
        
        guard let url = URL(string: "https://glowb.io/\(lang)/portfolio/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("accessToken=\(token)", forHTTPHeaderField: "Cookie")
        request.cachePolicy = .returnCacheDataElseLoad
        webView.load(request)
    }
    
    
}
