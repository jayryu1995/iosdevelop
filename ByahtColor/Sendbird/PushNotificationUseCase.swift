//
//  PushNotificationUseCase.swift
//  ByahtColor
//
//  Created by jaem on 8/5/24.
//

import Foundation
import SendbirdChatSDK

class PushNotificationUseCase {
    func registerPushToken(deviceToken: Data) {
        SendbirdChat.registerDevicePushToken(deviceToken, unique: true) { status, error in
            if let error = error {
                print("APNS registration failed. \(error)")
                return
            }

            if status == .pending {
                // A token registration is pending.
                // If this status is returned, invoke the registerDevicePushToken:unique:completionHandler:
                // with [SBDMain getPendingPushToken] after connection.
            } else {
                print("APNS Token is registered.")
            }
        }

    }
}
