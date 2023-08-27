//
//  CategoryCollectionViewCell.swift
//  AnimeApp
//
//  Created by Марат on 06.08.2023.
//

import UIKit
import SnapKit

// MARK: CategoryCollectionViewCellDelegate
protocol CategoryCollectionViewCellDelegate: AnyObject {
    func didSelected(_ genre: Genre)
}

// MARK: - CategoryCollectionViewCell
final class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: CategoryCollectionViewCell.self)
    
    weak var delegate: CategoryCollectionViewCellDelegate?
    
    var genres: [Genre]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .brandDarkBlue
        collectionView.isOpaque = true
        
        collectionView.contentInset = UIEdgeInsets(top: Constants.Insets.top,
                                                   left: Constants.Insets.left,
                                                   bottom: Constants.Insets.bottom,
                                                   right: Constants.Insets.right)
        collectionView.register(GenreCollectionViewCell.self,
                                forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
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
        print("prepareForReuse")
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
extension CategoryCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier,
                                                            for: indexPath) as? GenreCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.genre = genres?[indexPath.item]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GenreCollectionViewCell else { return }
        cell.isSelected = true
        
        if let genre = genres?[indexPath.item] {
            delegate?.didSelected(genre)
        }
        print("CategoryCollectionViewCell tapped on genre = \(genres?[indexPath.item])")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GenreCollectionViewCell else { return }
        print("didDeselectItemAt")
        cell.isSelected = false
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoryCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let genreName = genres?[indexPath.item].name as? NSString
        
        var width: CGFloat = genreName?.size(withAttributes: [.font: UIFont.montserratMedium(size: 14)!]).width ?? 10.0
        
        print("name = \(genreName), width = \(width)")
        
        width += width < 40.0 ? 64 : 24
        width += 24
        
        let height: CGFloat = 30
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - Constants
fileprivate struct Constants {
    private static let screenWidth  = UIScreen.main.bounds.width
    private static let screenHeight = UIScreen.main.bounds.height
    
    struct ItemSize {
//        static let
    }
    
    struct Insets {
        static let top      = 0.0
        static let left     = 28.0
        static let bottom   = 0.0
        static let right    = 28.0
    }
}
