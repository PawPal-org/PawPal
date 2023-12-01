//
//  NewFriendsTableViewManager.swift
//  PawPal
//
//  Created by Yitian Guo on 11/30/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

extension NewFriendsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newFriendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewNewFriendsID, for: indexPath) as! NewFriendsTableViewCell
        
        let newFriend = newFriendsList[indexPath.row]
        
        cell.labelName.text = newFriend.userName
        
        cell.buttonProfilePic.setBackgroundImage(UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        if let imageUrlString = newFriend.userProfilePicUrl, let url = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data, error == nil, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.buttonProfilePic.setBackgroundImage(image, for: .normal)
                    }
                }
            }.resume()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        cell.labelTimestamp.text = dateFormatter.string(from: newFriend.timestamp)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
        let acceptAction = UIContextualAction(style: .normal, title: "Accept") { [weak self] (action, view, completionHandler) in
            self?.handleAcceptAction(at: indexPath)
            completionHandler(true)
        }
        acceptAction.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        
        let rejectAction = UIContextualAction(style: .destructive, title: "Reject") { [weak self] (action, view, completionHandler) in
            self?.handleRejectAction(at: indexPath)
            completionHandler(true)
        }
        rejectAction.backgroundColor = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
        
        let configuration = UISwipeActionsConfiguration(actions: [rejectAction, acceptAction])
        
        return configuration
    }

    func handleAcceptAction(at indexPath: IndexPath) {
        guard let currentUserEmail = currentUser?.email else { return }
        let newFriendEmail = newFriendsList[indexPath.row].userEmail

        let userDocRef = database.collection("users").document(currentUserEmail)
        let newFriendDocRef = database.collection("users").document(newFriendEmail)

        database.runTransaction({ (transaction, errorPointer) -> Any? in
            let currentUserDocument: DocumentSnapshot
            let newFriendDocument: DocumentSnapshot

            do {
                try currentUserDocument = transaction.getDocument(userDocRef)
                try newFriendDocument = transaction.getDocument(newFriendDocRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            var currentUserFriends = currentUserDocument.get("friends") as? [String] ?? []
            var currentUserFriendsRequest = currentUserDocument.get("friendsRequest") as? [String: Timestamp] ?? [:]

            currentUserFriendsRequest[newFriendEmail] = nil
            if !currentUserFriends.contains(newFriendEmail) {
                currentUserFriends.append(newFriendEmail)
            }

            transaction.updateData(["friends": currentUserFriends, "friendsRequest": currentUserFriendsRequest], forDocument: userDocRef)

            var newFriendFriends = newFriendDocument.get("friends") as? [String] ?? []
            if !newFriendFriends.contains(currentUserEmail) {
                newFriendFriends.append(currentUserEmail)
            }

            transaction.updateData(["friends": newFriendFriends], forDocument: newFriendDocRef)

            return nil
        }) { [weak self] (object, error) in
            if let error = error {
                print("Error updating documents: \(error)")
            } else {
                self?.fetchNewFriends()
            }
        }
    }


    func handleRejectAction(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Reject Friend Request",
                                      message: "Are you sure you want to reject this friend request?",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.confirmRejectAction(at: indexPath)
        }))

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    func confirmRejectAction(at indexPath: IndexPath) {
        guard let currentUserEmail = currentUser?.email else { return }
        let rejectedFriendEmail = newFriendsList[indexPath.row].userEmail

        let userDocRef = database.collection("users").document(currentUserEmail)

        userDocRef.getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot, document.exists {
                var friendsRequest = document.get("friendsRequest") as? [String: Timestamp] ?? [:]
                
                friendsRequest.removeValue(forKey: rejectedFriendEmail)
                
                userDocRef.updateData([
                    "friendsRequest": friendsRequest
                ]) { [weak self] error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        self?.fetchNewFriends()
                    }
                }
            } else if let error = error {
                print("Error getting document: \(error)")
            }
        }
    }

    
}
