//
//  TestCollectionViewFlowLayout.swift
//  AnimeApp
//
//  Created by Marat on 08.05.2023.
//

import UIKit

enum CollectionDisplay {
    case inline
    case list
    case grid
}

class TestCollectionViewFlowLayout: UICollectionViewFlowLayout {

    var display: CollectionDisplay = .grid {
        didSet {
            if display != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    convenience init(display: CollectionDisplay) {
        self.init()
        
        self.display = display
        self.minimumLineSpacing = 10
        self.minimumInteritemSpacing = 10
        configLayout()
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        configLayout()
    }
    
    private func configLayout() {
        switch display {
        case .inline:
            self.scrollDirection = .horizontal
            if let collectionView = self.collectionView {
                let optimisedWidth = (collectionView.bounds.width - (2 * minimumInteritemSpacing + 30)) / 3
                self.itemSize = CGSize(width: optimisedWidth, height: optimisedWidth)
            }
        case .list:
            self.scrollDirection = .vertical
             if let collectionView = self.collectionView {
                 let optimisedWidth = (collectionView.bounds.width - minimumInteritemSpacing - 30) / 2
                 self.itemSize = CGSize(width: optimisedWidth, height: optimisedWidth) // keep as square
             }
        case .grid:
            self.scrollDirection = .vertical
              if let collectionView = self.collectionView {
                  self.itemSize = CGSize(width: collectionView.bounds.width - 30, height: 130)
              }
        }
    }
}
