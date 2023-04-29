//
//  GradientView.swift
//  AnimeApp
//
//  Created by Marat on 24.04.2023.
//

import UIKit

// MARK: - GradientView
final class GradientView: UIView {
    
    private let colors: [UIColor]
    private let gradientLayer: CAGradientLayer
    
    var locations: [NSNumber]? {
        get {
            gradientLayer.locations
        }
        set {
            gradientLayer.locations = newValue
        }
    }
    
    var startPoint: CGPoint {
        get {
            gradientLayer.startPoint
        }
        set {
            gradientLayer.startPoint = newValue
        }
    }
    
    var endPoint: CGPoint {
        get {
            gradientLayer.endPoint
        }
        set {
            gradientLayer.endPoint = newValue
        }
    }
    
    init(colors: [UIColor]) {
        self.colors = colors
        self.gradientLayer = CAGradientLayer()
        super.init(frame: .zero)
        self.gradientLayer.colors = colors.map { $0.cgColor }
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
