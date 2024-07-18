//
//  InfluenceProfileDto.swift
//  ByahtColor
//
//  Created by jaem on 6/25/24.
//

import Foundation

struct InfluenceProfileDto: Codable {
    let memberId: String?
    let snsList: [Sns]?
    let payList: [Pay]?
    let experienceList: [Experience]?
    let age: String?
    let category: String?
    let gender: String?
    let intro: String?
    let name: String?
    let imagePath: String?
}
