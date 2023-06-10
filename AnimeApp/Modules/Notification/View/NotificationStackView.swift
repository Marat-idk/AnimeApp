//
//  NotificationStackView.swift
//  AnimeApp
//
//  Created by Marat on 05.06.2023.
//

import UIKit
import SnapKit

// MARK: - NotificationStackView
final class NotificationStackView: UIView {

    private var type: NotificationProtocol {
        didSet {
            titleLabel.text = type.description
            notificationSwitch.isHidden = !type.hasSwitch
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = type.description
        lbl.font = .montserratMedium(size: 16)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.setContentCompressionResistancePriority(.required, for: .horizontal)
        return lbl
    }()
    
    private lazy var notificationSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .brandLightBlue
        sw.isHidden = !type.hasSwitch
        let scaleX = 48.0 / 51.0
        let scaleY = 24.0 / 31.0
        sw.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        //        sw.sizeThatFits(CGSize(width: sw.bounds.width * scaleX, height: sw.bounds.height * scaleY))
        //        print(sw.bounds.width * scaleX)
        //        print(sw.bounds.height * scaleY)
        
        if let thumb = sw.subviews[0].subviews[1].subviews[2] as? UIImageView {
            print(thumb.bounds.width)
            print(thumb.bounds.height)
            thumb.transform = CGAffineTransform(scaleX: scaleY + 0.2, y: scaleX + 0.2)
        }
        
        return sw
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, notificationSwitch])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.alignment = .fill
        stack.spacing = 5
        return stack
    }()

    init(type: NotificationProtocol) {
        self.type = type
        
        super.init(frame: .zero)
        
        setupViews()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(stackView)
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().priority(.high)
        }
    }
    
}
