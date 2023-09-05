//
//  PosterBackgroundView.swift
//  AnimeApp
//
//  Created by Марат on 29.08.2023.
//

import UIKit
import SnapKit

// MARK: - PosterBackgroundView
final class PosterBackgroundView: UIView {

    private var anime: Anime
    
    private let shadowGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.brandDarkBlue.withAlphaComponent(0.0).cgColor,
                         UIColor.brandDarkBlue.withAlphaComponent(0.3).cgColor,
                        UIColor.brandDarkBlue.withAlphaComponent(0.0).cgColor]
        
        layer.locations = [0.0, 0.3, 1.0]

        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 0.0, y: 1.0)
        return layer
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.2
        imageView.clipsToBounds = true
        imageView.layer.mask = shadowGradientLayer
        return imageView
    }()
    
    // MARK: - Inits
    init(frame: CGRect, anime: Anime) {
        self.anime = anime
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        posterImageView.kf.setImage(with: URL(string: anime.images?.largeImageURL ?? ""))
    }
    
    convenience init(anime: Anime) {
        self.init(frame: .zero, anime: anime)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowGradientLayer.frame = posterImageView.bounds
    }
    
    // MARK: - Private methods
    private func setupViews() {
        addSubview(posterImageView)
    }
    
    private func setupConstraints() {
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
