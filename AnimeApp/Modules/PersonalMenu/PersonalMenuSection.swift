//
//  PersonalMenuSection.swift
//  AnimeApp
//
//  Created by Marat on 14.05.2023.
//

import Foundation
import UIKit

// MARK: - PersonalMenuRowType
protocol PersonalMenuCellType: CaseIterable, CustomStringConvertible {
    var isSelectable: Bool { get }
    var hasSeparator: Bool { get }
    var isLast: Bool { get }
    var isHighlighted: Bool { get }
    var imageName: String { get }
}

extension PersonalMenuCellType {
    var isSelectable: Bool { return false }
    var hasSeparator: Bool { return false }
    var isLast: Bool { return false }
    var isHighlighted: Bool { return false }
    var imageName: String { return "" }
}

// MARK: - PersonalMenuSection
enum PersonalMenuSection: Int, CaseIterable, CustomStringConvertible {
    case profileEdit
    case account
    case general
    case more
    case logout
    
    var description: String {
        switch self {
        case .profileEdit:
            return ""
        case .account:
            return "Account"
        case .general:
            return "General"
        case .more:
            return "More"
        case .logout:
            return ""
        }
    }
}

// MARK: - ProfileEditOptions
enum ProfileEditOptions: Int, PersonalMenuCellType {
    case profileEdit
    
    var description: String {
        return ""
    }
}

// MARK: - AccountOptions
enum AccountOptions: Int, PersonalMenuCellType {
    case member
    case changePassword
    
    var description: String {
        switch self {
        case .member:
            return "Member"
        case .changePassword:
            return "Change Password"
        }
    }
    
    var isSelectable: Bool {
        return true
    }
    
    var hasSeparator: Bool {
        switch self {
        case .member:
            return true
        case .changePassword:
            return false
        }
    }
    
    var isLast: Bool {
        switch self {
        case .member:
            return false
        case .changePassword:
            return true
        }
    }
    
    var isHighlighted: Bool {
        switch self {
        case .member:
            return true
        case .changePassword:
            return false
        }
    }
    
    var imageName: String {
        switch self {
        case .member:
            return "ic-profile"
        case .changePassword:
            return "ic-padlock"
        }
    }
}

// MARK: - GeneralOptions
enum GeneralOptions: Int, PersonalMenuCellType {
    case notification
    case language
    case country
    case clearCache
    
    var description: String {
        switch self {
        case .notification:
            return "Notification"
        case .language:
            return "Language"
        case .country:
            return "Country"
        case .clearCache:
            return "Clear Cache"
        }
    }
    
    var isSelectable: Bool {
        return true
    }
    
    var hasSeparator: Bool {
        switch self {
        case .notification, .language, .country:
            return true
        case .clearCache:
            return false
        }
    }
    
    var isLast: Bool {
        switch self {
        case .notification, .language, .country:
            return false
        case .clearCache:
            return true
        }
    }
    
    var isHighlighted: Bool {
        return false
    }
    
    var imageName: String {
        switch self {
        case .notification:
            return "ic-bell"
        case .language:
            return "ic-globe"
        case .country:
            return "ic-flag"
        case .clearCache:
            return "ic-trash-bin"
        }
    }
}

// MARK: - MoreOptions
enum MoreOptions: Int, PersonalMenuCellType {
    case legalAndPolicies
    case helpFeedback
    case aboutUs
    
    var description: String {
        switch self {
        case .legalAndPolicies:
            return "Legal and Policies"
        case .helpFeedback:
            return "Help & Feedback"
        case .aboutUs:
            return "About Us"
        }
    }
    
    var isSelectable: Bool {
        return true
    }
    
    var hasSeparator: Bool {
        switch self {
        case .legalAndPolicies, .helpFeedback:
            return true
        case .aboutUs:
            return false
        }
    }
    
    var isLast: Bool {
        switch self {
        case .legalAndPolicies, .helpFeedback:
            return false
        case .aboutUs:
            return true
        }
    }
    
    var isHighlighted: Bool {
        return false
    }
    
    var imageName: String {
        switch self {
        case .legalAndPolicies:
            return "ic-shell"
        case .helpFeedback:
            return "ic-question"
        case .aboutUs:
            return "ic-alert"
        }
    }
}

enum LogoutOptions: Int, PersonalMenuCellType {
    case logout
    
    var description: String {
        return "logout"
    }
    
}
