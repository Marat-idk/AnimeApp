//
//  UIView+Helper.swift
//  AnimeApp
//
//  Created by Marat on 24.04.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
