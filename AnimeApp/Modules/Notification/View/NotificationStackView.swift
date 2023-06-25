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
        lbl.backgroundColor = .brandDarkBlue
        lbl.isOpaque = true
        lbl.text = type.description
        lbl.font = .montserratMedium(size: 16)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.setContentCompressionResistancePriority(.required, for: .horizontal)
        return lbl
    }()
    
    private lazy var notificationSwitch: CustomSwitch = {
        let sw = CustomSwitch()
        sw.isHidden = !type.hasSwitch
        sw.onTintColor = .brandLightBlue
        sw.thumbSize = CGSize(width: 20, height: 20)
        sw.padding = 2.0
        sw.addTarget(self, action: #selector(notificationSwitchTapped(_:)), for: .valueChanged)
        return sw
    }()
    
    private lazy var stackView: UIStackView = {
        notificationSwitch.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(24)
        }
        let stack = UIStackView(arrangedSubviews: [titleLabel, notificationSwitch])
        stack.backgroundColor = .brandDarkBlue
        stack.isOpaque = true
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
    
    @objc private func notificationSwitchTapped(_ sender: UISwitch) {
        print("notificationSwitchTapped isOn \(notificationSwitch.isOn)")
    }
    
}
