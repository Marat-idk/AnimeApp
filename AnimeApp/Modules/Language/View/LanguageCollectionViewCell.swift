//
//  LanguageCollectionViewCell.swift
//  AnimeApp
//
//  Created by Марат on 11.06.2023.
//

import UIKit
import SnapKit

// MARK: - LanguageCollectionViewCell
final class LanguageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: LanguageCollectionViewCell.self)
    
    override var isSelected: Bool {
        didSet {
            chechmarkImageView.isHidden = !isSelected
        }
    }
    
    private var isLast: Bool? {
        didSet {
            
            guard let isLast = isLast else { return }
            
            if isLast {
                containerView.layer.cornerRadius = 16
                containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                containerView.layer.borderColor = UIColor.brandBlue.cgColor
                containerView.layer.borderWidth = 1
            } else {
                containerView.layer.cornerRadius = 0
                containerView.layer.borderColor = UIColor.brandDarkBlue.cgColor
                containerView.layer.borderWidth = 0
            }
        }
    }
    
    private let leftLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.brandBlue.cgColor
        return layer
    }()
    
    private let rightLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.brandBlue.cgColor
        return layer
    }()
    
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
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .brandDarkBlue
        lbl.font = .montserratSemiBold(size: 16)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.isOpaque = true
        return lbl
    }()
    
    private let chechmarkImageView: UIImageView = {
        let imgView = UIImageView()
//        imgView.backgroundColor = .brandDarkBlue
        imgView.image = UIImage(named: "Ic-checkmark")
        imgView.isOpaque = true
        imgView.isHidden = true
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
        isSelected = false
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isLast = nil
        nameLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leftLayer.frame = CGRect(x: bounds.minX, y: bounds.minY, width: 1, height: bounds.height)
        rightLayer.frame = CGRect(x: bounds.maxX-1, y: bounds.minY, width: 1, height: bounds.height)
        if isLast == false {
            layer.addSublayer(leftLayer)
            layer.addSublayer(rightLayer)
        } else {
            leftLayer.removeFromSuperlayer()
            rightLayer.removeFromSuperlayer()
        }
//        chechmarkImageView.isHidden = !isSelected
    }
    
    private func setupViews() {
        contentView.addSubviews(containerView, plugView)
        containerView.addSubviews(nameLabel, chechmarkImageView, separatorView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        plugView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(33)
            make.trailing.equalTo(chechmarkImageView.snp.trailing).offset(-10)
        }
        
        chechmarkImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(24)
        }
        
        separatorView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setData<T: LanguageMenuCellType>(_ cellType: T?) {
        guard let cellType = cellType else { return }
        nameLabel.text = cellType.description
        isLast = cellType.isLast
        separatorView.isHidden = !cellType.hasSeparator
    }
}
