//
//  PopupType.swift
//  AnimeApp
//
//  Created by Марат on 08.07.2023.
//

import UIKit

// MARK: - PopupType
enum PopupType {
    case logout
    case paymentSuccess
    
    var title: String {
        switch self {
        case .logout:
            return "Are you sure ?"
        case .paymentSuccess:
            return "Your payment has\ncompleted!"
        }
    }
    
    var description: String {
        switch self {
        case .logout:
            return "Ullamcorper imperdiet urna id non sed est\nsem. Rhoncus amet, enim purus gravida\ndonec aliquet."
        case .paymentSuccess:
            return "Ullamcorper imperdiet urna id non sed est\nsem. Rhoncus amet, enim purus gravida\ndonec aliquet."
        }
    }
    
    var image: UIImage? {
        switch self {
        case .logout:
            return .bigQuestion
        case .paymentSuccess:
            return .done
        }
    }
    
    var doneButtonTitle: String {
        switch self {
        case .logout:
            return "Log Out"
        case .paymentSuccess:
            return "OK"
        }
    }
    
    var cancelButtonTitle: String {
        switch self {
        case .logout:
            return "Cancel"
        case .paymentSuccess:
            return ""
        }
    }
    
    var doneButtonBackgroundColor: UIColor {
        switch self {
        case .logout:
            return .brandBlue
        case .paymentSuccess:
            return .brandLightBlue
        }
    }
    
    var cancelButtonBackgroundColor: UIColor {
        switch self {
        case .logout:
            return .brandLightBlue
        case .paymentSuccess:
            return .brandLightBlue
        }
    }
}
