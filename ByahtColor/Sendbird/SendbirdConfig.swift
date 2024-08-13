//
//  SendbirdConfig.swift
//  ByahtColor
//
//  Created by jaem on 7/23/24.
//

import Foundation
import SendbirdChatSDK
public class SendbirdConfig {

    public enum ApplicationId {
        case sample
        case custom(String)

        var rawValue: String {
            switch self {
            case .sample:
                return "68512DA8-3A78-4E3A-837E-160D4762AF8A"
            case .custom(let value):
                return value
            }
        }
    }

    public static func initializeSendbirdSDK() {
        let initParams = InitParams(
            applicationId: "68512DA8-3A78-4E3A-837E-160D4762AF8A",
            isLocalCachingEnabled: true,
            logLevel: .error,
            appVersion: "1.0.0"
        )
        SendbirdChat.initialize(params: initParams)
    }

}
