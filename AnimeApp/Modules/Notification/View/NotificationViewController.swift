//
//  NotificationViewController.swift
//  AnimeApp
//
//  Created by Marat on 04.06.2023.
//

import UIKit
import SnapKit

// MARK: - NotificationViewController
final class NotificationViewController: UIViewController {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandDarkBlue
        view.isOpaque = true
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.brandBlue.cgColor
        view.layer.borderWidth = 1.0
        view.clipsToBounds = true
        return view
    }()
    
    private let messagesLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Messages Notifications"
        lbl.font = .montserratMedium(size: 12)
        lbl.textColor = .brandGrey
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    
    private let showNatificationStackView: NotificationStackView = {
        let stack = NotificationStackView(type: MessageNotifications.showNotifications)
        return stack
    }()
    
    private let exceptionsStackView: NotificationStackView = {
        let stack = NotificationStackView(type: MessageNotifications.exceptions)
        return stack
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandBlue
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        separatorView.snp.makeConstraints { $0.height.equalTo(1) }
        let stack = UIStackView(arrangedSubviews: [messagesLabel,
                                                   showNatificationStackView,
                                                   separatorView,
                                                   exceptionsStackView])
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .fill
        stack.setCustomSpacing(26, after: messagesLabel)
        stack.setCustomSpacing(18, after: showNatificationStackView)
        stack.setCustomSpacing(16, after: separatorView)
        
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brandDarkBlue
        
        setupViews()
        setupConstraints()
        setupNavigationBar()
    }
    
    private func setupViews() {
        view.addSubview(containerView)
        
        containerView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.height.equalTo(40).priority(.low)
        }
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(24)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Notification"

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .brandDarkBlue
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.montserratSemiBold(size: 16) ?? .systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
//        self.customBackButton(with: #selector(backBattonTapped(_:)))
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        self.navigationController?.delegate = self
    }
    
    @objc private func backBattonTapped(_ sender: UITapGestureRecognizer) {
        print("backBattonTapped")
    }
}
