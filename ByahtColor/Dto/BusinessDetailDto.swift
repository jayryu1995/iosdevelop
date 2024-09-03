//
//  BusinessDetailDto.swift
//  ByahtColor
//
//  Created by jaem on 7/4/24.
//

import Foundation

struct BusinessDetailDto: Codable {
    let memberId: String?
    let business_name: String?
    let intro: String?
    let payDtos: [Pay]?
    let age: String?
    let category: String?
    let gender: String?
    let nation: String?
    let imagePath: String?
    let proposal: Bool?
}
