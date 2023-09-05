//
//  ProfileView.swift
//  AnimeApp
//
//  Created by Марат on 25.06.2023.
//

import UIKit
import SnapKit

protocol ProfileViewDelegate: AnyObject {
    func editPhotoTapped()
}

// MARK: - ProfileView
final class ProfileView: UIView {
    
    weak var delegate: ProfileViewDelegate?
    
    var model: UserPersonal? {
        didSet {
            guard let model = model else { return }
            
            nameLabel.text = model.firstName
            emailLabel.text = model.email
            profileImageView.image = model.image
        }
    }
    
    private let profileImageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandDarkBlue
        view.isOpaque = true
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .brandGray
        imgView.image = UIImage(named: "ic-profile")
        imgView.contentMode = .scaleToFill
        imgView.clipsToBounds = true
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    private let editImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .brandBlue
        view.isOpaque = true
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var editImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "ic-pencil")?.template
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = .brandLightBlue
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editImageTapped(_:)))
        imgView.addGestureRecognizer(tapGesture)
        
        return imgView
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .brandDarkBlue
        lbl.isOpaque = true
        lbl.font = .montserratSemiBold(size: 16)
        lbl.text = "Tiffany"
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    private let emailLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .brandDarkBlue
        lbl.isOpaque = true
        lbl.font = .montserratMedium(size: 14)
        lbl.text = "Tiffanyjearsey@gmail.com"
        lbl.textColor = .brandGray
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    private lazy var generalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageContainerView, nameLabel, emailLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.setCustomSpacing(16, after: profileImageContainerView)
        stack.setCustomSpacing(8, after: nameLabel)
        return stack
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageContainerView.layoutIfNeeded()
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        editImageContainer.layer.cornerRadius = editImageContainer.bounds.height / 2
    }
    
    // MARK: - private methods
    private func setupViews() {
        addSubview(generalStackView)
        
        profileImageContainerView.addSubviews(profileImageView, editImageContainer)
        editImageContainer.addSubview(editImageView)
    }
    
    private func setupConstraints() {
        
        generalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageContainerView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(77)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.size.equalTo(72)
        }
        
        editImageContainer.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.size.equalTo(32)
        }
        
        editImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    // MARK: - targets actions
    @objc private func editImageTapped(_ sender: UITapGestureRecognizer) {
        print("editImageTapped")
        delegate?.editPhotoTapped()
    }
}
