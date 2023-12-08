//
//  MyPetsCollectionViewManager.swift
//  PawPal
//
//  Created by Cynthia Zhang on 12/6/23.
//

import Foundation
import UIKit

extension MyPetsViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petsData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPetsCell", for: indexPath) as? MyPetsCollectionViewCell else {
            fatalError("Cell not found")
        }

        let petData = petsData[indexPath.row]
        
        cell.configureCell(with: petData, pageIndex: indexPath.row, totalPages: petsData.count, hideDeleteButton: isDeleteButtonHidden)

        // Setting the callback for the delete button
        cell.deleteButtonTapCallback = { [weak self, weak cell] in
            // Since the cell might be reused, we need to obtain the latest indexPath corresponding to the current button
            guard let strongSelf = self, let currentIndexPath = cell.flatMap({ strongSelf.collectionView.indexPath(for: $0) }) else {
                return
            }

            let alertController = UIAlertController(title: "Delete Pet", message: "Are you sure you want to delete this pet?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                strongSelf.deletePetAndImages(at: currentIndexPath)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            strongSelf.present(alertController, animated: true, completion: nil)
            }

            return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
        pageIndicator.currentPage = currentPage
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)

        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset

    }
    
}
