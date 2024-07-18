//
//  UserData.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/08.
//

import Foundation

class User: Encodable {
    static let shared = User()

    var id: String?
    var name: String?
    var email: String?
    var nickname: String?
    var home: Int?
    var example: Int?
    var auth: Int?
    private init() {} // private 생성자로 외부에서 인스턴스 생성을 방지합니다.

    func updateUserData(id: String?, email: String?, name: String?) {
        self.id = id
        self.email = email
        self.name = name
    }

    func updateNickName(nickname: String?) {
        self.nickname = nickname
    }

    func updateAuth(auth: Int) {
        self.auth = auth
    }

}
