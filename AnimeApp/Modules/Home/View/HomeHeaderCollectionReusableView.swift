//
//  HomeHeaderCollectionReusableView.swift
//  AnimeApp
//
//  Created by Марат on 05.08.2023.
//

import UIKit
import SnapKit

// MARK: - HomeHeaderCollectionReusableViewDelegate
protocol HomeHeaderCollectionReusableViewDelegate: AnyObject {
    func headerButtonTapped(on section: HomeSection)
}

// MARK: - HomeHeaderCollectionReusableView
final class HomeHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = String(describing: HomeHeaderCollectionReusableView.self)
    
    weak var delegate: HomeHeaderCollectionReusableViewDelegate?
    
    var section: HomeSection? {
        didSet {
            guard let section = section else { return }
            titleLabel.text = section.description
            button.isHidden = !section.hasButton
            button.setTitle(section.buttonTitle, for: .normal)
        }
    }
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .brandDarkBlue
        lbl.isOpaque = true
        lbl.font = .montserratSemiBold(size: 16)
        lbl.textColor = .white
        lbl.textAlignment = .left
        return lbl
    }()
    
    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .brandDarkBlue
        btn.isOpaque = true
        btn.titleLabel?.font = .montserratMedium(size: 14)
        btn.setTitleColor(.brandLightBlue, for: .normal)
        btn.setTitleColor(.brandGray, for: .highlighted)
        btn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .brandDarkBlue
        isOpaque = true
        setupViews()
        setupConstraints()
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
        addSubviews(titleLabel, button)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
//            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(button.snp.leading)
            $0.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Targets actions
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let section = section else { return }
        delegate?.headerButtonTapped(on: section)
    }
}
