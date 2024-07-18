//
//  Global.swift
//  ByahtColor
//
//  Created by jaem on 7/11/24.
//

import Foundation

class Globals {
    static let shared = Globals()

    // 전역에서 사용하는 변수 선언
    let categories = [
        "categories_beauty".localized,
        "categories_fasion".localized,
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

    private init() {} // 외부에서 인스턴스를 생성하지 못하도록 합니다.
}
