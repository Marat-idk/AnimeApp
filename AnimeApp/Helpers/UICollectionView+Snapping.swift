//
//  UICollectionView+Snapping.swift
//  AnimeApp
//
//  Created by Марат on 03.08.2023.
//

import UIKit

// MARK: - UICollectionView+Snapping
extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() {
        // scroll speed
        decelerationRate = .fast
        let visibleCenterPositionOfScrollView = Float((bounds.size.width / 2) + contentOffset.x)
        var closestCellIndex = -1
        var closestDistance = Float.greatestFiniteMagnitude
        
        for cell in visibleCells {
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = indexPath(for: cell)?.row ?? 0
            }
        }
        
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(item: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}
