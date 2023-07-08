//
//  PopupView.swift
//  AnimeApp
//
//  Created by Марат on 15.06.2023.
//

import UIKit
import SnapKit

// MARK: - PopupView
class PopupView: UIView {
    
    var type: PopupType? {
        didSet {
            guard let type = type else { return }
            
            imageView.image = UIImage(named: type.imageName)
            titleLabel.text = type.title
            descriptionLabel.text = type.description
            
            doneButton.setTitle(type.doneButtonTitle, for: .normal)
            cancelButton.setTitle(type.cancelButtonTitle, for: .normal)
            
            doneButton.backgroundColor = type.doneButtonBackgroundColor
            cancelButton.backgroundColor = type.cancelButtonBackgroundColor
            switch type {
            case .logout:
                doneButton.setTitleColor(.brandLightBlue, for: .normal)
                cancelButton.setTitleColor(.white, for: .normal)
                
                titleLabel.numberOfLines = 1
                descriptionLabel.numberOfLines = 3
                
                descriptionLabel.setLineHeight(lineHeightMultiple: 1.31)
                descriptionLabel.textAlignment = .center
                
                doneButton.isHidden = false
                cancelButton.isHidden = false
            case .paymentSuccess:
                doneButton.setTitleColor(.white, for: .normal)
                doneButton.setTitleColor(.brandGray, for: .highlighted)
                
                titleLabel.numberOfLines = 2
                descriptionLabel.numberOfLines = 3
                
                titleLabel.setLineHeight(lineHeightMultiple: 1.31)
                descriptionLabel.setLineHeight(lineHeightMultiple: 1.31)
                
                titleLabel.textAlignment = .center
                descriptionLabel.textAlignment = .center
                
                doneButton.isHidden = false
                cancelButton.isHidden = true
            default:
                break
            }
        }
    }
    
    private let blurBackgroundView: UIVisualEffectView = {
        let blurEffetc = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffetc)
        return view
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandBlue
        view.layer.cornerRadius = 32
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "ic-bigQuestion")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .montserratSemiBold(size: 18)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .montserratRegular(size: 12)
        lbl.textColor = .brandGray
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.setContentHuggingPriority(.required, for: .vertical)
        return lbl
    }()
    
    private lazy var doneButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .brandBlue
        btn.isOpaque = true
        btn.layer.cornerRadius = 30
        btn.layer.masksToBounds = true
        btn.layer.cornerCurve = .continuous
        btn.layer.borderColor = UIColor.brandLightBlue.cgColor
        btn.layer.borderWidth = 1
        btn.titleLabel?.font = .poppinsRegular(size: 16)
        btn.setTitleColor(.brandGray, for: .highlighted)
        btn.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .brandLightBlue
        btn.isOpaque = true
        btn.layer.cornerRadius = 30
        btn.layer.masksToBounds = true
        btn.layer.cornerCurve = .continuous
        btn.titleLabel?.font = .poppinsRegular(size: 16)
        btn.setTitleColor(.brandGray, for: .highlighted)
        btn.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    let leftPlugView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    let rightPlugView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        doneButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width * 0.3023)
        }
        cancelButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width * 0.3023)
        }
        
        let stack = UIStackView(arrangedSubviews: [doneButton, cancelButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = 12
        return stack
    }()
    
    private lazy var generalStackView: UIStackView = {
        horizontalStackView.snp.makeConstraints { $0.height.equalTo(60) }
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, horizontalStackView])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 12
        stack.setCustomSpacing(32, after: descriptionLabel)
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(outPopupTapped(_:)))
        tapRecognizer.delegate = self
        addGestureRecognizer(tapRecognizer)
        
        showPopup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupViews() {
        addSubview(blurBackgroundView)
        
        blurBackgroundView.contentView.addSubview(containerView)
        
        containerView.addSubviews(imageView, generalStackView)
    }
    
    private func setupConstraints() {
        
        blurBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
            // TODO: it just mock height
            make.height.equalTo(432)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.horizontalEdges.equalToSuperview().inset(101)
            make.height.equalTo(125)
        }
        
        generalStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(42)
            make.horizontalEdges.equalToSuperview().inset(27)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    private func showPopup() {
        let yStartPosition = UIScreen.main.bounds.height
        containerView.transform = CGAffineTransform(translationX: 0.0, y: yStartPosition)
        
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3) {
            self.containerView.transform = .identity
        }
    }
    
    private func hidePopup() {
        let yStartPosition = UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.containerView.transform = CGAffineTransform(translationX: 0, y: yStartPosition)
        } completion: { [weak self] _ in
            self?.containerView.removeFromSuperview()
            self?.removeFromSuperview()
        }
    }
    
    @objc private func outPopupTapped(_ sender: UITapGestureRecognizer) {
        hidePopup()
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        print("doneButtonTapped")
        hidePopup()
    }
    
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        print("cancelButtonTapped")
        hidePopup()
    }
}

extension PopupView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if containerView.bounds.contains(touch.location(in: containerView)) {
            return false
        }
        return true
    }
}

// TODO: - move it to helpers folder
extension UILabel {
    
    func setLineHeight(lineHeightMultiple: CGFloat) {
        guard let text = self.text else { return }
        
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
    
        style.lineHeightMultiple = lineHeightMultiple
        attributeString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: attributeString.length))
        
        self.attributedText = attributeString
    }

}
