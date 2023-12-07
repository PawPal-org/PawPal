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
import FirebaseStorage

extension MomentsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewMomentsID, for: indexPath) as! MomentsTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        let moment = moments[indexPath.row]
        cell.updateLikeCount(moment.likes.count)
        cell.userEmail = moment.userEmail
        let isLiked = moment.likes.contains(Auth.auth().currentUser?.email ?? "")
        cell.setLiked(isLiked)
        cell.configureCell(with: moment)
        
        if moment.userEmail == Auth.auth().currentUser?.email {
            cell.showButtonOptions(shouldShow: true)
        } else {
            cell.showButtonOptions(shouldShow: false)
        }
        return cell
    }
}

extension MomentsViewController: MomentsTableViewCellDelegate {
    func didTapDeleteButton(on cell: MomentsTableViewCell) {
        if let indexPath = momentsView.tableViewMoments.indexPath(for: cell) {
            let momentToDelete = moments[indexPath.row]

            // Show confirmation alert
            let deleteAlert = UIAlertController(title: "Delete Moment", message: "Are you sure you want to delete this moment?", preferredStyle: .alert)

            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                // Proceed with deletion
                self?.moments.remove(at: indexPath.row)
                self?.momentsView.tableViewMoments.deleteRows(at: [indexPath], with: .automatic)
                self?.deleteMomentFromDatabase(moment: momentToDelete)
            }))

            present(deleteAlert, animated: true)
        }
    }
    
    private func deleteMomentFromDatabase(moment: Moment) {
        guard let momentID = moment.id else { return }
        let db = Firestore.firestore()
        let storage = Storage.storage()

        // Delete the moment document from Firestore
        db.collection("users").document(moment.userEmail!).collection("moments").document(momentID).delete() { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")

                // Delete associated images from Firebase Storage
                for (_, imageUrlString) in moment.imageUrls {
                    guard let imageUrl = URL(string: imageUrlString) else { continue }
                    let imageName = imageUrl.lastPathComponent
                    let storageRef = storage.reference().child("post_images").child(imageName)
                    storageRef.delete { error in
                        if let error = error {
                            print("Error deleting image: \(error)")
                        } else {
                            print("Image successfully deleted")
                        }
                    }
                }
            }
        }
    }
    
    func didTapLikeButton(on cell: MomentsTableViewCell) {
        guard let indexPath = momentsView.tableViewMoments.indexPath(for: cell),
              let userEmail = Auth.auth().currentUser?.email else { return }

        var moment = moments[indexPath.row]
        var updatedLikes = moment.likes
        
        let isLiked: Bool
        if let index = updatedLikes.firstIndex(of: userEmail) {
            updatedLikes.remove(at: index)
            isLiked = false
        } else {
            updatedLikes.append(userEmail)
            isLiked = true
        }
        
        // Update the moment in the local array
        moment.likes = updatedLikes
        moments[indexPath.row] = moment
        
        cell.setLiked(isLiked)
        cell.animateLikeButton()

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

        // Reload the specific row
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.momentsView.tableViewMoments.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func didTapUserImageButton(on cell: MomentsTableViewCell) {
        let myMomentsView = MyMomentsViewController()
        myMomentsView.userEmail = cell.userEmail
        myMomentsView.userName = cell.labelName.text
        self.navigationController?.pushViewController(myMomentsView, animated: true)
    }
}
