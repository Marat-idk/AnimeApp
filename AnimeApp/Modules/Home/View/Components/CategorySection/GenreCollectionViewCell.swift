//
//  GenreCollectionViewCell.swift
//  AnimeApp
//
//  Created by Марат on 06.08.2023.
//

import UIKit
import SnapKit

// MARK: - GenreCollectionViewCell
final class GenreCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: GenreCollectionViewCell.self)
    
    var genre: Genre? {
        didSet {
            guard let genre = genre else { return }
            
            genreLabel.text = genre.name
            
            if let isSelected = genre.isSelected {
                let backgroundColor: UIColor = isSelected ? .brandBlue : .brandDarkBlue
                let cornerRadius: CGFloat = isSelected ? 8.0 : 0.0
                let textColor: UIColor = isSelected ? .brandLightBlue: .brandWhiteGray
                
                containerView.backgroundColor = backgroundColor
                containerView.layer.cornerRadius = cornerRadius
                genreLabel.textColor = textColor
            }
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            genre?.isSelected = isSelected
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandDarkBlue
        view.isOpaque = true
        view.layer.masksToBounds = true
        return view
    }()
    
    private let genreLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .montserratMedium(size: 14)
        lbl.textColor = .brandWhiteGray
        lbl.textAlignment = .center
        return lbl
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .brandDarkBlue
        isOpaque = true
        
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
        genreLabel.text = nil
    }
    
    // MARK: - Private methods
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(genreLabel)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        genreLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
    }
}
