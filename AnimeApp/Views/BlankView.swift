//
//  BlankView.swift
//  AnimeApp
//
//  Created by Марат on 26.10.2023.
//

import UIKit
import SnapKit

// MARK: - BlankView
final class BlankView: UIView {
    private let type: BlankType
    
    private lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = type.image
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .montserratSemiBold(size: 16)
        label.text = type.title
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .montserratMedium(size: 12)
        label.text = type.description
        label.textColor = .brandGray
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews:
                                    [
                                        imageView,
                                        titleLabel,
                                        descriptionLabel
                                    ])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        
        stack.setCustomSpacing(16, after: imageView)
        stack.setCustomSpacing(8, after: titleLabel)
        
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return stack
    }()
    
    // MARK: Init
    init(frame: CGRect, type: BlankType) {
        self.type = type
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: BlankType) {
        self.init(frame: .zero, type: type)
    }
    
    // MARK: Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: Private methods
    private func setupViews() {
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(76)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
