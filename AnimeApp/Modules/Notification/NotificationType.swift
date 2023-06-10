//
//  NotificationType.swift
//  AnimeApp
//
//  Created by Marat on 05.06.2023.
//

import Foundation

// MARK: - NotificationProtocol
protocol NotificationProtocol: CustomStringConvertible {
    var hasSwitch: Bool { get }
}

// MARK: - NotificationType
enum NotificationType: Int, CaseIterable, CustomStringConvertible {
    case messageNotification
    
    var description: String {
        switch self {
        case .messageNotification:
            return "Messages Notifications"
        }
    }
}

// MARK: - MessageNotifications
enum MessageNotifications: NotificationProtocol {
    case showNotifications
    case exceptions
    
    var description: String {
        switch self {
        case .showNotifications:
            return "Show Notifications"
        case .exceptions:
            return "Exceptions"
        }
    }
    
    var hasSwitch: Bool {
        switch self {
        case .showNotifications:
            return true
        case .exceptions:
            return false
        }
    }
}
