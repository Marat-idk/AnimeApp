//
//  EditProfileViewController.swift
//  AnimeApp
//
//  Created by Марат on 25.06.2023.
//

import UIKit
import SnapKit

// MARK: - EditProfileViewController
final class EditProfileViewController: UIViewController, FlowCoordinator {
    
    var presenter: EditProfilePresenterProtocol!
    var completionHandler: ((Bool) -> Void)?
    
    // MARK: - private properties
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let profileView: ProfileView = {
        let view = ProfileView()
        return view
    }()
    
    private let mockContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let mockView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var nameTextField: LabeledMaterialTextField = {
        let field = LabeledMaterialTextField(frame: .zero, shouldShowFailLabel: true)
        field.delegate = self
        field.backgroundColor = .brandDarkBlue
        field.font = .montserratMedium(size: 14)
        field.cornerRadius = 24
        field.borderWidth = 1
        field.borderColor = .brandBlue
        field.failedBorderColor = .brandRed.withAlphaComponent(0.48)
        
        field.labelFont = .montserratMedium(size: 12)
        field.labelText = "Full name"
        field.labelTextColor = .white
        
        field.failLabelText = "* Name already exist"
        field.failLabelTextColor = .brandRed
        
        field.editingChanged = { [weak self] field in
            guard let text = field.text, !text.isEmpty else { return }
            self?.nameTextField.hideFail()
            self?.presenter.checkInput(text: text, .name)
        }
        
        field.tag = 0
        return field
    }()
    
    private lazy var emailTextField: LabeledMaterialTextField = {
        let field = LabeledMaterialTextField()
        field.delegate = self
        field.backgroundColor = .brandDarkBlue
        field.font = .montserratMedium(size: 14)
        field.keyboardType = .emailAddress
        
        field.cornerRadius = 24
        field.borderWidth = 1
        field.borderColor = .brandBlue
        field.failedBorderColor = .brandRed.withAlphaComponent(0.48)
        
        field.labelFont = .montserratMedium(size: 12)
        field.labelText = "Email"
        field.labelTextColor = .white
        
        field.editingChanged = { [weak self] field in
            guard let text = field.text, !text.isEmpty else { return }
            print("text = \(text)")
        }
        
        field.tag = 1
        return field
    }()
    
    private lazy var passwordTextField: LabeledMaterialTextField = {
        let field = LabeledMaterialTextField()
        field.delegate = self
        field.backgroundColor = .brandDarkBlue
        field.font = .montserratMedium(size: 14)
        field.isSecureTextEntry = true
        
        field.cornerRadius = 24
        field.borderWidth = 1
        field.borderColor = .brandBlue
        field.failedBorderColor = .brandRed.withAlphaComponent(0.48)
        
        field.labelFont = .montserratMedium(size: 12)
        field.labelText = "Password"
        field.labelTextColor = .white
        
        field.editingChanged = { [weak self] field in
            guard let text = field.text, !text.isEmpty else { return }
            print("text = \(text)")
        }
        
        field.tag = 2
        return field
    }()
    
    private lazy var phoneTextField: LabeledMaterialTextField = {
        let field = LabeledMaterialTextField()
        field.delegate = self
        field.backgroundColor = .brandDarkBlue
        field.font = .montserratMedium(size: 14)
        field.keyboardType = .phonePad
        
        field.cornerRadius = 24
        field.borderWidth = 1
        field.borderColor = .brandBlue
        field.failedBorderColor = .brandRed.withAlphaComponent(0.48)
        
        field.labelFont = .montserratMedium(size: 12)
        field.labelText = "Phone Number"
        field.labelTextColor = .white
        
        field.editingChanged = { [weak self] field in
            guard let text = field.text, !text.isEmpty else { return }
            print("text = \(text)")
        }
        
        field.tag = 3
        return field
    }()
    
    private lazy var saveChangesButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .brandLightBlue
        btn.isOpaque = true
        btn.titleLabel?.font = .montserratMedium(size: 16)
        btn.setTitle("Save Changes", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.brandGray, for: .highlighted)
        
        btn.addTarget(self, action: #selector(saveChangesButtonTapped(_:)), for: .touchUpInside)
        
        btn.layer.cornerRadius = 30
        btn.layer.masksToBounds = true
        btn.layer.cornerCurve = .continuous
        return btn
    }()
    
    private lazy var generalStackView: UIStackView = {
        
        saveChangesButton.snp.makeConstraints { $0.height.equalTo(56) }
        let stack = UIStackView(arrangedSubviews: [nameTextField,
                                                   emailTextField,
                                                   passwordTextField,
                                                   phoneTextField,
                                                   saveChangesButton])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 24
        stack.setCustomSpacing(40, after: phoneTextField)
        return stack
    }()

    // MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brandDarkBlue
        
        presenter.getUserPersonal()
        
        setupViews()
        setupConstraints()
        setupNavigationBar()
        hideKeyboardWhenTappedAround()
        enableSaveButton(false)
        subscribe()
    }
    
    // MARK: - private methods
    private func setupViews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(mockContainer)
        
        mockContainer.addSubviews(profileView, generalStackView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        mockContainer.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().priority(.low)
            make.bottom.equalToSuperview()
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(mockContainer.safeAreaLayoutGuide.snp.top).offset(30)
            make.horizontalEdges.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(138)
        }
        
        generalStackView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Edit Profile"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .brandDarkBlue
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.montserratSemiBold(size: 16) ?? .systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        self.customBackButton(with: #selector(backBattonTapped(_:)))
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    private func enableSaveButton(_ isEnabled: Bool) {
        if isEnabled {
            saveChangesButton.backgroundColor = .brandLightBlue
        } else {
            saveChangesButton.backgroundColor = .brandGray
        }
        saveChangesButton.isEnabled = isEnabled
    }
    
    // MARK: - targets actions
    @objc private func backBattonTapped(_ sender: UITapGestureRecognizer) {
        print("backBattonTapped")
        completionHandler?(true)
    }
    
    @objc private func saveChangesButtonTapped(_ sender: UIButton) {
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        presenter.save(name: name, email: email, password: password, phone: phone)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }
        
        // check if the top of the keyboard is above the bottom of the currently focused textbox
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
        
        // if textField bottom is below keyboard bottom - bump the frame up
        var newFrameY: CGFloat = 0.0
        if textFieldBottomY > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            newFrameY = (textBoxY - keyboardTopY / 2) * -0.5
        } else if textFieldBottomY + 20 > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            newFrameY = (textBoxY - keyboardTopY / 2) * -0.3
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear) { [weak self] in
            self?.view.frame.origin.y = newFrameY
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    deinit {
        unsubscribe()
    }
}

// MARK: - NotificationCenter
extension EditProfileViewController {
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

    }
    
    func unsubscribe() {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let superview = textField.superview?.superview?.superview,
           let nextTextField = superview.viewWithTag(textField.tag + 1) as? LabeledMaterialTextField {
            print(textField.tag)
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

// MARK: - EditProfileViewProtocol
extension EditProfileViewController: EditProfileViewProtocol {
    func updateUserPersonal(with personal: UserPersonal) {
        profileView.model = personal
        nameTextField.text = personal.firstName
        emailTextField.text = personal.email
        phoneTextField.text = personal.phone
    }
    
    func showEditFail(of type: PersonalInfoType) {
        switch type {
        case .name:
            nameTextField.showFail()
        default:
            break
        }
        enableSaveButton(false)
    }
    
    func enableSaveButton() {
        enableSaveButton(true)
    }
    
    func update(with userPersonal: UserPersonal) {
        profileView.model = userPersonal
        nameTextField.text = userPersonal.firstName
        emailTextField.text = userPersonal.email
        phoneTextField.text = userPersonal.phone
        enableSaveButton(false)
    }
}
