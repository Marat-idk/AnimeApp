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
    
    fileprivate func setPasswordToggleImage(_ button: UIButton) {
        if self.isSecureTextEntry {
            button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            button.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    
    func enablePasswordToggle() {
        let button = UIButton(type: .custom)
        setPasswordToggleImage(button)
        button.addTarget(self, action: #selector(togglePasswordView(_:)), for: .touchUpInside)
        button.tintColor = .black
        self.rightView = button
        self.rightViewMode = .always
    }
    
    @objc func togglePasswordView(_ sender: UIButton) {
         self.isSecureTextEntry.toggle()
         setPasswordToggleImage(sender)
     }
    
}
