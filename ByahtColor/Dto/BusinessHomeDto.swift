//
//  BusinessHomeDto.swift
//  ByahtColor
//
//  Created by jaem on 7/3/24.
//

import Foundation

struct BusinessHomeDto: Codable {
    let influenceProfileDtos: [InfluenceProfileDto]?
    let snapDtoList: [CollabDto]?
}
