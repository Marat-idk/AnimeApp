//
//  SearchCollectionViewCell.swift
//  AnimeApp
//
//  Created by Марат on 23.07.2023.
//

import UIKit
import SnapKit

// MARK: - SearchCollectionViewCellDelegate
protocol SearchCollectionViewCellDelegate: AnyObject {
    func searchAnimes(_ searchText: String)
}

// MARK: - SearchCollectionViewCell
final class SearchCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: SearchCollectionViewCell.self)
    
    weak var delegate: SearchCollectionViewCellDelegate?
    
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
    
    private lazy var searchStackView: UIStackView = {
        let firstPlugView = UIView()
        let secondPlugView = UIView()
        
        firstPlugView.snp.makeConstraints { $0.width.equalTo(16) }
        secondPlugView.snp.makeConstraints { $0.width.equalTo(16) }
        
        let stack = UIStackView(arrangedSubviews:
                                    [
                                        firstPlugView,
                                        searchImageView,
                                        searchTextField,
                                        filterContainerView,
                                        secondPlugView
                                    ])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 8
        
        stack.setCustomSpacing(0, after: firstPlugView)
        stack.setCustomSpacing(0, after: filterContainerView)
        
        stack.backgroundColor = .brandBlue
        stack.layer.cornerRadius = 20
        stack.layer.cornerCurve = .continuous
        stack.clipsToBounds = true
        stack.layer.masksToBounds = true
        
        return stack
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
        contentView.addSubview(searchStackView)
        filterContainerView.addSubviews(filterSeparatorView, filterImageView)
    }
    
    private func setupConstraints() {
        searchImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        
        searchStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        filterContainerView.snp.makeConstraints {
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
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        DispatchQueue.main.asyncDeduped(target: self, after: 0.5) { [weak self] in
            self?.delegate?.searchAnimes(text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DispatchQueue {

    /**
     - parameters:
        - target: Object used as the sentinel for de-duplication.
        - delay: The time window for de-duplication to occur
        - work: The work item to be invoked on the queue.
     Performs work only once for the given target, given the time window. The last added work closure
     is the work that will finally execute.
     Note: This is currently only safe to call from the main thread.
     Example usage:
     ```
     DispatchQueue.main.asyncDeduped(target: self, after: 1.0) { [weak self] in
         self?.doTheWork()
     }
     ```
     */
    public func asyncDeduped(target: AnyObject, after delay: TimeInterval, execute work: @escaping @convention(block) () -> Void) {
        let dedupeIdentifier = DispatchQueue.dedupeIdentifierFor(target)
        if let existingWorkItem = DispatchQueue.workItems.removeValue(forKey: dedupeIdentifier) {
            existingWorkItem.cancel()
//            NSLog("Deduped work item: \(dedupeIdentifier)")
        }
        let workItem = DispatchWorkItem {
            DispatchQueue.workItems.removeValue(forKey: dedupeIdentifier)

            for ptr in DispatchQueue.weakTargets.allObjects {
                if dedupeIdentifier == DispatchQueue.dedupeIdentifierFor(ptr as AnyObject) {
                    work()
//                    NSLog("Ran work item: \(dedupeIdentifier)")
                    break
                }
            }
        }

        DispatchQueue.workItems[dedupeIdentifier] = workItem
        DispatchQueue.weakTargets.addPointer(Unmanaged.passUnretained(target).toOpaque())

        asyncAfter(deadline: .now() + delay, execute: workItem)
    }

}

// MARK: - Static Properties for De-Duping
private extension DispatchQueue {

    static var workItems = [AnyHashable: DispatchWorkItem]()

    static var weakTargets = NSPointerArray.weakObjects()

    static func dedupeIdentifierFor(_ object: AnyObject) -> String {
        return "\(Unmanaged.passUnretained(object).toOpaque())." + String(describing: object)
    }

}
