//
//  MaterialTextField.swift
//  AnimeApp
//
//  Created by Marat on 24.04.2023.
//

import UIKit

// MARK: - MaterialTextField
class MaterialTextField: UITextField {
    
    // MARK: - public properies
    var shouldReturnBlock: ((MaterialTextField) -> (Bool))?
    var didBeginEditing: ((MaterialTextField) -> Void)?
    var didEndEditing: ((MaterialTextField) -> Void)?
    var editingChanged: ((MaterialTextField) -> Void)?

    var placeholderInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    var textInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    var editingTextInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    
    // MARK: - private properies
    private weak var _delegate: UITextFieldDelegate?
    
    override var delegate: UITextFieldDelegate? {
        get {
            _delegate
        }
        set {
            _delegate = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.delegate = self
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: placeholderInset)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: editingTextInset)
    }
    
    private func addTargets() {
//        addTarget(self, action: #selector(handleEditingDidBegin(_:)), for: .editingDidBegin)
//        addTarget(self, action: #selector(handleEditingDidEnd(_:)), for: .editingDidEnd)
        addTarget(self, action: #selector(handleEditingChanged(_:)), for: .editingChanged)
    }
    
    @objc private func handleEditingDidBegin(_ sender: UITextField) {
        didBeginEditing?(self)
    }
    
    @objc private func handleEditingDidEnd(_ sender: UITextField) {
        didEndEditing?(self)
    }
    
    @objc private func handleEditingChanged(_ sender: UITextField) {
        editingChanged?(self)
    }
}

// MARK: - UITextFieldDelegate
extension MaterialTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let outerDelegate = _delegate, outerDelegate.responds(to: #selector((textFieldShouldReturn(_:)))) {
            outerDelegate.textFieldShouldReturn?(textField)
        }
        return shouldReturnBlock?(self) ?? true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let outerDelegate = _delegate, outerDelegate.responds(to: #selector(textFieldDidBeginEditing(_:))) {
            outerDelegate.textFieldDidBeginEditing?(textField)
        }
        
        didBeginEditing?(self)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let outerDelegate = _delegate, outerDelegate.responds(to: #selector(textFieldDidEndEditing(_:))) {
            outerDelegate.textFieldDidEndEditing?(textField)
        }
        
        didEndEditing?(self)
    }
}

// MARK: - default MaterialTextFields
extension MaterialTextField {
    
    static func defaultLaginTextField() -> MaterialTextField {
        let tf = MaterialTextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: "Email or username",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.ubuntuRegular(size: 16) ?? .systemFont(ofSize: 16)
            ]
        )
        tf.tintColor = .black
        tf.clearButtonMode = .whileEditing
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.returnKeyType = .next
        tf.underlined(color: .black)
        return tf
    }
    
    static func defaultPasswordTextField() -> MaterialTextField {
        let tf = MaterialTextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.ubuntuRegular(size: 16) ?? .systemFont(ofSize: 16)
            ]
        )
        
        tf.tintColor = .black
        tf.isSecureTextEntry = true
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.returnKeyType = .done
        tf.underlined(color: .black)
        
        return tf
    }
}
