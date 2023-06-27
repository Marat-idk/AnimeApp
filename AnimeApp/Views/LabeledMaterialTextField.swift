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
    
    // MARK: - override properties
    override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set {
            textFieldView.backgroundColor = newValue
            fieldLabelContainer.backgroundColor = newValue
            fieldLabel.backgroundColor = newValue
            textField.backgroundColor = newValue
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
    
    var borderColor: UIColor? {
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
    
    // MARK: - label's properties
    var labelFont: UIFont! {
        get {
            fieldLabel.font
        }
        set {
            fieldLabel.font = newValue
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
    
    private let textField: UITextField = {
        let tf = UITextField()
        return tf
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textField.delegate = self
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - private methods
    private func setupViews() {
        addSubviews(textFieldView, fieldLabelContainer)
        textFieldView.addSubview(textField)
        fieldLabelContainer.addSubview(fieldLabel)
    }
    
    private func setupConstraints() {
        textFieldView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
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
    }
}

// MARK: - UITextFieldDelegate
extension LabeledMaterialTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let outerDelegate = delegate, outerDelegate.responds(to: #selector(textFieldShouldReturn(_:))) {
            return outerDelegate.textFieldShouldReturn?(textField) ?? true
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let outerDelegate = delegate, outerDelegate.responds(to: #selector(textFieldDidBeginEditing(_:))) {
            outerDelegate.textFieldDidBeginEditing?(textField)
        }
        textField.textColor = .white
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let outerDelegate = delegate, outerDelegate.responds(to: #selector(textFieldDidEndEditing(_:))) {
            outerDelegate.textFieldDidEndEditing?(textField)
        }
        textField.textColor = .brandGray
    }
}
