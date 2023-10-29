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
        searchView.delegate = self
        
        searchView.searchTextChanged = { [weak self] text in
            print("searchTextChanged = \(text)")
        }
        
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

extension SearchCollectionViewCell: SearchViewDelegate {
    func filterButtonTapped() {
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
