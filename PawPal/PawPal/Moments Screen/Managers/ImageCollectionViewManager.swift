//
//  ImageCollectionViewManager.swift
//  PawPal
//
//  Created by Yitian Guo on 11/20/23.
//

import Foundation
import UIKit

extension MomentsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        let image = images[indexPath.item]
        cell.imageView.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the size of each cell, which should match the collection view's height
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}
