//
//  ScoreView.swift
//  AnimeApp
//
//  Created by Марат on 01.09.2023.
//

import UIKit
import SnapKit

// MARK: - ScoreView
final class ScoreView: UIView {
    
    var score: Double {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    private let isBlurBackground: Bool
    
    private let blurScoreContainerView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: effect)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var scoreContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandBlue
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .star?.template
        imageView.tintColor = .brandDarkOrange
        imageView.tintAdjustmentMode = .normal
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var scoreLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .montserratSemiBold(size: 12)
        lbl.text = "\(score)"
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
    
    // MARK: - Inits
    init(frame: CGRect, score: Double, isBlurBackground: Bool) {
        self.score = score
        self.isBlurBackground = isBlurBackground
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    convenience init(score: Double, isBlurBackground: Bool = false) {
        self.init(frame: .zero, score: score, isBlurBackground: isBlurBackground)
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
        if isBlurBackground {
            addSubviews(blurScoreContainerView)
            blurScoreContainerView.contentView.addSubview(stackView)
        } else {
            addSubview(scoreContainerView)
            scoreContainerView.addSubview(stackView)
        }
    }
    
    private func setupConstraints() {
        if isBlurBackground {
            blurScoreContainerView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            scoreContainerView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
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
