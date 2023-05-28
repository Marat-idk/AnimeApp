//
//  UIImage+Helper.swift
//  AnimeApp
//
//  Created by Marat on 21.05.2023.
//

import UIKit

// MARK: - UIImage
extension UIImage {
    var template: UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}
