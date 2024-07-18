//
//  File.swift
//  ByahtColor
//
//  Created by jaem on 6/11/24.
//
import Foundation

struct Talk: Identifiable, Decodable {
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
