//
//  CarouselCollectionViewCell.swift
//  AnimeApp
//
//  Created by Марат on 31.07.2023.
//

import UIKit
import SnapKit

// MARK: - CarouselCollectionViewCell
final class CarouselCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: CarouselCollectionViewCell.self)
    
    var centerCell: TopAnimeCollectionViewCell?
    
    // TODO: - mock, should be deleted
    private let colors: [UIColor] = [.red, .green, .blue]
    
    private lazy var collectionView: UICollectionView = {        
        let layout = SnappingLayout()
        layout.scrollDirection = .horizontal
        layout.snapPosition = .right
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .brandDarkBlue
        collection.isOpaque = true
        collection.contentInset = UIEdgeInsets(top: Constants.Insets.top,
                                               left: Constants.Insets.left,
                                               bottom: Constants.Insets.bottom,
                                               right: Constants.Insets.right)
        collection.register(TopAnimeCollectionViewCell.self,
                            forCellWithReuseIdentifier: TopAnimeCollectionViewCell.identifier)
        
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        
        collection.decelerationRate = .fast
        collection.dataSource = self
        collection.delegate = self
        
        return collection
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = CustomPageControl()
        pageControl.pageIndicatorTintColor = .brandLightBlue.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = .brandLightBlue
        pageControl.pageIndicatorCornerRadius = 4
        pageControl.currentpageIndicatorCornerRadius = 4
        pageControl.numberOfPages = colors.count
        pageControl.currentPage = 0
        return pageControl
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        contentView.addSubviews(collectionView, pageControl)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(12)
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(8)
        }
    }
    
    // получение центральной точки в collectionView
    private func centerPoint(of collectionView: UICollectionView, in scrollView: UIScrollView) -> CGPoint {
        let centerXPos = collectionView.frame.width / 2 + scrollView.contentOffset.x
        let centerYPos = collectionView.frame.height / 2 + scrollView.contentOffset.y
        return CGPoint(x: centerXPos, y: centerYPos)
    }
}

// MARK: - UICollectionViewDataSource
extension CarouselCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopAnimeCollectionViewCell.identifier,
                                                            for: indexPath) as? TopAnimeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = colors[indexPath.item]
        
        let cellRect = collectionView.convert(cell.frame, to: collectionView.superview)
        if collectionView.frame.contains(cellRect) {
            let factorY = Constants.ItemSize.centeredHeight / Constants.ItemSize.defaultHeight
            cell.transformToLarge(factorX: 1.0, factorY: factorY)
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension CarouselCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("carouselCollectionViewCell tapped at \(indexPath)")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CarouselCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(UIScreen.main.bounds.width)
        return CGSize(width: Constants.ItemSize.itemWidth, height: Constants.ItemSize.defaultHeight)
    }
}

// MARK: - UIScrollViewDelegate
extension CarouselCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let centerPoint = centerPoint(of: collectionView, in: scrollView)
        
        guard let indexPath = collectionView.indexPathForItem(at: centerPoint),
              let centerCell = collectionView.cellForItem(at: indexPath) as? TopAnimeCollectionViewCell else {
            return
        }
        
        let cellRect = collectionView.convert(centerCell.frame, to: collectionView.superview)
        
        if collectionView.frame.contains(cellRect), self.centerCell == nil {
            self.centerCell = centerCell
            pageControl.currentPage = indexPath.item
            
            let factorY = Constants.ItemSize.centeredHeight / Constants.ItemSize.defaultHeight
            UIView.animate(withDuration: 0.2) {
                self.centerCell?.transformToLarge(factorX: 1.0, factorY: factorY)
            }
        }
        
        if let cell = self.centerCell {
            let offsetX = centerPoint.x - centerCell.center.x
            
            if abs(offsetX) > 70 {
                self.centerCell = nil
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear) {
                    cell.transformToNormal()
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        self.collectionView.scrollToNearestVisibleCollectionViewCell()
    }

    // вызывается после того, как закончился скрол
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if !decelerate {
//            self.collectionView.scrollToNearestVisibleCollectionViewCell()
//        }
    }
}

// MARK: - ItemConstants
fileprivate struct Constants {
    private static let screenWidth  = UIScreen.main.bounds.width
    private static let screenHeight = UIScreen.main.bounds.height
    
    struct ItemSize {
        static let itemWidth      = screenWidth * 0.786
        static let defaultHeight  = screenHeight * 0.139
        static let centeredHeight = screenHeight * 0.189
    }
    
    struct Insets {
        static let top      = 0.0
        static let left     = (screenWidth - ItemSize.itemWidth) / 2
        static let bottom   = 0.0
        static let right    = (screenWidth - ItemSize.itemWidth) / 2
    }
}
