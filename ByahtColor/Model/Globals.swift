//
//  Global.swift
//  ByahtColor
//
//  Created by jaem on 7/11/24.
//

import Foundation

class Globals {
    static let shared = Globals()

    var searchList : [InfluenceProfileDto]?
    
    // 전역에서 사용하는 변수 선언
    let categories = [
        "categories_beauty".localized,
        "categories_fashion".localized,
        "categories_daily".localized,
        "categories_travel".localized,
        "categories_baby".localized,
        "categories_food".localized,
        "categories_etc".localized
    ]

    let ages = [
        "ages_10".localized,
        "ages_20".localized,
        "ages_30".localized,
        "ages_40".localized,
        "ages_50".localized
    ]

    let genders = [
        "gender_male".localized,
        "gender_female".localized
    ]

    let nations = [
        "nation_ko".localized,
        "nation_jp".localized,
        "nation_th".localized,
        "nation_ph".localized,
        "nation_vi".localized,
        "nation_sg".localized,
        "nation_global".localized
    ]
    
    
    // 기업
    let nations2 = [
        "nation_ko".localized,
        "nation_jp".localized,
        "nation_th".localized,
        "nation_ph".localized,
        "nation_vi".localized,
        "nation_sg".localized,
    ]

    let sns = [
        "TikTok".localized,
        "Instagram".localized,
        "Facebook".localized,
        "Naver".localized,
        "Youtube".localized
    ]

    private init() {} // 외부에서 인스턴스를 생성하지 못하도록 합니다.
}
