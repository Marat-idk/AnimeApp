//
//  MenuLogoutCollectionViewCell.swift
//  AnimeApp
//
//  Created by Marat on 20.05.2023.
//

import UIKit
import SnapKit

// MARK: - MenuLogoutCollectionViewCell
final class MenuLogoutCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: MenuLogoutCollectionViewCell.self)
    
    private lazy var logoutButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .brandDarkBlue
        btn.setTitle("Log Out", for: .normal)
        btn.setTitleColor(.brandLightBlue, for: .normal)
        btn.setTitleColor(.brandBlue, for: .highlighted)
        btn.titleLabel?.font = .montserratSemiBold(size: 16)
        btn.layer.cornerRadius = 32
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.brandLightBlue.cgColor
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(logoutButton)
    }
    
    private func setupConstraints() {
        logoutButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
