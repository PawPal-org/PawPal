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
        cell.configureCell(with: petData, pageIndex: indexPath.row, totalPages: petsData.count)

        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
        pageIndicator.currentPage = currentPage
    }
    
}

