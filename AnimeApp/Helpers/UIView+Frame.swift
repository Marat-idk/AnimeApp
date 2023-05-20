//
//  UIView+Frame.swift
//  AnimeApp
//
//  Created by Marat on 14.05.2023.
//

import UIKit

extension UIView {
    
    func roundCorners(_ radius: CGFloat, corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        
        layer.mask = shape
    }
}
