//
//  BusinessPasswordDto.swift
//  ByahtColor
//
//  Created by jaem on 12/17/24.
//

import Foundation


struct BusinessPasswordDto: Codable {
    let memberId: String
    let currentPassword: String
    let newPassword: String
}
