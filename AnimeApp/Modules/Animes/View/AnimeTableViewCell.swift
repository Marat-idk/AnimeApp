//
//  AnimeTableViewCell.swift
//  AnimeApp
//
//  Created by Марат on 01.10.2023.
//

import UIKit
import SnapKit
import Kingfisher

// MARK: - AnimeTableViewCell
final class AnimeTableViewCell: UITableViewCell {
    static let identifier = String(describing: AnimeTableViewCell.self)
    
    var anime: Anime? {
        didSet {
            guard let anime = anime else { return }
            posterView.posterImageView.kf.setImage(with: URL(string: anime.images?.imageURL ?? "" ),
                                                   options: [.diskCacheExpiration(.expired)])
            posterView.score = anime.score
            
            titleLabel.text = anime.title
            dateDescriptionItemView.title = anime.releaseYear ?? "unknown"
            durationDescriptionItemView.title = anime.duration ?? "unknown"
            filmDescriptionItemView.title = anime.majorGenre ?? "unknown"
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandDarkBlue
        return view
    }()
    
    private lazy var posterView: ScoredPosterView = {
        let poster = ScoredPosterView(scorePosition: .topLeft, score: 5.78)
        poster.roundCorners(8)
        return poster
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .brandDarkBlue
        lbl.isOpaque = true
        lbl.font = .montserratSemiBold(size: 16)
        lbl.textColor = .white
        lbl.textAlignment = .left
        return lbl
    }()
    
    private lazy var dateDescriptionItemView: DescriptionItemView = {
        let view = DescriptionItemView(icon: .calendar, title: anime?.releaseYear ?? "")
        view.iconTintColor = .brandGray
        return view
    }()
    
    private lazy var durationDescriptionItemView: DescriptionItemView = {
        let view = DescriptionItemView(icon: .clock, title: anime?.duration ?? "")
        view.iconTintColor = .brandGray
        return view
    }()
    
    private lazy var filmDescriptionItemView: DescriptionItemView = {
        let view = DescriptionItemView(icon: .film, title: anime?.majorGenre ?? "")
        view.iconTintColor = .brandGray
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel,
                                                   dateDescriptionItemView,
                                                   durationDescriptionItemView,
                                                   filmDescriptionItemView
                                                  ])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        stack.spacing = 14
        return stack
    }()
    
    // MARK: Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        backgroundColor = .brandDarkBlue
        contentView.backgroundColor = .brandDarkBlue
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: Private methods
    private func setupViews() {
        contentView.addSubview(containerView)
        
        containerView.addSubviews(posterView, stackView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        posterView.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
            $0.width.equalTo(112)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalTo(posterView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview()
        }
    }
}
