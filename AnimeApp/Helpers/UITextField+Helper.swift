//
//  UITextField+Helper.swift
//  AnimeApp
//
//  Created by Marat on 24.04.2023.
//

import UIKit

extension UITextField {
    
    func underlined(color: UIColor) {
        let subView = UIView()
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.backgroundColor = color
        self.addSubview(subView)
        NSLayoutConstraint.activate(
            [
                subView.leadingAnchor.constraint(equalTo: leadingAnchor),
                subView.trailingAnchor.constraint(equalTo: trailingAnchor),
                subView.bottomAnchor.constraint(equalTo: bottomAnchor),
                subView.heightAnchor.constraint(equalToConstant: 1.0)
            ]
        )
    }
    
}
