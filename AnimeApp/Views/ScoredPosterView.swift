//
//  ScoredPosterView.swift
//  AnimeApp
//
//  Created by Марат on 13.08.2023.
//

import UIKit
import SnapKit

// MARK: - ScorePosition
enum ScorePosition {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

// MARK: - ScoredPosterView
final class ScoredPosterView: UIView {
    
    private var scorePosition: ScorePosition = .topRight
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let blurScoreContainerView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: effect)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .star?.template
        imageView.tintColor = .brandOrange
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let scoreLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .montserratSemiBold(size: 12)
        lbl.textColor = .brandDarkOrange
        lbl.textAlignment = .center
        lbl.setContentCompressionResistancePriority(.required, for: .horizontal)
        return lbl
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [starImageView, scoreLabel])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()
    
    // MARK: - Init
    convenience init(frame: CGRect = .zero, scorePosition: ScorePosition) {
        self.init(frame: frame)
        self.scorePosition = scorePosition
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Private methods
    private func setupViews() {
        addSubview(posterImageView)
        
        posterImageView.addSubview(blurScoreContainerView)
        
        blurScoreContainerView.contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        blurScoreContainerView.snp.makeConstraints { [unowned self] in
            
            switch self.scorePosition {
            case .bottomLeft, .bottomRight:
                $0.bottom.equalToSuperview().offset(-8)
            case .topLeft, .topRight:
                $0.top.equalToSuperview().offset(8)
            }

            switch self.scorePosition {
            case .topLeft, .bottomLeft:
                $0.left.equalToSuperview().offset(8)
            case .topRight, .bottomRight:
                $0.right.equalToSuperview().offset(-8)
            }
            $0.height.equalTo(24)
        }
        
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
        
        starImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
}
