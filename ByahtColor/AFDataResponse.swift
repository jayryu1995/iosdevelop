//
//  AFDataResponse.swift
//  ByahtColor
//
//  Created by jaem on 2023/07/12.
//

import Foundation

struct AFDataResponse<T: Codable>: Codable {
    let result_code: Int
    let result_message: String
    let result: [T]

    enum CodingKeys: String, CodingKey {
        case result_code, result_message, result
    }
}
