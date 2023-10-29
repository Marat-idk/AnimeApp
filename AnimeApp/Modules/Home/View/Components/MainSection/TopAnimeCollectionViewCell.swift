//
//  TopAnimeCollectionViewCell.swift
//  AnimeApp
//
//  Created by Марат on 31.07.2023.
//

import UIKit
import SnapKit

// MARK: - TopAnimeCollectionViewCell
final class TopAnimeCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: TopAnimeCollectionViewCell.self)
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bigQuestion
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        let fontSize = fontSizeForScreen(small: 10, medium: 13, large: 16)
        lbl.font = .montserratSemiBold(size: fontSize)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        lbl.alpha = 0
        // FIXME: - mock mock, remove it
        lbl.text = "Black Panther: Wakanda Forever"
        
        return lbl
    }()
    
    private lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        let fontSize = fontSizeForScreen(small: 8, medium: 9, large: 12)
        lbl.font = .montserratSemiBold(size: fontSize)
        lbl.textColor = .brandWhiteGray
        lbl.textAlignment = .left
        lbl.alpha = 0
        // FIXME: - mock mock mock, remove it
        lbl.text = "On March 2, 2022" + String(repeating: "abcd ", count: 10)
        return lbl
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        clipsToBounds = true
        
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
        transform = .identity
    }
    
    func transformToLarge(factorX: CGFloat, factorY: CGFloat) {
        transform = CGAffineTransform(scaleX: factorX, y: factorY)
        titleLabel.alpha = 1
        dateLabel.alpha = 1
    }
    
    func transformToNormal() {
        transform = .identity
        titleLabel.alpha = 0
        dateLabel.alpha = 0
    }
    
    // MARK: - Private methods
    private func setupViews() {
        contentView.addSubviews(movieImageView,
                                titleLabel,
                                dateLabel)
    }
    
    private func setupConstraints() {
        movieImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(dateLabel.snp.top)
        }
    }
    
    private func fontSizeForScreen(small: CGFloat, medium: CGFloat, large: CGFloat) -> CGFloat {
        switch UIDevice().screenType {
        case .smallScreen:  return small
        case .mediumScreen: return medium
        case .largeScreen:  return large
        }
    }
}
