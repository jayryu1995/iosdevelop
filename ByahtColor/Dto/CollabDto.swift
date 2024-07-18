//
//  SnapDto.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/23.
//

import Foundation

// CollabVC
struct CollabDto: Codable {
    let no: Int?
    let id: String?
    let nickname: String?
    let content: String?
    let link: String?
    let title: String?
    let info: String?
    let regi_date: String?
    let start_date: String?
    let end_date: String?
    let like_count: Int?
    let comment_count: Int?
    let style: String?
    let profileImage: String?
    let coupon_code: String?
    let imageList: [String]?
    let isLiked: Bool?
    let isFollowing: Bool?
    let isCollabed: Bool?
    let height: Int?
    let weight: Int?
    let facebook: Bool?
    let tiktok: Bool?
    let instagram: Bool?
    let shopee: Bool?
    let state: Bool?
    let people: Int?
    let application_state: Int?
    let notification: Bool
}

struct CollabRequestDTO: Encodable {
    let user_id: String?
    let styles: [String]?
    let sns: [String]?
}

// SnapCommentVC
struct CollabCommentVO: Decodable {
    let no: Int?
    let snap_no: Int?
    let nickname: String?
    let content: String?
    let regi_date: String?
    let like_count: Int?
    let depth: Int?
    let isLiked: Bool?
    let imageUrl: String?
}

struct CollabLikeDto: Encodable {
    let user_id: Int?
    let magazine_id: Int?
}
