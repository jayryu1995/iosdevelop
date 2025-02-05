//
//  TokenDto.swift
//  ByahtColor
//
//  Created by jaem on 1/20/25.
//

import Foundation


struct TokenDto : Decodable{
    let accessToken : String
    let refreshToken : String
}
