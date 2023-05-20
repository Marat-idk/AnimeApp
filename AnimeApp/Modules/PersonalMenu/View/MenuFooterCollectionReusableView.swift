//
//  MenuFooterCollectionReusableView.swift
//  AnimeApp
//
//  Created by Marat on 15.05.2023.
//

import UIKit

// MARK: - MenuFooterCollectionReusableView
final class MenuFooterCollectionReusableView: UICollectionReusableView {
    static let identifier = String(describing: MenuFooterCollectionReusableView.self)
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandDarkBlue
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.borderColor = UIColor.brandBlue.cgColor
        view.layer.borderWidth = 1
        view.isOpaque = true
        return view
    }()
    
    private let plugView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandDarkBlue
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
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(3)
            make.height.equalTo(18)
        }

        plugView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
