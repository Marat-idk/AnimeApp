//
//  LanguageSection.swift
//  AnimeApp
//
//  Created by Марат on 11.06.2023.
//

import Foundation

// MARK: - LanguageMenuCellType
protocol LanguageMenuCellType: CaseIterable, CustomStringConvertible {
    var isSelectable: Bool { get }
    var hasSeparator: Bool { get }
    var isLast: Bool { get }
}

extension LanguageMenuCellType {
    var isSelectable: Bool { return true }
    var hasSeparator: Bool { return false }
    var isLast: Bool { return false }
}

// MARK: - LanguageSection
enum LanguageSection: Int, CaseIterable, CustomStringConvertible {
    case suggestedLanguages
    case otherLanguages
    
    var description: String {
        switch self {
        case .suggestedLanguages:
            return "Suggested Languages"
        case .otherLanguages:
            return "Other Languages"
        }
    }
}

// MARK: - SuggestedLanguagesOptions
enum SuggestedLanguagesOptions: LanguageMenuCellType {
    case englishUK
    case english
    case bahasaIndonesia
    case mock
    case mock2
    case mock3
    case mock4
    case mock5
    
    var description: String {
        switch self {
        case .englishUK:
            return "English (UK)"
        case .english:
            return "English"
        case .bahasaIndonesia:
            return "Bahasa Indonesia"
        case .mock: return "mock"
        case .mock2: return "mock2"
        case .mock3: return "mock3"
        case .mock4: return "mock4"
        case .mock5: return "mock5"
        }
    }
    
    var hasSeparator: Bool {
        switch self {
        case .englishUK, .english:
            return true
        case .bahasaIndonesia:
            return true
            // TODO: to delete
        default:
            return true
        }
    }
    
    var isLast: Bool {
        switch self {
        case .englishUK, .english:
            return false
        case .mock5:
            return true
            // TODO: to delete
        default:
            return false
        }
    }
}

enum OtherLanguagesOptions: LanguageMenuCellType {
    case chineses
    case croatian
    case czech
    case danish
    case filipino
    case finnish
    
    case mock
    case mock2
    case mock3
    case mock4
    case mock5
    
    var description: String {
        switch self {
        case .chineses:
            return "Chineses"
        case .croatian:
            return "Croatian"
        case .czech:
            return "Czech"
        case .danish:
            return "Danish"
        case .filipino:
            return "Filipino"
        case .finnish:
            return "Finnish"
        case .mock: return "mock"
        case .mock2: return "mock2"
        case .mock3: return "mock3"
        case .mock4: return "mock4"
        case .mock5: return "mock5"
        }
    }
    
    var hasSeparator: Bool {
        switch self {
//        case .finnish:
//            return false
        case .mock5:
            return false
        default:
            return true
        }
    }
    
    var isLast: Bool {
        switch self {
        case .mock5:
            return true
        default:
            return false
        }
    }
}
