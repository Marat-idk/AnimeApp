//
//  SearchCollectionViewCell.swift
//  AnimeApp
//
//  Created by Марат on 23.07.2023.
//

import UIKit
import SnapKit

// MARK: - SearchCollectionViewCell
final class SearchCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: SearchCollectionViewCell.self)
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandBlue
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
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
    
    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        
        containerView.addSubviews(searchImageView, searchTextField, filterContainerView)
        
        filterContainerView.addSubviews(filterSeparatorView, filterImageView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.size.equalTo(16)
        }

        searchTextField.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
//            self.horizontalConstraints = make.horizontalEdges.equalToSuperview().inset(20).constraint
            $0.leading.equalTo(searchImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(filterContainerView.snp.leading).offset(-8)
        }
        
        filterContainerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
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
    }
    
    @objc private func filterTapped(_ sender: UITapGestureRecognizer) {
        print("filterTapped")
    }
}

extension SearchCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
