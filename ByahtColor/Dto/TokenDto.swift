//
//  TokenDto.swift
//  ByahtColor
//
//  Created by jaem on 1/20/25.
//

import Foundation


struct TokenDto : Codable{
    let memberId: String
    let accessToken : String
    let refreshToken : String
    var isFirstLogin : Bool = false
    
}
