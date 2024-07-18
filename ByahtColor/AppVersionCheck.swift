//
//  AppVersionCheck.swift
//  ByahtColor
//
//  Created by jaem on 2023/07/13.
//

import UIKit

// 오류 열거형 타입 enum 선언
enum VersionError: Error {
  case invalidResponse, invalidBundleInfo
}

class AppVersionCheck {
    var window: UIWindow?
    let appID = "6450734094"

    // 스토어 버전 확인
    func fetchLatestAppStoreVersion(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://itunes.apple.com/kr/lookup?id=\(self.appID)") else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results.first?["version"] as? String else {
                completion(nil)
                return
            }
            completion(appStoreVersion)
        }

        task.resume()
    }
    // 업데이트 해야 하는지 비교
    // 매개변수에 nowVersion, latestVersion넣은 이유는 임의의 값을 넣은 테스트코드를 작성하기 위해서 넣었습니다.
    func shouldUpdate(nowVersion: String?,
                      latestVersion: String?) -> Bool {

        guard
            let nowVersion = nowVersion,
            let storeVersion = latestVersion
        else { return false }

        let nowVersionArr = nowVersion.split(separator: ".").map { $0 }
        let storeVersionArr = storeVersion.split(separator: ".").map { $0 }

        // Major 또는 Minor 자리가 최신 버전보다 작으면 -> 업데이트 필요
        if nowVersionArr[0] < storeVersionArr[0] ||
            nowVersionArr[1] < storeVersionArr[1] ||
            nowVersionArr[2] < storeVersionArr[2] {
            return true
        }

        return false
    }
}
extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
