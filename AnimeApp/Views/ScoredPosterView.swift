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
    var score: Double {
        didSet {
            scoreView.score = score
        }
    }
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var scoreView: ScoreView = {
        let view = ScoreView(score: score, isBlurBackground: true)
        return view
    }()
    
    // MARK: - Init
    init(frame: CGRect, scorePosition: ScorePosition, score: Double) {
        self.scorePosition = scorePosition
        self.score = score
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    convenience init(scorePosition: ScorePosition, score: Double) {
        self.init(frame: .zero, scorePosition: scorePosition, score: score)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Private methods
    private func setupViews() {
        addSubview(posterImageView)
        posterImageView.addSubview(scoreView)
    }
    
    private func setupConstraints() {
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scoreView.snp.makeConstraints { [unowned self] in
            
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
    }
}
