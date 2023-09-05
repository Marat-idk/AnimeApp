//
//  CharacterCollectionViewCell.swift
//  AnimeApp
//
//  Created by Марат on 03.09.2023.
//

import UIKit
import SnapKit
import Kingfisher

// MARK: - CharacterCollectionViewCell
final class CharacterCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: CharacterCollectionViewCell.self)
    
    var character: Character? {
        didSet {
            guard let imgURL = character?.images?.imageURL else { return }
            
            imageView.kf.setImage(with: URL(string: imgURL),
                                  options: [.diskCacheExpiration(.expired),
                                            .memoryCacheExpiration(.expired)])
            nameLabel.text = character?.name
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .brandDarkBlue
        imageView.isOpaque = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .brandDarkBlue
        lbl.isOpaque = true
        lbl.font = .montserratSemiBold(size: 14)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, nameLabel])
        stack.backgroundColor = .brandDarkBlue
        stack.isOpaque = true
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .top
        stack.spacing = 8
        return stack
    }()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layoutIfNeeded()
        imageView.roundCorners(30, corners: .allCorners)
    }
    
    // MARK: - Private methods
    private func setupViews() {
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(60)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
