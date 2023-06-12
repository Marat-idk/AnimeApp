//
//  CustomSwitch.swift
//  AnimeApp
//
//  Created by Марат on 11.06.2023.
//

import UIKit

// MARK: - CustomSwitch
class CustomSwitch: UIControl {

    // MARK: - public properies
    var onTintColor = UIColor(red: 144 / 255, green: 202 / 255, blue: 119 / 255, alpha: 1) {
        didSet {
            setupViews()
        }
    }
    
    var offTintColor = UIColor.lightGray {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    var cornerRadius = 0.5 {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    var thumbTintColor = UIColor.white {
        didSet {
            thumbView.backgroundColor = thumbTintColor
        }
    }
    
    var thumbCornerRadius = 0.5 {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    var thumbSize = CGSize.zero {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    var padding = 1.0 {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    var isOn = true
    
    var animationDuration = 0.5
    
    // MARK: - private properies
    private var onPoint = CGPoint.zero
    private var offPoint = CGPoint.zero
    private var isAnimating = false
    
    private lazy var thumbView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 1.5
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0.75, height: 2)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isAnimating {
            layer.cornerRadius = bounds.size.height * cornerRadius
            backgroundColor = isOn ? onTintColor : offTintColor
            
            // thumb managment
            
            let thumbSize = thumbSize != .zero ? thumbSize : CGSize(width: bounds.size.height - 1, height: bounds.height - 1)
            let yPostition = (bounds.size.height - thumbSize.height) / 2
            
            offPoint = CGPoint(x: padding, y: yPostition)
            onPoint = CGPoint(x: bounds.size.width - thumbSize.width - padding, y: yPostition)
            thumbView.frame = CGRect(origin: isOn ? onPoint : offPoint, size: thumbSize)
            thumbView.layer.cornerRadius = thumbSize.height * thumbCornerRadius
            
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        animate()
        return true
    }
    
    // MARK: - private methods
    private func setupViews() {
        clear()
        clipsToBounds = false
        thumbView.backgroundColor = thumbTintColor
        thumbView.isUserInteractionEnabled = false
        
        addSubview(thumbView)
    }
    
    private func clear() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    public func animate() {
        isOn.toggle()
        
        isAnimating = true
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: [.curveEaseOut, .beginFromCurrentState]) { [weak self] in
            
            guard let self = self else { return }
            
            self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            
        } completion: { _ in
            self.isAnimating = false
            self.sendActions(for: .valueChanged)
        }
    }
    
}
