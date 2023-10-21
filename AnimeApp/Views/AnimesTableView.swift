//
//  AnimesTableView.swift
//  AnimeApp
//
//  Created by Марат on 15.10.2023.
//

import UIKit
import SnapKit

// MARK: - AnimesTableView
final class AnimesTableView: UIView {
    
    private let mode: DisplayMode
    
    private var cancelTrailingConstraint: Constraint?
    private var stackViewTrailingToSuperviewConstraint: Constraint?
    private var stackViewTrailingToCancelButtonConstraint: Constraint?
    
    weak var dataSource: UITableViewDataSource? {
        get {
            tableView.dataSource
        }
        set {
            tableView.dataSource = newValue
        }
    }
    
    weak var delegate: UITableViewDelegate? {
        get {
            tableView.delegate
        }
        set {
            tableView.delegate = newValue
        }
    }
    
    private let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .brandBlue
        imageView.isOpaque = true
        imageView.image = .search?.template
        imageView.tintColor = .brandGray
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var searchTextField: MaterialTextField = {
        let tf = MaterialTextField()
        tf.placeholderInset = .zero
        tf.textInset = .zero
        tf.editingTextInset = .zero
        tf.backgroundColor = .brandBlue
        tf.font = .montserratMedium(size: 14)
        tf.textColor = .white
        tf.attributedPlaceholder = NSAttributedString(string: "Search a title...",
                                                      attributes:
                                                        [
                                                        .foregroundColor: UIColor.brandGray
                                                        ])
        tf.clipsToBounds = true
        tf.delegate = self
        tf.layer.masksToBounds = true
        return tf
    }()
    
    private lazy var searchStackView: UIStackView = {
        let firstPlugView = UIView()
        let secondPlugView = UIView()
        
        firstPlugView.snp.makeConstraints { $0.width.equalTo(16) }
        secondPlugView.snp.makeConstraints { $0.width.equalTo(16) }
        
        let stack = UIStackView(arrangedSubviews:
                                    [
                                        firstPlugView,
                                        searchImageView,
                                        searchTextField,
                                        secondPlugView
                                    ])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 8
        
        stack.setCustomSpacing(0, after: firstPlugView)
        stack.setCustomSpacing(0, after: searchTextField)
        
        stack.backgroundColor = .brandBlue
        stack.layer.cornerRadius = 20
        stack.layer.cornerCurve = .continuous
        stack.clipsToBounds = true
        stack.layer.masksToBounds = true
        
        return stack
    }()
    
    private lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .brandDarkBlue
        btn.isOpaque = true
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.brandWhiteGray, for: .highlighted)
        btn.titleLabel?.font = .montserratMedium(size: 12)
        return btn
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .brandDarkBlue
        table.isOpaque = true
        table.separatorStyle = .none
        table.register(AnimeTableViewCell.self,
                       forCellReuseIdentifier: AnimeTableViewCell.identifier)
        
        // TODO: - перенеси на уровень выше
//        table.addInfiniteScroll { [weak self] _ in
//            self?.presenter.fetchAnimes()
//        }
//
//        let indicator = UIActivityIndicatorView()
//        indicator.color = .brandLightBlue
//
//        table.infiniteScrollIndicatorView = indicator
        
        return table
    }()
    
    // MARK: Init
    init(frame: CGRect, mode: DisplayMode) {
        self.mode = mode
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(_ mode: DisplayMode) {
        self.init(frame: .zero, mode: mode)
    }
    
    // MARK: Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: Private methods
    private func setupViews() {
        addSubview(tableView)
        if mode == .search {
            addSubviews(searchStackView,
                        cancelButton)
        }
    }
    
    private func setupConstraints() {
        switch mode {
        case .normal:
            tableView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        case .search:
            searchImageView.snp.makeConstraints {
                $0.size.equalTo(Constants.SearchView.iconSize).priority(.required)
            }

            searchStackView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview().offset(24)
                $0.height.equalTo(Constants.SearchView.height)
                self.stackViewTrailingToSuperviewConstraint = $0.trailing.equalToSuperview().offset(-24).constraint
                self.stackViewTrailingToCancelButtonConstraint = $0.trailing.equalTo(self.cancelButton.snp.leading).offset(-8).constraint
            }
            
            cancelButton.snp.makeConstraints {
                $0.centerY.equalTo(searchStackView)
                $0.height.equalTo(Constants.CancelButton.height)
                $0.width.equalTo(Constants.CancelButton.width)
                self.cancelTrailingConstraint = $0.trailing.equalToSuperview().offset(Constants.CancelButton.hiddenTrailingOffset).constraint
            }
            
            tableView.snp.makeConstraints {
                $0.top.equalTo(searchStackView.snp.bottom).offset(24)
                $0.bottom.horizontalEdges.equalToSuperview()
            }
            stackViewTrailingToCancelButtonConstraint?.deactivate()
        }
    }
    
    // MARK: Public methods
    func reloadData() {
        tableView.reloadData()
    }
}

extension AnimesTableView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        layoutIfNeeded()
        stackViewTrailingToSuperviewConstraint?.deactivate()
        UIView.animate(withDuration: 0.1, delay: .zero, options: .curveLinear) {
            self.cancelTrailingConstraint?.update(offset: Constants.CancelButton.showenTrailingOffset)
            self.stackViewTrailingToCancelButtonConstraint?.activate()
            self.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        layoutIfNeeded()
        stackViewTrailingToCancelButtonConstraint?.deactivate()
        UIView.animate(withDuration: 0.1, delay: .zero, options: .curveLinear) {
            self.cancelTrailingConstraint?.update(offset: Constants.CancelButton.hiddenTrailingOffset)
            self.stackViewTrailingToSuperviewConstraint?.activate()
            self.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - AnimesTableViewType
extension AnimesTableView {
    enum DisplayMode {
        case normal
        case search
    }
}

// MARK: - Constants
fileprivate struct Constants {
    
    struct SearchView {
        static let height = 40.0
        static let iconSize = 16.0
    }
    
    struct CancelButton {
        static let height = 15.0
        static let width  = 43.0
        static let hiddenTrailingOffset = width
        static let showenTrailingOffset = -8.0
    }
}
