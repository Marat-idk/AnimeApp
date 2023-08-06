//
//  UIDevice+Helper.swift
//  AnimeApp
//
//  Created by Marat on 30.04.2023.
//

import UIKit

extension UIDevice {
    static var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIphone5Family: Bool {
        return !isIpad && UIScreen.main.bounds.width == 320.0
    }
    
    enum ScreenType {
        case smallScreen
        case mediumScreen
        case largeScreen
    }
    
    var screenType: ScreenType {
        switch UIScreen.main.bounds.width {
        case 320:
            return .smallScreen
        case 320...375:
            return .mediumScreen
        default:
            return .largeScreen
        }
    }
}
