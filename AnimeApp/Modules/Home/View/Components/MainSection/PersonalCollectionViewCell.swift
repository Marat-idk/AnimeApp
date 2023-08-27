//
//  PersonalCollectionViewCell.swift
//  AnimeApp
//
//  Created by Марат on 22.07.2023.
//

import UIKit
import SnapKit

// MARK: - PersonalCollectionViewCell
final class PersonalCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: PersonalCollectionViewCell.self)
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.isOpaque = true
        imageView.image = .home
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.cornerCurve = .continuous
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .brandDarkBlue
        lbl.isOpaque = true
        lbl.text = UserService.shared.userPersonal.firstName
        lbl.font = .montserratSemiBold(size: 16)
        lbl.textColor = .white
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .brandDarkBlue
        lbl.isOpaque = true
        lbl.text = "Let’s stream your favorite movie"
        lbl.font = .montserratSemiBold(size: 12)
        lbl.textColor = .brandGray
        lbl.textAlignment = .left
        return lbl
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 4
        return stack
    }()
    
    private let favoriteContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandBlue
        view.layer.cornerRadius = 12
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .brandBlue
        imageView.isOpaque = true
        imageView.image = .heart?.template
        imageView.tintColor = .brandRed
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageView,
                                                   verticalStackView,
                                                   favoriteContainerView])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Private methods
    private func setupViews() {
        favoriteContainerView.addSubview(favoriteImageView)
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        
        favoriteContainerView.snp.makeConstraints {
            $0.size.equalTo(32)
        }
        
        favoriteImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
