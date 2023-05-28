//
//  MenuCollectionViewCell.swift
//  AnimeApp
//
//  Created by Marat on 15.05.2023.
//

import UIKit

// MARK: - MenuCollectionViewCell
final class MenuCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: MenuCollectionViewCell.self)
    
    private var isLast: Bool? {
        didSet {
            
            guard let isLast = isLast else {
                return
            }
            
            if isLast {
                containerView.layer.cornerRadius = 16
                containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                containerView.layer.borderColor = UIColor.brandBlue.cgColor
                containerView.layer.borderWidth = 1
            } else {
                containerView.layer.cornerRadius = 0
                containerView.layer.borderColor = UIColor.brandBlue.cgColor
                containerView.layer.borderWidth = 1
            }
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandDarkBlue
        view.isOpaque = true
        return view
    }()
    
    private let plugView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandDarkBlue
        view.isOpaque = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .brandBlue
        imgView.contentMode = .center
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .brandDarkBlue
        lbl.font = .montserratMedium(size: 14)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.isOpaque = true
        return lbl
    }()
    
    private let arrowImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .brandDarkBlue
        imgView.image = UIImage(named: "arrow-forward")?.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = .brandLightBlue
        imgView.contentMode = .scaleAspectFit
        imgView.isOpaque = true
        return imgView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandBlue
        view.isOpaque = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isLast = false
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isLast = nil
        iconImageView.image = nil
        titleLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.layer.cornerRadius = 16
        if isLast == false {
            let leftLayer = CALayer()
            leftLayer.backgroundColor = UIColor.brandBlue.cgColor
            leftLayer.frame = CGRect(x: bounds.minX, y: bounds.minY, width: 1, height: bounds.height)
            
            let rightLayer = CALayer()
            rightLayer.backgroundColor = UIColor.brandBlue.cgColor
            rightLayer.frame = CGRect(x: bounds.maxX-1, y: bounds.minY, width: 1, height: bounds.height)
            
            layer.addSublayer(leftLayer)
            layer.addSublayer(rightLayer)
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: layoutAttributes.frame.height)
        
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .required
        )
        
        return layoutAttributes
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        contentView.addSubview(plugView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(arrowImageView)
        containerView.addSubview(separatorView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(18)
            make.width.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            make.trailing.equalTo(arrowImageView.snp.leading).offset(5)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-19)
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
            
        }
        
        plugView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        separatorView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    func setData<T: PersonalMenuCellType>(_ cellType: T?) {
        guard let cellType = cellType else {
            return
        }
        titleLabel.text = cellType.description
        isLast = cellType.isLast
        separatorView.isHidden = cellType.isLast
        arrowImageView.isHidden = !cellType.isSelectable
        
        iconImageView.image = UIImage(named: cellType.imageName)?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = cellType.isHighlighted ? .brandLightBlue : .lightGray
    }
    
}
