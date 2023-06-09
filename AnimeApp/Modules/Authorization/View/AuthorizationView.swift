//
//  AuthorizationView.swift
//  AnimeApp
//
//  Created by Marat on 23.04.2023.
//

import UIKit

// MARK: - AuthorizationViewDelegate
protocol AuthorizationViewDelegate: AnyObject {
    func authorize(with login: String, and password: String, completion: @escaping (Bool) -> Void)
    func restorePassword()
}

// MARK: - AuthorizationView
final class AuthorizationView: UIView {
    
    weak var delegate: AuthorizationViewDelegate?

    private let containerView: GradientView = {
        let colors = [UIColor(hexString: "#FFF1BE"), UIColor(hexString: "#A2B2FC")]
        let view = GradientView(colors: colors)
        view.locations = [0, 0.9]
        view.startPoint = CGPoint(x: 0, y: 0)
        view.endPoint = CGPoint(x: 0.75, y: 0.85)
        return view
    }()
    
    private lazy var loginTextField: MaterialTextField = {
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
        tf.tag = 0
        tf.underlined(color: .black)
        
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
        tf.returnKeyType = .done
        tf.tag = 1
        tf.underlined(color: .black)
        
        tf.editingChanged = { [weak self] _ in
            self?.checkInput()
        }
        
        tf.delegate = self
        
        tf.snp.makeConstraints { $0.height.equalTo(25) }
        
        return tf
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("forgot password?", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.gray, for: .highlighted)
        btn.titleLabel?.font = .ubuntuRegular(size: 12)
        btn.contentHorizontalAlignment = .trailing
        btn.addTarget(self, action: #selector(forgotPasswordButtonTapped(_:)), for: .touchUpInside)
        btn.snp.makeConstraints { $0.height.equalTo(14) }
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
    
    private let activitiIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.color = .white
        indicator.isHidden = true
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [loginTextField,
                                                   passwordTextField,
                                                   forgotPasswordButton,
                                                   continueButton
                                                  ])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 10
        stack.setCustomSpacing(40, after: loginTextField)
        stack.setCustomSpacing(60, after: forgotPasswordButton)
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
        continueButton.addSubview(activitiIndicator)
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
        
        activitiIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
        let hasEmptyFields = (loginTextField.text?.isEmpty ?? true) || (passwordTextField.text?.isEmpty ?? true)
        enableButton(enable: !hasEmptyFields)
        
    }
    
    private func userInteractionEnabled(_ flag: Bool) {
        loginTextField.isEnabled = flag
        passwordTextField.isEnabled = flag
        forgotPasswordButton.isEnabled = flag
        continueButton.isEnabled = flag
    }

    @objc private func forgotPasswordButtonTapped(_ sender: UIButton) {
        print("forgotPasswordButtonTapped")
        delegate?.restorePassword()
    }
    
    @objc private func continueButtonTapped(_ sender: UIButton) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text else { return }
        
        print("continueButtonTapped")
        
        continueButton.setTitle("", for: .normal)
        activitiIndicator.isHidden = false
        activitiIndicator.startAnimating()
        
        userInteractionEnabled(false)
        
        delegate?.authorize(with: login, and: password) { [weak self] isSuccessed in
            guard let self = self else { return }
            self.userInteractionEnabled(isSuccessed)
            self.activitiIndicator.stopAnimating()
            self.continueButton.setTitle("Continue", for: .normal)
        }
    }
}

// MARK: - conform to UITextFieldDelegate
extension AuthorizationView: UITextFieldDelegate {
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
