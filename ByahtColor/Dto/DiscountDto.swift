//
//  BeautyDto.swift
//  ByahtColor
//
//  Created by jaem on 5/16/24.
//

import Foundation

struct DiscountDto: Decodable {
    let no: Int?
    let id: String?
    let nickname: String?
    let content: String?
    let title: String?
    let start_date: String?
    let end_date: String?
    let type: String?
    let link: String?
    let profileImage: String?
    let imageList: [String]?
    let state: Bool
    let notification: Bool
}
