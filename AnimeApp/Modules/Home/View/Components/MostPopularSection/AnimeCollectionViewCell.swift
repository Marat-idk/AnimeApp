//
//  AnimeCollectionViewCell.swift
//  AnimeApp
//
//  Created by Марат on 13.08.2023.
//

import UIKit
import SnapKit
import Kingfisher

// MARK: - AnimeCollectionViewCell
final class AnimeCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: AnimeCollectionViewCell.self)
    
    var anime: Anime? {
        didSet {
            guard let anime = anime else { return }
            
            titleLabel.text = anime.title
            genreLabel.text = anime.genresText
            
            posterView.posterImageView.kf.setImage(with: URL(string: anime.images?.largeImageURL ?? ""))
            posterView.scoreLabel.text = "\(anime.score)"
        }
    }
    
    private let posterView: ScoredPosterView = {
        let poster = ScoredPosterView(scorePosition: .topRight)
        return poster
    }()
    
    private let detailsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandBlue
        return view
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .brandBlue
        lbl.isOpaque = true
        lbl.text = "Spider-Man No way home"
        lbl.font = .montserratSemiBold(size: 14)
        lbl.textColor = .white
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let genreLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .brandBlue
        lbl.isOpaque = true
        lbl.text = "Action"
        lbl.font = .montserratMedium(size: 10)
        lbl.textColor = .brandGray
        lbl.textAlignment = .left
        return lbl
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, genreLabel])
        stack.backgroundColor = .brandBlue
        stack.isOpaque = true
        
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 4
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
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
        contentView.addSubviews(
            posterView,
            detailsContainerView
        )
        
        detailsContainerView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        posterView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.bottom.equalTo(detailsContainerView.snp.top)
        }
        
        detailsContainerView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(4)
            $0.top.equalToSuperview().offset(12)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}
