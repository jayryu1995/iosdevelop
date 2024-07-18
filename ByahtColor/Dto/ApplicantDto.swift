//
//  ApplicantDto.swift
//  ByahtColor
//
//  Created by jaem on 4/3/24.
//

// ApplicantDto
struct ApplicantDto: Decodable {
    let no: Int?
    let userId: String?
    let name: String?
    let collabNo: Int?
    let link: String?
    let sns: String?
    let tel: String?
    let email: String?
    let account: Int?
    let address: String?
    let bank: String?
    let state: Int?
    let regi_date: String?
}

struct ApplicantParameter: Encodable {
    let collab_no: Int?
    let state: Int?
}

struct ApplicantCellParameter: Encodable {
    let no: Int?
    let state: Int?
}
