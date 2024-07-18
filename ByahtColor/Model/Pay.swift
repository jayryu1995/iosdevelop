//
//  Pay.swift
//  ByahtColor
//
//  Created by jaem on 6/25/24.
//

import Foundation

struct Pay: Codable {
    let sns: Int?
    let cash: String?
    let type: Int? // 0: 영상 1: 사진
    let currency: String?
    let negotiable: Bool?
}
