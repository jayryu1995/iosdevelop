//
//  BoardDto.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/16.
//

import Foundation

// WriteBoardVC
struct BoardDto: Encodable {
    let id: String?
    let nickname: String?
    let regi_date: Date?
    let title: String?
    let content: String?
    let like_count: Int?
    let comment_count: Int?
}

struct BoardRequestDTO: Encodable {
    let user_id: String?
}

struct BoardLikeDto: Encodable {
    let user_id: String?
    let board_id: Int?
}

struct BoardCommentVO: Decodable {
    let no: Int?
    let writer_id: String?
    let board_no: Int?
    let nickname: String?
    let content: String?
    let regi_date: String?
    let like_count: Int?
    let depth: Int?
    let isLiked: Bool?
    let imageUrl: String?
}

struct ReceiveBoard: Decodable {
    let no: Int?
    let id: String?
    let nickname: String?
    let profileImage: String?
    let regi_date: String?
    let title: String?
    let content: String?
    let like_count: Int?
    let comment_count: Int?
    let isLiked: Bool?
    let notification: Bool
    let imageList: [String]?
}
