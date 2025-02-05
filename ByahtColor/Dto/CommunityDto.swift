//
//  BoardDto.swift
//  ByahtColor
//
//  Created by jaem on 2024/01/16.
//

import Foundation

// WriteBoardVC
struct CommunityDto: Encodable {
    let id: String?
    let nickname: String?
    let regi_date: Date?
    let title: String?
    let content: String?
    let like_count: Int?
    let comment_count: Int?
    let filePath: String?
}

struct CommunityRequestDTO: Encodable {
    let user_id: String?
}

struct CommunityLikeDto: Encodable {
    let user_id: String?
    let community_id: Int?
}

struct CommunityCommentVO: Decodable {
    let no: Int?
    let writer_id: String?
    let community_no: Int?
    let nickname: String?
    let content: String?
    let regi_date: String?
    let like_count: Int?
    let depth: Int?
    let isLiked: Bool?
    let imageUrl: String?
}

struct ReceiveCommunity: Decodable {
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
