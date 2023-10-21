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
    
    private lazy var searchView: SearchView = {
        let searchView = SearchView(mode: .withFilter)
        return searchView
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
        contentView.addSubview(searchView)
    }
    
    private func setupConstraints() {
        searchView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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
