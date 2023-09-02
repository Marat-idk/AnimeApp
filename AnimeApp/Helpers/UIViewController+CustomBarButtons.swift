//
//  UIViewController+CustomBarButtons.swift
//  AnimeApp
//
//  Created by Marat on 29.05.2023.
//

import UIKit
import SnapKit

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
    
    func favoriteRightButton(isFavorited: Bool, with action: Selector) {
        let favoriteImageView = UIImageView()
        favoriteImageView.backgroundColor = .brandBlue
        favoriteImageView.isOpaque = true
        favoriteImageView.image = .heart?.template
        favoriteImageView.tintColor = isFavorited ? .brandRed : .brandWhiteGray
        favoriteImageView.contentMode = .scaleAspectFit
        favoriteImageView.clipsToBounds = true
        
        let button = UIButton()
        button.backgroundColor = .brandBlue
        button.isOpaque = true
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: action, for: .touchUpInside)
        
        button.addSubview(favoriteImageView)
        favoriteImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
}
