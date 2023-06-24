//
//  MenuLogoutCollectionViewCell.swift
//  AnimeApp
//
//  Created by Marat on 20.05.2023.
//

import UIKit
import SnapKit

protocol MenuLogoutCollectionViewCellDelegate: AnyObject {
    func logoutButtonTapped()
}

// MARK: - MenuLogoutCollectionViewCell
final class MenuLogoutCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: MenuLogoutCollectionViewCell.self)
    
    var delegate: MenuLogoutCollectionViewCellDelegate?
    
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
        btn.addTarget(self, action: #selector(logoutButtonTapped(_:)), for: .touchUpInside)
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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: layoutAttributes.frame.height)
        
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .required
        )
        
        return layoutAttributes
    }
    
    @objc private func logoutButtonTapped(_ sender: UIButton) {
        delegate?.logoutButtonTapped()
    }
    
}
