//
//  RegistrationView.swift
//  AnimeApp
//
//  Created by Marat on 29.04.2023.
//

import UIKit

protocol RegistrationViewDelegate: AnyObject {
    func haveAccountButtonTapped()
}

// MARK: - RegistrationView
final class RegistrationView: UIView {

    weak var delegate: RegistrationViewDelegate?
    
    // MARK: - private properties
    private let containerView: GradientView = {
        let colors = [UIColor(hexString: "#FFF1BE"), UIColor(hexString: "#A2B2FC")]
        let view = GradientView(colors: colors)
        view.locations = [0, 0.9]
        view.startPoint = CGPoint(x: 0, y: 0)
        view.endPoint = CGPoint(x: 0.75, y: 0.85)
        return view
    }()
    
    private lazy var loginTextField: MaterialTextField = {
        let tf = MaterialTextField.defaultLaginTextField()
        tf.tag = 0
        
        tf.didBeginEditing = { field in
            print("didBeginEditing")
        }
        
        tf.didEndEditing = { field in
            print("didEndEditing")
        }
        
        tf.editingChanged = { [weak self] _ in
            self?.checkInput()
        }
        
        tf.delegate = self
        
        tf.snp.makeConstraints { $0.height.equalTo(25) }
        
        return tf
    }()
    
    private lazy var passwordTextField: MaterialTextField = {
        let tf = MaterialTextField.defaultPasswordTextField()
        tf.tag = 1
        tf.returnKeyType = .next
        
        tf.editingChanged = { [weak self] _ in
            self?.checkInput()
        }
        
        tf.delegate = self
        
        tf.snp.makeConstraints { $0.height.equalTo(25) }
        
        return tf
    }()
    
    private lazy var repeatPasswordTextField: MaterialTextField = {
        let tf = MaterialTextField.defaultPasswordTextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: "Repeat password",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.ubuntuRegular(size: 16) ?? .systemFont(ofSize: 16)
            ]
        )
        tf.tag = 2
        
        tf.editingChanged = { [weak self] _ in
            self?.checkInput()
        }
        
        tf.delegate = self
        
        tf.snp.makeConstraints { $0.height.equalTo(25) }
        
        return tf
    }()
    
    private lazy var haveAccountButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Have account? Sign in!", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.gray, for: .highlighted)
        btn.titleLabel?.font = .ubuntuRegular(size: 16)
        btn.addTarget(self, action: #selector(haveAccountButtonTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var continueButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .lightGray
        btn.setTitle("Continue", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.gray, for: .highlighted)
        btn.titleLabel?.font = .ubuntuRegular(size: 16)
        btn.addTarget(self, action: #selector(continueButtonTapped(_:)), for: .touchUpInside)
        btn.isEnabled = false
        btn.layer.cornerRadius = 23
        btn.clipsToBounds = true
        btn.snp.makeConstraints { $0.height.equalTo(44) }
        return btn
    }()
    
    private lazy var stackView: UIStackView = {
        let buttonView = UIView()
        buttonView.addSubview(haveAccountButton)
        buttonView.snp.makeConstraints { $0.height.equalTo(18) }
        haveAccountButton.snp.makeConstraints {
            $0.centerX.top.bottom.equalToSuperview()
            $0.width.equalTo(160)
        }
        let stack = UIStackView(arrangedSubviews: [loginTextField,
                                                   passwordTextField,
                                                   repeatPasswordTextField,
                                                   buttonView,
                                                   continueButton
                                                  ])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = UIDevice.isIphone5Family ? 20 : 40
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true
        
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
        addSubview(containerView)
        containerView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(58)
            make.leading.equalToSuperview().offset(48)
            make.trailing.equalToSuperview().offset(-48)
            make.bottom.lessThanOrEqualToSuperview().offset(-30)
        }
    }
    
    private func enableButton(enable: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear) {
            if enable {
                self.continueButton.backgroundColor = .black
                self.continueButton.setTitleColor(.white, for: .normal)
                self.continueButton.isEnabled = true
            } else {
                self.continueButton.backgroundColor = .lightGray
                self.continueButton.setTitleColor(.black, for: .normal)
                self.continueButton.isEnabled = false
            }
        }
    }
    
    private func checkInput() {
        let hasEmptyFields = (loginTextField.text?.isEmpty ?? true) ||
                             (passwordTextField.text?.isEmpty ?? true) ||
                             (repeatPasswordTextField.text?.isEmpty ?? true)
        enableButton(enable: !hasEmptyFields)
        
    }
    
    @objc private func haveAccountButtonTapped(_ sender: UIButton) {
        print("haveAccountButtonTapped")
        delegate?.haveAccountButtonTapped()
        
    }
    
    @objc private func continueButtonTapped(_ sender: UIButton) {
        print("continueButtonTapped")
    }
}

// MARK: - conform to UITextFieldDelegate
extension RegistrationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // getting next textField if it exists
        if let superview = textField.superview,
           let nextTextField = superview.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
