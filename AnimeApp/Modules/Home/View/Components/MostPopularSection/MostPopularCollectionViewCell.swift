//
//  MostPopularCollectionViewCell.swift
//  AnimeApp
//
//  Created by Марат on 11.08.2023.
//

import UIKit
import SnapKit

// MARK: - MostPopularCollectionViewCell
final class MostPopularCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: MostPopularCollectionViewCell.self)
    
    var animes: [Anime]? {
        didSet {
            collectionView.reloadData()
            // FIXME: - подумать мб нужно сделать лучше
            collectionView.setContentOffset(CGPoint(x: -20, y: 0.0), animated: false)
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .brandDarkBlue
        collection.isOpaque = true
        
        collection.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        collection.register(AnimeCollectionViewCell.self,
                            forCellWithReuseIdentifier: AnimeCollectionViewCell.identifier)
        
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        
        collection.dataSource = self
        collection.delegate = self
        
        return collection
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .brandDarkBlue
        isOpaque = true
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Private methods
    private func setupViews() {
        contentView.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension MostPopularCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnimeCollectionViewCell.identifier, for: indexPath) as? AnimeCollectionViewCell else { return UICollectionViewCell() }
        
        cell.anime = animes?[indexPath.row]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MostPopularCollectionViewCell: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MostPopularCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 135.0, height: 230.0)
    }
}
