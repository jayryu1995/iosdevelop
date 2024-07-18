//
//  Member.swift
//  ByahtColor
//
//  Created by jaem on 6/18/24.
//

import Foundation

struct Member: Codable {
    let id: String
    let auth: Int?
    let regi_date: String?
    var state: Bool = false
}
