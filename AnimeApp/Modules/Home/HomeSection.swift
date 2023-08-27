//
//  HomeSection.swift
//  AnimeApp
//
//  Created by Марат on 03.08.2023.
//

import UIKit

// MARK: - HomeSectionType
protocol HomeSectionType: CaseIterable, CustomStringConvertible {
    var hasButton: Bool { get }
    var buttonTitle: String { get }
    var width: CGFloat { get }
    var height: CGFloat { get }
}

// MARK: - HomeCellType
protocol HomeCellType: CaseIterable, CustomStringConvertible {
    var width: CGFloat { get }
    var height: CGFloat { get }
}

// MARK: - Default implementation
extension HomeCellType {
    var description: String { "" }
}

// MARK: - HomeSection
enum HomeSection: Int, HomeSectionType {
    case main
    case categories
    case mostPopular
    
    var description: String {
        switch self {
        case .main:
            // FIXME: - remove it
            return "mock mock mock"
        case .categories:
            return "Categories"
        case .mostPopular:
            return "Most popular"
        }
    }
    
    var hasButton: Bool {
        switch self {
        case .mostPopular:
            return true
        default:
            return false
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .mostPopular:
            return "See All"
        default:
            return ""
        }
    }
    
    var width: CGFloat {
        switch self {
        case .categories, .mostPopular:
            return UIScreen.main.bounds.width
        default:
            return .zero
        }
    }
    var height: CGFloat {
        switch self {
        case .categories, .mostPopular:
            return 30.0
        default:
            return .zero
        }
    }
}

// MARK: - MainCells
enum MainCells: Int, HomeCellType {
    case personal
    case search
    case carausel
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    private var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    var width: CGFloat {
        switch self {
        case .personal, .search:
            return screenWidth - 48
        case .carausel:
            return screenWidth
        }
    }
    
    var height: CGFloat {
        switch self {
        case .personal, .search:
            return 40
        case .carausel:
            return screenHeight * 0.1891 + 20
        }
    }
}

// MARK: - CategoriesCells
enum CategoriesCells: Int, HomeCellType {
    case genre
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var width: CGFloat {
        switch self {
        case .genre:
            return screenWidth
        }
    }
    
    var height: CGFloat {
        switch self {
        case .genre:
            return 30.0
        }
    }
}

// MARK: - MostPopularCells
enum MostPopularCells: Int, HomeCellType {
    case mostPopular
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var width: CGFloat {
        return screenWidth
    }
    
    // FIXME: - MOCK remove it
    var height: CGFloat {
        return 230.0
    }
}
