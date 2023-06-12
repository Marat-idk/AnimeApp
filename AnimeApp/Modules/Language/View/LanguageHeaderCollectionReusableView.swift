//
//  LanguageHeaderCollectionReusableView.swift
//  AnimeApp
//
//  Created by Марат on 11.06.2023.
//

import UIKit

// MARK: - LanguageHeaderCollectionReusableView
final class LanguageHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = String(describing: LanguageHeaderCollectionReusableView.self)
    
    var section: LanguageSection? {
        didSet {
            guard let section = section else {
                return
            }
            titleLabel.text = section.description
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandDarkBlue
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.borderColor = UIColor.brandBlue.cgColor
        view.layer.borderWidth = 1
        view.isOpaque = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .brandDarkBlue
        lbl.font = .montserratMedium(size: 12)
        lbl.textColor = .brandDarkGray
        lbl.textAlignment = .left
        lbl.isOpaque = true
        return lbl
    }()
    
    private let plugView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandDarkBlue
        view.isOpaque = true
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(containerView)
        addSubview(plugView)
        containerView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        plugView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
        }
    }
}
