//
//  UIViewController+CustomBackButton.swift
//  AnimeApp
//
//  Created by Marat on 29.05.2023.
//

import UIKit

extension UIViewController {
    func customBackButton(with action: Selector) {
        let view = UIView()
        view.backgroundColor = .brandBlue
        view.layer.cornerRadius = 12
        
        let imageView = UIImageView(image: UIImage(named: "arrow-back"))
        
        view.addSubview(imageView)
        view.snp.makeConstraints { $0.size.equalTo(32) }
        imageView.snp.makeConstraints { $0.edges.equalToSuperview().inset(8) }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(tapGesture)
        
        let backButton = UIBarButtonItem(customView: view)
        navigationItem.leftBarButtonItem = backButton
    }
}
