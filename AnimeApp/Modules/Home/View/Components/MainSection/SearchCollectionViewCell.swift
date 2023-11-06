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
            guard let self = self else { return }
            print("searchTextChanged = \(text)")
            DispatchQueue.main.asyncDeduped(target: self, after: 1.0) {
                self.delegate?.searchAnimes(text)
            }
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
