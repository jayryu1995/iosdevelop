//
//  Magazine.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/09.
//

import UIKit

// MainView
struct MagazineDto: Decodable {
    let no: Int
    let resource: String
}

// MagazineView
struct MagazineList: Decodable {
    let no: Int
    let writer: String
    let imageList: [String]?
    let content: String
    let like_count: Int
    let comment_count: Int
    let isLiked: Bool?
}

struct MagazineLikeDto: Encodable {
    let user_id: String?
    let magazine_id: Int?
}

struct MagazineCommentVO: Decodable {
    let no: Int?
    let magazine_no: Int?
    let nickname: String?
    let content: String?
    let regi_date: String?
    let like_count: Int?
    let depth: Int?
    let isLiked: Bool?
    let imageUrl: String?
}
