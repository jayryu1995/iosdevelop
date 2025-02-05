//
//  CollabReviewDto.swift
//  ByahtColor
//
//  Created by jaem on 12/24/24.
//

import Foundation

struct ReviewDto: Codable {
    let no: Int?
    let userId: String?
    let name: String?
    let collabNo: Int?
    let link: String?
    let sns: String?
    let email: String?
    let snsId: String?
    let state: Int?
    let regi_date: String?
}
