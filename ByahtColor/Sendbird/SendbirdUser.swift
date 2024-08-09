//
//  SendbirdUser.swift
//  ByahtColor
//
//  Created by jaem on 7/23/24.
//

import Foundation
import SendbirdChatSDK

public class SendbirdUser {

    public static let shared = SendbirdUser()

    @UserDefault(key: "sendbird_auto_login", defaultValue: false)
    public private(set) var isAutoLogin: Bool

    @UserDefault(key: "sendbird_user_id", defaultValue: nil)
    public private(set) var userId: String?

    public var currentUser: SendbirdChatSDK.User? {
        SendbirdChat.getCurrentUser()
    }

    private init() { }

    public func login(userId: String,
                      completion: @escaping (Result<SendbirdChatSDK.User, SBError>) -> Void) {
        SendbirdChat.connect(userId: userId) { [weak self] user, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = user else { return }

            self?.registerPushTokenIfNeeded()
            self?.storeUserInfo(user)
            completion(.success(user))
        }
    }

    public func logout(completion: @escaping () -> Void) {
        SendbirdChat.disconnect { [weak self] in
            self?.isAutoLogin = false
            completion()
        }
    }

    public func unReadMessages(completion: @escaping (Result<Int, SBError>) -> Void) {
        SendbirdChat.getTotalUnreadChannelCount { count, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            completion(.success(Int(count)))
        }
    }

    public func updateUserInfo(nickname: String?, profileImage: Data?, completion: @escaping (Result<Void, SBError>) -> Void) {
        let params = UserUpdateParams()

        params.nickname = nickname
        params.profileImageData = profileImage

        SendbirdChat.updateCurrentUserInfo(params: params, completionHandler: { error in
            if let error = error {
                completion(.failure(error))
                return
            }

            completion(.success(()))
        })
    }

    private func registerPushTokenIfNeeded() {
        guard let pushToken = SendbirdChat.getPendingPushToken() else {
            return
        }

        SendbirdChat.registerDevicePushToken(pushToken, unique: true) { status, error in
            if let error = error {
                print("APNS registration failed. \(error)")
                return
            }

            if status == .pending {
                print("Push registration is pending.")
            } else {
                print("APNS Token is registered.")
            }
        }
    }

    private func storeUserInfo(_ user: SendbirdChatSDK.User) {
        userId = user.userId

        isAutoLogin = true
    }

}
