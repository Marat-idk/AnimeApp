//
//  CustomPageControl.swift
//  AnimeApp
//
//  Created by Марат on 04.08.2023.
//

import UIKit
import SnapKit

// MARK: - CustomPageControl
final class CustomPageControl: UIPageControl {
    
    // MARK: - Override properties
    override var numberOfPages: Int {
        didSet { updateViews() }
    }
    
    override var currentPage: Int {
        didSet { updateViews() }
    }
    
    var pageIndicatorWidth: CGFloat = 8.0
    var currentPageIndicatorWidth: CGFloat = 24.0
    var currentpageIndicatorCornerRadius: CGFloat = 0
    var pageIndicatorCornerRadius: CGFloat = 0
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 10
        return stack
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Private methods
    private func updateViews() {
        subviews.forEach { $0.removeFromSuperview() }
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for page in 0..<numberOfPages {
            let indicator = indicator(for: page)
            indicator.layer.cornerRadius = cornerRadius(for: page)
            indicator.layer.masksToBounds = true
            let width = width(for: page)
            indicator.snp.makeConstraints { $0.width.equalTo(width).priority(.high) }
            stackView.addArrangedSubview(indicator)
        }
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().priority(.high)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        superview?.layoutIfNeeded()
    }
    
    // MARK: - Private methods
    private func indicator(for page: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = isCurrent(page) ? currentPageIndicatorTintColor : pageIndicatorTintColor
        return view
    }
    
    private func cornerRadius(for page: Int) -> CGFloat {
        return isCurrent(page) ? currentpageIndicatorCornerRadius : pageIndicatorCornerRadius
    }
    
    private func width(for page: Int) -> CGFloat {
        return isCurrent(page) ? currentPageIndicatorWidth : pageIndicatorWidth
    }
    
    private func isCurrent(_ page: Int) -> Bool {
        return page == currentPage
    }
}
