//
//  LabeledMaterialTextField.swift
//  AnimeApp
//
//  Created by Марат on 26.06.2023.
//

import UIKit
import SnapKit

// MARK: - LabeledMaterialTextField
class LabeledMaterialTextField: UIView {
    
    weak var delegate: UITextFieldDelegate?
    
    var shouldReturnBlock: ((UITextField) -> (Bool))?
    var didBeginEditing: ((UITextField) -> Void)?
    var didEndEditing: ((UITextField) -> Void)?
    var editingChanged: ((UITextField) -> Void)?
    
    // MARK: - override properties
    override var backgroundColor: UIColor? {
        get {
            return textFieldView.backgroundColor
        }
        set {
            textFieldView.backgroundColor = newValue
            fieldLabelContainer.backgroundColor = newValue
            fieldLabel.backgroundColor = newValue
            textField.backgroundColor = newValue
            failLabel.backgroundColor = newValue
        }
    }
    
    override var tag: Int {
        get {
            super.tag
        }
        set {
            super.tag = newValue
            textField.tag = newValue
        }
    }
    
    // MARK: - textFieldView's properties
    var cornerRadius: CGFloat {
        get {
            textFieldView.layer.cornerRadius
        }
        set {
            textFieldView.layer.cornerRadius = newValue
        }
    }
    
    private var _borderColor: UIColor? {
        get {
            guard let cgColor = textFieldView.layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set {
            textFieldView.layer.borderColor = newValue?.cgColor
        }
    }
    
    var borderColor: UIColor? {
        didSet {
            _borderColor = borderColor
        }
    }
    var failedBorderColor: UIColor?
    
    var borderWidth: CGFloat {
        get {
            textFieldView.layer.borderWidth
        }
        set {
            textFieldView.layer.borderWidth = newValue
        }
    }
    
    // MARK: - textField's properties
    var font: UIFont? {
        get {
            textField.font
        }
        set {
            textField.font = newValue
        }
    }
    
    var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    var keyboardType: UIKeyboardType {
        get {
            textField.keyboardType
        }
        set {
            textField.keyboardType = newValue
        }
    }
    
    var isSecureTextEntry: Bool {
        get {
            textField.isSecureTextEntry
        }
        set {
            textField.isSecureTextEntry = newValue
        }
    }
    
    // MARK: - label's properties
    var labelFont: UIFont! {
        get {
            fieldLabel.font
        }
        set {
            fieldLabel.font = newValue
            failLabel.font = newValue
        }
    }
    
    var labelText: String? {
        get {
            fieldLabel.text
        }
        set {
            fieldLabel.text = newValue
        }
    }
    
    var labelTextColor: UIColor! {
        get {
            fieldLabel.textColor
        }
        set {
            fieldLabel.textColor = newValue
        }
    }
    
    // MARK: - fail label's properties
    var failLabelText: String? {
        get {
            failLabel.text
        }
        set {
            failLabel.text = newValue
        }
    }
    
    var failLabelTextColor: UIColor! {
        get {
            failLabel.textColor
        }
        set {
            failLabel.textColor = newValue
        }
    }

    // MARK: - private properties
    private let textFieldView: UIView = {
        let view = UIView()
        view.isOpaque = true
        return view
    }()
    
    private let fieldLabelContainer: UIView = {
        let view = UIView()
        view.isOpaque = true
        view.accessibilityIdentifier = "fieldLabelContainer"
        return view
    }()
    
    private let fieldLabel: UILabel = {
        let lbl = UILabel()
        lbl.isOpaque = true
        lbl.textAlignment = .left
        lbl.accessibilityIdentifier = "fieldLabel"
        return lbl
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.textColor = .brandGray
        tf.addTarget(self, action: #selector(handleEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    private let failLabel: UILabel = {
        let lbl = UILabel()
        lbl.isOpaque = true
        return lbl
    }()
    
    private var shouldShowFailLabel: Bool = false
    private var isFailAlreadyHidden: Bool = false
    private var failLabelHeightConstraint: Constraint?
    
    // MARK: - init
    init(frame: CGRect, shouldShowFailLabel: Bool) {
        self.shouldShowFailLabel = shouldShowFailLabel
        super.init(frame: frame)
        self.textField.delegate = self
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero, shouldShowFailLabel: false)
    }
    
    // MARK: - override methods
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        if super.becomeFirstResponder() { return true }
        textField.becomeFirstResponder()
        return false
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        if super.resignFirstResponder() { return true }
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: - private methods
    private func setupViews() {
        if shouldShowFailLabel {
            addSubview(failLabel)
        }
        addSubviews(textFieldView,
                    fieldLabelContainer)
        textFieldView.addSubview(textField)
        fieldLabelContainer.addSubview(fieldLabel)
    }
    
    private func setupConstraints() {
        textFieldView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(53)
            if !shouldShowFailLabel {
                make.bottom.equalToSuperview()
            }
        }
        
        fieldLabelContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.lessThanOrEqualToSuperview().offset(-12)
            make.height.equalTo(16)
        }
        
        textField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        fieldLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(4)
            make.centerX.equalToSuperview()
        }
        
        if shouldShowFailLabel {
            failLabel.snp.makeConstraints { make in
                make.top.equalTo(textFieldView.snp.bottom).offset(8)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalToSuperview()
                failLabelHeightConstraint = make.height.equalTo(16).constraint
            }
        }
    }
    
    // MARK: - targets actions
    @objc private func handleEditingChanged(_ sender: UITextField) {
        editingChanged?(textField)
    }
    
    func hideFail() {
        guard shouldShowFailLabel, !isFailAlreadyHidden else { return }
        self.window?.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear) {
            self._borderColor = self.borderColor
            self.failLabelHeightConstraint?.update(offset: 0)
            self.window?.layoutIfNeeded()
        } completion: { _ in
            self.isFailAlreadyHidden = true
        }
    }
    
    func showFail() {
        guard shouldShowFailLabel else { return }
        self.window?.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear) {
            self._borderColor = self.failedBorderColor
            self.failLabelHeightConstraint?.update(offset: 16)
            self.window?.layoutIfNeeded()
        } completion: { _ in
            self.isFailAlreadyHidden = false
        }
    }
}

// MARK: - UITextFieldDelegate
extension LabeledMaterialTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let outerDelegate = delegate, outerDelegate.responds(to: #selector(textFieldShouldReturn(_:))) {
            return outerDelegate.textFieldShouldReturn?(textField) ?? true
        }
        textField.resignFirstResponder()
        return shouldReturnBlock?(textField) ?? true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let outerDelegate = delegate, outerDelegate.responds(to: #selector(textFieldDidBeginEditing(_:))) {
            outerDelegate.textFieldDidBeginEditing?(textField)
        }
        textField.textColor = .white
        didBeginEditing?(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let outerDelegate = delegate, outerDelegate.responds(to: #selector(textFieldDidEndEditing(_:))) {
            outerDelegate.textFieldDidEndEditing?(textField)
        }
        textField.textColor = .brandGray
        didEndEditing?(textField)
    }
}
