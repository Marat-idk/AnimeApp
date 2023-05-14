//
//  AuthorizationViewController.swift
//  AnimeApp
//
//  Created by Marat on 23.04.2023.
//

import UIKit
import SnapKit

// MARK: - AuthorizationViewController
class AuthorizationViewController: UIViewController {
    
    var presenter: AuthorizationPresenterProtocol!
    
    private var isAuthorizationHidden = false
    private var authorizationBottomConstraint: Constraint?
    private var registrationBottomConstraint: Constraint?
    
    private let welcomeLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .white
        lbl.text = "Welcome"
        lbl.font = .ubuntuRegular(size: 36)
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.isOpaque = true
        return lbl
    }()
    
    private let signInLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .white
        lbl.text = "Sign in to start"
        lbl.font = .ubuntuRegular(size: 16)
        lbl.textColor = .gray
        lbl.textAlignment = .center
        lbl.isOpaque = true
        return lbl
    }()
    
    private lazy var welcomeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [welcomeLabel, signInLabel, signUpStackView])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 5
        
        stack.setCustomSpacing(20, after: signUpStackView)
        return stack
    }()
    
    private let haventAccountLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .white
        lbl.text = "Have account?"
        lbl.font = .ubuntuRegular(size: 16)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.isOpaque = true
        return lbl
    }()
    
    private lazy var signUpButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setTitle("Sign up!", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.titleLabel?.font = .ubuntuRegular(size: 16)
        btn.addTarget(self, action: #selector(signUpButtonTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var signUpStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [haventAccountLabel,
                                                   signUpButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = 5
        return stack
    }()
    
    private lazy var authorizationView: AuthorizationView = {
        let view = AuthorizationView(frame: .zero)
        view.delegate = self
        return view
    }()
    
    private lazy var registrationView: RegistrationView = {
        let view = RegistrationView(frame: .zero)
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        hideKeyboardWhenTappedAround()
        subscribe()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubviews(
            welcomeStackView,
            authorizationView,
            registrationView
        )
    }
    
    private func setupConstraints() {
        welcomeStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview()
        }

        authorizationView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            authorizationBottomConstraint = make.bottom.equalToSuperview().constraint
            make.height.equalTo(334)
        }
        
        registrationView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            registrationBottomConstraint =  make.bottom.equalToSuperview().offset(500).constraint
            make.height.equalTo(UIDevice.isIphone5Family ? 331 : 431)
        }
    }
    
    private func showHideView() {
        if isAuthorizationHidden {
            hideRegistrationView()
            showAuthorizationView()
            signInLabel.text = "Sign in to start"
            signUpStackView.alpha = 1
            showActivityIndicator()
        } else {
            hideAuthorizationView()
            showRegistrationView()
            signInLabel.text = "Sign up to start"
            signUpStackView.alpha = 0
            hideActivityIndicator()
        }
    }

    @objc private func signUpButtonTapped(_ sender: UIButton) {
        showHideView()
    }
    
    @objc private func keyboardWillShow(_ sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }

        // check if the top of the keyboard is above the bottom of the currently focused textbox
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height

        // if textField bottom is below keyboard bottom - bump the frame up
        if textFieldBottomY > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -0.7
            view.frame.origin.y = newFrameY
        } else if textFieldBottomY + 20 > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -0.3
            view.frame.origin.y = newFrameY
        }
    }

    @objc private func keyboardWillHide(_ sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    deinit {
        unsubscribe()
    }
}

// MARK: - NotificationCenter
extension AuthorizationViewController {
    private func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribe() {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - hide/show AuthorizationView and RegistrationView
extension AuthorizationViewController {
    private func hideAuthorizationView() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear) {
            self.authorizationBottomConstraint?.update(offset: 500)
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.authorizationView.removeFromSuperview()
            self.isAuthorizationHidden = true
        }
    }
    
    private func showAuthorizationView() {
        view.layoutIfNeeded()
        view.addSubview(authorizationView)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear) {
            self.authorizationView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                self.authorizationBottomConstraint = make.bottom.equalToSuperview().offset(0).constraint
                make.height.equalTo(334)
            }
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.isAuthorizationHidden = false
        }
    }
    
    private func hideRegistrationView() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear) {
            self.registrationBottomConstraint?.update(offset: 500)
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.registrationView.removeFromSuperview()
        }
    }
    
    private func showRegistrationView() {
        view.layoutIfNeeded()
        view.addSubview(registrationView)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear) {
            self.registrationView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                self.registrationBottomConstraint?.deactivate()
                self.registrationBottomConstraint = make.bottom.equalToSuperview().constraint
                make.height.equalTo(UIDevice.isIphone5Family ? 331 : 431)
            }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - conform to AuthorizationViewProtocol
extension AuthorizationViewController: AuthorizationViewProtocol {
    
    func showActivityIndicator() {
    }
    
    func hideActivityIndicator() {
    }
    
    func loginFailure(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loginSuccess() {
        print("loginSuccess")
    }
}

// MARK: - conform to AuthorizationViewDelegate
extension AuthorizationViewController: AuthorizationViewDelegate {
    func authorize(with login: String, and password: String, completion: @escaping (Bool) -> Void) {
        presenter.signIn(login: login, password: password, completion: completion)
    }
    
    func restorePassword() {
        
    }
}

// MARK: - conform to RegistrationViewDelegate
extension AuthorizationViewController: RegistrationViewDelegate {
    
    func register(email: String, username: String, password: String, completion: @escaping (Bool) -> Void) {
        presenter.signUp(email: email, username: username, password: password, completion: completion)
    }
    
    func haveAccountButtonTapped() {
        showHideView()
    }
}
