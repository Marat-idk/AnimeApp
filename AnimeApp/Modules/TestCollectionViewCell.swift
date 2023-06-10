//
//  TestCollectionViewCell.swift
//  AnimeApp
//
//  Created by Marat on 07.05.2023.
//

import UIKit
import SnapKit

final class TestCollectionViewCell: UICollectionViewCell {
   
    static let identifier = String(describing: TestCollectionViewCell.self)
    
    var viewModel: String? {
        didSet {
            testLabel.text = viewModel
        }
    }
    
    private let testLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .ubuntuMedium(size: 16)
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has notbeen implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        testLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        setNeedsLayout()
        layoutIfNeeded()
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize,
                                                       withHorizontalFittingPriority: .required,
                                                       verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
    private func setupViews() {
        contentView.addSubview(testLabel)
    }
    
    private func setupConstraints() {
        testLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}
