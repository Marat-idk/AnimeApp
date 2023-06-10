//
//  MenuProfileCollectionViewCell.swift
//  AnimeApp
//
//  Created by Marat on 21.05.2023.
//

import UIKit

// MARK: - MenuProfileCollectionViewCell
final class MenuProfileCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: MenuProfileCollectionViewCell.self)
    
    var isPremium: Bool = false {
        didSet {
            premiumContainerView.isHidden = !isPremium
        }
    }
    
    // MARK: - profile views
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .blue
        imgView.isOpaque = true
        imgView.image = UIImage(named: "ic-profile")
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .brandDarkBlue
        lbl.isOpaque = true
        // TODO: - just mock text
        lbl.text = "Tiffany"
        lbl.font = .montserratSemiBold(size: 16)
        lbl.textColor = .white
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let emailLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .brandDarkBlue
        lbl.isOpaque = true
        // TODO: - just mock text
        lbl.text = "Tiffanyjearsey@gmail.com" + "abobaobabeobeo"
        lbl.font = .montserratMedium(size: 14)
        // TODO: - mock color
        lbl.textColor = .gray
        lbl.textAlignment = .left
        return lbl
    }()
    
    private lazy var editProfileButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .brandDarkBlue
        btn.isOpaque = true
        btn.setImage(UIImage(named: "ic-edit")?.template, for: .normal)
        btn.tintColor = .brandLightBlue
        btn.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        btn.setContentCompressionResistancePriority(.required, for: .horizontal)
        return btn
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stack.backgroundColor = .brandDarkBlue
        stack.isOpaque = true
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 8
//        stack.setContentHuggingPriority(.required, for: .horizontal)
        return stack
    }()
    
    private lazy var profileStackView: UIStackView = {
        editProfileButton.snp.makeConstraints { $0.size.equalTo(24).priority(.high) }
        let stack = UIStackView(arrangedSubviews: [imageView, infoStackView, editProfileButton])
        stack.backgroundColor = .brandDarkBlue
        stack.isOpaque = true
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.setCustomSpacing(16, after: imageView)
        stack.setCustomSpacing(16, after: infoStackView)
        return stack
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandDarkBlue
        view.isOpaque = true
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.brandBlue.cgColor
        view.layer.borderWidth = 1.0
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - premium views
    private let premiumImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .brandOrange
        view.isOpaque = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let premiumImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .brandOrange
        imgView.isOpaque = true
        imgView.image = UIImage(named: "ic-premium")?.template
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = .white
        return imgView
    }()
    
    private let premiumLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Premium Member"
        lbl.font = .montserratSemiBold(size: 16)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    
    private let premiumDescriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "New movies are coming for you,\nDownload Now!"
        lbl.font = .montserratRegular(size: 14)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    
    private let premiumContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandDarkOrange
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - main stack view
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [containerView, premiumContainerView])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 24
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
    
    // MARK: - overrided methods
    // пришлось творить выкрутасы, чтобы все ок отображалось в стеке
    // эти танцы нужны из-за того, что высота ячейки динамическая и сыпались разные варнинги
    // лайаута (из-за них в некоторых местах задания лайаута прописано priority(.medium/high))
    override func layoutSubviews() {
        super.layoutSubviews() 
        setupConstraints()
        imageView.layoutIfNeeded()
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        premiumContainerView.layoutIfNeeded()
        premiumContainerView.drawDoubleCircle(below: premiumLabel.layer)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return layoutAttributes
    }
    
    // MARK: - private methods
    private func setupViews() {
        contentView.addSubview(mainStackView)
        containerView.addSubview(profileStackView)
        // MOCKMOCK
        premiumContainerView.addSubviews(premiumImageContainer, premiumLabel, premiumDescriptionLabel)
        
        premiumImageContainer.addSubview(premiumImageView)
    }
    
    private func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().priority(.medium)
        }
        
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(86).priority(.high)
        }
        
        premiumContainerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(110).priority(.high)
        }
        
        profileStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(54)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(54)
        }
        
        premiumImageContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(40)
        }
        
        premiumImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
        
        premiumLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalTo(premiumImageContainer.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        premiumDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(premiumLabel.snp.bottom).offset(8)
            make.leading.equalTo(premiumImageContainer.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    @objc private func editButtonTapped(_ sender: UIButton) {
        print("editButton tapped")
    }
}

fileprivate extension UIView {
    func drawDoubleCircle(below: CALayer) {
        let radius = 113.5
        let center = CGPoint(x: bounds.maxX - 30.0, y: bounds.minY + 10.0)
        let bigCirclePath = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: 0,
                                endAngle: 2 * .pi,
                                clockwise: false)
        
        let bigCircleShape = CAShapeLayer()
        bigCircleShape.fillColor = UIColor(hexString: "#F09133").cgColor
        bigCircleShape.path = bigCirclePath.cgPath

        let subRadius = 83.5
        let subCenter = CGPoint(x: bounds.maxX - 30.0, y: bounds.minY + 10.0)
        let smallCirclePath = UIBezierPath(arcCenter: subCenter,
                                radius: subRadius,
                                startAngle: 0,
                                endAngle: 2 * .pi,
                                clockwise: false)
        
        let smallCircleShape = CAShapeLayer()
        smallCircleShape.fillColor = UIColor(hexString: "#F29D33").cgColor
        smallCircleShape.path = smallCirclePath.cgPath
        
        layer.masksToBounds = true
        layer.insertSublayer(bigCircleShape, below: below)
        layer.insertSublayer(smallCircleShape, below: below)
    }
}
