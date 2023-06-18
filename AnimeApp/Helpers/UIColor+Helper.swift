//
//  UIColor+Helper.swift
//  AnimeApp
//
//  Created by Marat on 24.04.2023.
//

import UIKit

// MARK: - Custom colors
extension UIColor {
    static let brandDarkBlue = UIColor(hexString: "#1F1D2B")

    static let brandBlue = UIColor(hexString: "#252836")
    
    static let brandLightBlue = UIColor(hexString: "#12CDD9")
    
    static let brandOrange = UIColor(hexString: "#F29D33")
    
    static let brandDarkOrange = UIColor(hexString: "#FF8700")
    
    static let brandGray = UIColor(hexString: "#92929D")
    
    static let brandDarkGray = UIColor(hexString: "#696974")
}

// MARK: - Helpers
extension UIColor {
    convenience init(hexString: String, alpha: Double = 1.0) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)

        let red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (red, green, blue) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (red, green, blue) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (red, green, blue) = (1, 1, 0)
        }
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: CGFloat(255.0 * alpha) / 255.0)
    }

    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: 1.0)
    }
}
