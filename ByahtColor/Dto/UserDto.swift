//
//  UserDto.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/16.
//

import Foundation

// LoginController
struct UserDto: Decodable {
    let id: String?
    let name: String?
    let email: String?
    let nickname: String?
    let color: String?
    let image_path: String?
    let height: Int?
    let weight: Int?
    let bio: String?
    let link: String?
    let posts: Int?
    let following: Int?
    let followers: Int?
    let auth: Int
}
