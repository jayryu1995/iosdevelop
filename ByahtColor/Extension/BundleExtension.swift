//
//  BundleExtension.swift
//  ByahtColor
//
//  Created by jaem on 2023/07/14.
//

import Foundation

extension Bundle {
    var ChatApiKey: String {
        guard let file = self.path(forResource: "InfoAppID", ofType: "plist") else { return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["SendbirdAppID"] as? String else { fatalError("API_KEY 설정을 확인해주세요.")}
        return key
    }

    var AppID: String {
        guard let file = self.path(forResource: "InfoAppID", ofType: "plist") else { return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["APP_ID"] as? String else { fatalError("APP ID를 가져오지 못 했습니다..")}
        return key
    }

    var SERVER_URL: String {
        guard let file = self.path(forResource: "InfoAppID", ofType: "plist") else { return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["SERVER_URL"] as? String else { fatalError("APP ID를 가져오지 못 했습니다..")}

        return key
    }

    var TEST_URL: String {
        guard let file = self.path(forResource: "InfoAppID", ofType: "plist") else { return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["TEST_URL"] as? String else { fatalError("APP ID를 가져오지 못 했습니다..")}

        return key
    }
}
