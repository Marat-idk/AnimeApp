//
//  DescriptionItemView.swift
//  AnimeApp
//
//  Created by Марат on 29.08.2023.
//

import UIKit
import SnapKit

// MARK: - DescriptionItemView
final class DescriptionItemView: UIView {
    
    private let icon: UIImage?
    private let title: String
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = icon
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .montserratMedium(size: 12)
        lbl.text = title
        lbl.textColor = .brandGray
        lbl.textAlignment = .center
        lbl.setContentCompressionResistancePriority(.required, for: .horizontal)
        return lbl
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 4
        return stack
    }()

    // MARK: - Inits
    init(frame: CGRect, icon: UIImage?, title: String) {
        self.icon = icon
        self.title = title
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    convenience init(icon: UIImage?, title: String) {
        self.init(frame: .zero, icon: icon, title: title)
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
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(16).priority(.high)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(16)
        }
    }
}
