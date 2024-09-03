//
//  TestView.swift
//  ByahtColor
//
//  Created by jaem on 8/27/24.
//

import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import UIKit
import SnapKit
import Foundation
class TestView: UIViewController {

    private let signInButton = GIDSignInButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        // Google 로그인 버튼 추가
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        view.addSubview(signInButton)

        // Layout using SnapKit
        signInButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    @objc private func didTapSignInButton() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Error: Missing Firebase clientID")
            return
        }

        // Create Google Sign In configuration object with YouTube scope.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign-in flow with YouTube scope
        GIDSignIn.sharedInstance.signIn(withPresenting: self, hint: nil, additionalScopes: ["https://www.googleapis.com/auth/youtube.readonly"]) { [weak self] result, error in
            guard let self = self else { return }
            guard error == nil else {
                self.handleSignInError(error)
                return
            }

            guard let user = result?.user else {
                print("Failed to retrieve user")
                return
            }

            let idToken = user.idToken?.tokenString
            let accessToken = user.accessToken.tokenString

            print("idToken:", idToken ?? "No ID Token")
            print("accessToken:", accessToken)

            // Use the access token to fetch the user's YouTube channels
            YoutubeConfig.shared.fetchYouTubeChannels(accessToken: accessToken) { result in
                switch result {
                case .success(let channels):
                    print("YouTube Channels: \(channels)")
                case .failure(let error):
                    print("Failed to fetch YouTube channels: \(error.localizedDescription)")
                }
            }
        }
    }

    private func handleSignInError(_ error: Error?) {
        if let error = error {
            print("Error during Google Sign-In: \(error.localizedDescription)")
        }
    }
}
