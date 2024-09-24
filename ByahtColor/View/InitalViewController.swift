//
//  InitalViewController.swift
//  ByahtColor
//
//  Created by jaem on 2023/08/24.
//

import UIKit
import Alamofire
import FBSDKLoginKit
import FBSDKCoreKit

class InitialViewController: UIViewController {
    private let viewControllerName = String(describing: type(of: InitialViewController.self))
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let viewModel = BusinessViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {

            let appVersionCheck = AppVersionCheck()

            // 버전 확인
            appVersionCheck.fetchLatestAppStoreVersion { appStoreVersion in

                DispatchQueue.main.async {
                    if let version = appStoreVersion {
                        if appVersionCheck.shouldUpdate(nowVersion: appVersion, latestVersion: version) {

                            self.presentUpdateAlertVC()
                        } else {

                            self.setupSearchData()
                            
                        }
                    } else {
                        self.log(message: "update_str2".localized)
                    }
                }
            }
        } else {
            self.log(message: "[Error] Can not find current version. ")
        }

    }

    private func setupSearchData(){
        viewModel.getSearchProfile(sns: nil, category: nil, nation: nil) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    print(data.count)
                    let vc = LoginVC()
                    self?.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error):
                    print("통신 에러 : \(error)")
                }
            }
        }
    }
    
    // 앱 스토어 연결 //
    private func presentUpdateAlertVC() {
        let appID = Bundle.main.AppID
        let alertVC = UIAlertController(title: "update_str".localized, message: "update_str1".localized, preferredStyle: .alert)
        let alertAtion = UIAlertAction(title: "update_str".localized, style: .default) { _ in
            guard let url = URL(string: "itms-apps://itunes.apple.com/app/\(appID)") else { return }
            // canOpenURL(_:) - 앱이 URL Scheme 처리할 수 있는지 여부를 나타내는 Boolean 값을 리턴한다.
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        alertVC.addAction(alertAtion)

        DispatchQueue.main.async {
            // 비동기 작업을 메인 스레드에서 실행
            self.present(alertVC, animated: true)
        }
    }

}
