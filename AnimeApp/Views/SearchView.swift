//
//  SearchView.swift
//  AnimeApp
//
//  Created by Марат on 21.10.2023.
//

import UIKit
import SnapKit

// MARK: - SearchViewMode
extension SearchView {
    enum SearchViewMode {
        case withFilter
        case withCancelButton
    }
}

@objc protocol SearchViewDelegate: AnyObject {
    @objc optional func filterButtonTapped()
}

// MARK: - SearchView
class SearchView: UIView {
    
    weak var delegate: SearchViewDelegate?
    
    var searchTextChanged: ((String) -> Void)?
    
    // MARK: Private properties
    private let mode: SearchViewMode
    private var cancelTrailingConstraint: Constraint?
    private var stackViewTrailingToSuperviewConstraint: Constraint?
    private var stackViewTrailingToCancelButtonConstraint: Constraint?
    
    // MARK: UI properties
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
        
        tf.editingChanged = { [weak self] field in
            guard let text = field.text else { return }
            self?.searchTextChanged?(text)
        }
        
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
                                        filterContainerView,
                                        secondPlugView
                                    ])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 8
        
        switch mode {
        case .withFilter:
            stack.setCustomSpacing(0, after: firstPlugView)
            stack.setCustomSpacing(0, after: filterContainerView)
        case .withCancelButton:
            stack.setCustomSpacing(0, after: firstPlugView)
            stack.setCustomSpacing(0, after: searchTextField)
            filterContainerView.isHidden = true
        }
        
        stack.backgroundColor = .brandBlue
        stack.layer.cornerRadius = 20
        stack.layer.cornerCurve = .continuous
        stack.clipsToBounds = true
        stack.layer.masksToBounds = true
        
        return stack
    }()
    
    private let filterContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandBlue
        view.isOpaque = true
        return view
    }()
    
    private let filterSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandGray
        view.isOpaque = true
        return view
    }()
    
    private lazy var filterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .brandBlue
        imageView.isOpaque = true
        imageView.image = .options
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(filterTapped(_:)))
//        tapGesture.cancelsTouchesInView = false
        imageView.addGestureRecognizer(tapGesture)
        
        return imageView
    }()
    
    private lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .brandDarkBlue
        btn.isOpaque = true
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.brandWhiteGray, for: .highlighted)
        btn.titleLabel?.font = .montserratMedium(size: 12)
        
        btn.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        
        return btn
    }()
    
    // MARK: Init
    init(frame: CGRect, mode: SearchViewMode) {
        self.mode = mode
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(mode: SearchViewMode) {
        self.init(frame: .zero, mode: mode)
    }
    
    // MARK: Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: Private methods
    private func setupViews() {
        addSubview(searchStackView)
        switch mode {
        case .withFilter:
            filterContainerView.addSubviews(filterSeparatorView, filterImageView)
        case .withCancelButton:
            addSubview(cancelButton)
        }
    }
    
    private func setupConstraints() {
        searchImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.SearchView.iconSize).priority(.required)
        }
        
        switch mode {
        case .withFilter:
            searchStackView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            filterContainerView.snp.makeConstraints {
                $0.height.equalTo(16)
                $0.width.equalTo(25)
            }
            
            filterSeparatorView.snp.makeConstraints {
                $0.verticalEdges.equalToSuperview()
                $0.left.equalToSuperview()
                $0.width.equalTo(1)
            }

            filterImageView.snp.makeConstraints {
                $0.verticalEdges.equalToSuperview()
                $0.left.equalTo(filterSeparatorView.snp.right).offset(8)
                $0.size.equalTo(16)
            }
        case .withCancelButton:
            searchStackView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.height.equalTo(Constants.SearchView.height)
                self.stackViewTrailingToSuperviewConstraint = $0.trailing.equalToSuperview().constraint
                self.stackViewTrailingToCancelButtonConstraint = $0.trailing.equalTo(self.cancelButton.snp.leading).offset(-8).constraint
            }
            
            cancelButton.snp.makeConstraints {
                $0.centerY.equalTo(searchStackView)
                $0.height.equalTo(Constants.CancelButton.height)
                $0.width.equalTo(Constants.CancelButton.width)
                self.cancelTrailingConstraint = $0.trailing.equalToSuperview().offset(Constants.CancelButton.hiddenTrailingOffset).constraint
            }
            
            stackViewTrailingToCancelButtonConstraint?.deactivate()
        }
    }
    
    // MARK: Targets action
    @objc private func filterTapped(_ sender: UITapGestureRecognizer) {
        delegate?.filterButtonTapped?()
    }
    
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        searchTextField.text = ""
        searchTextField.sendActions(for: .editingChanged)
        searchTextField.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension SearchView: UITextFieldDelegate {
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

// MARK: - Constants
fileprivate struct Constants {
    
    struct SearchView {
        static let height = 40.0
        static let iconSize = 16.0
    }
    
    struct CancelButton {
        static let height = 15.0
        static let width  = 43.0
        static let hiddenTrailingOffset = width * 2
        static let showenTrailingOffset = 0.0
    }
}
