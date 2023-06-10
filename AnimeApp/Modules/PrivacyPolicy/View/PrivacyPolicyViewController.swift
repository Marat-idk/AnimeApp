//
//  PrivacyPolicyViewController.swift
//  AnimeApp
//
//  Created by Marat on 28.05.2023.
//

import UIKit
import SnapKit

// MARK: - PrivacyPolicyViewController
final class PrivacyPolicyViewController: UIViewController, FlowCoordinator {
    
    var completionHandler: ((Bool) -> Void)?
    
    private let scrollView = UIScrollView()
    
    private let termLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Term"
        lbl.font = .montserratSemiBold(size: 14)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.setContentHuggingPriority(.required, for: .vertical)
        return lbl
    }()
    
    private let termDescriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = String(repeating: "Mock ", count: 50) + "\n\n" + String(repeating: "Mock ", count: 120)
        lbl.font = .montserratMedium(size: 14)
        lbl.textColor = .brandGrey
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.setContentCompressionResistancePriority(.required, for: .vertical)
        return lbl
    }()
    
    private let changesLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Changes to the Service and/or Terms:"
        lbl.font = .montserratSemiBold(size: 14)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.setContentHuggingPriority(.required, for: .vertical)
        lbl.setContentCompressionResistancePriority(.required, for: .vertical)
        return lbl
    }()
    
    private let changeDescriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = String(repeating: "Mock ", count: 50) + "\n\n" + String(repeating: "Mock ", count: 150)
        lbl.font = .montserratMedium(size: 14)
        lbl.textColor = .brandGrey
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.setContentCompressionResistancePriority(.required, for: .vertical)
        return lbl
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [termLabel,
                                                   termDescriptionLabel,
                                                   changesLabel,
                                                   changeDescriptionLabel
                                                  ])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 13
        stack.setCustomSpacing(24, after: termDescriptionLabel)
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
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
            make.width.equalToSuperview().offset(-48)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Privacy Policy"

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
        
        self.customBackButton(with: #selector(backBattonTapped(_:)))
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        self.navigationController?.delegate = self
    }
    
    @objc private func backBattonTapped(_ sender: UITapGestureRecognizer) {
        print("backBattonTapped")
        completionHandler?(true)
    }
}

// прочитай еще раз про рекогнайзеры
extension PrivacyPolicyViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//// изучи это
//extension PrivacyPolicyViewController: UINavigationControllerDelegate {
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        if let coordinator = navigationController.topViewController?.transitionCoordinator {
//            coordinator.notifyWhenInteractionChanges { (context) in
//                print("Is cancelled: \(context.isCancelled)")
//                if !context.isCancelled {
//                    self.completionHandler?(false)
//                }
//            }
//        }
//    }
//}
