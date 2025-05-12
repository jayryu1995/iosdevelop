//
//  NotificationDataDto.swift
//  ByahtColor
//
//  Created by jaem on 4/22/25.
//

import Foundation
enum NotificationType: String, Codable {
    case SYSTEM
    case SIGNUP_ALERT
    case THREE_DAYS_ALERT
    case SEVEN_DAYS_ALERT
    
}

struct NotificationDataDto: Codable {
    let id: Int64
    let content: String
    let read: Bool
    let createdAt: Date
    let type: NotificationType
    let senderId: String?
    let imageUrl: String?
}
