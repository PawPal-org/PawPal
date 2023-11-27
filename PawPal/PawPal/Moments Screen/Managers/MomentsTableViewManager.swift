//
//  MomentsTableViewManager.swift
//  PawPal
//
//  Created by Yitian Guo on 11/20/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol MomentsTableViewCellDelegate: AnyObject {
    func didTapLikeButton(on cell: MomentsTableViewCell)
}

extension MomentsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewMomentsID, for: indexPath) as! MomentsTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        let moment = moments[indexPath.row]
        let isLiked = moment.likes.contains(Auth.auth().currentUser?.email ?? "")
        cell.setLiked(isLiked)
        cell.configureCell(with: moment)
        return cell
    }
}

extension MomentsViewController: MomentsTableViewCellDelegate {
    func didTapLikeButton(on cell: MomentsTableViewCell) {
        guard let indexPath = momentsView.tableViewMoments.indexPath(for: cell),
              let userEmail = Auth.auth().currentUser?.email else { return }

        let moment = moments[indexPath.row]
        var updatedLikes = moment.likes
        
        let isLiked: Bool
        if let index = updatedLikes.firstIndex(of: userEmail) {
            updatedLikes.remove(at: index)
            isLiked = false
        } else {
            updatedLikes.append(userEmail)
            isLiked = true
        }
        cell.setLiked(isLiked)


        let db = Firestore.firestore()
        db.collection("users").document(moment.userEmail!).collection("moments").document(moment.id!).updateData([
            "likes": updatedLikes
        ]) { error in
            if let error = error {
                print("Error updating likes: \(error)")
            } else {
                print("Likes updated successfully")
            }
        }
    }
}
