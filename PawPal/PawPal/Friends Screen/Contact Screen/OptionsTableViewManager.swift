//
//  OptionsTableViewManager.swift
//  PawPal
//
//  Created by Yitian Guo on 11/30/23.
//

import Foundation
import UIKit
import FirebaseFirestore

extension ContactViewController {
    
    // MARK: Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewOptionsID, for: indexPath) as? OptionsTableViewCell else {
            fatalError("Cell not found")
        }
        cell.configure(with: options[indexPath.row])
        return cell
    }
    
    // MARK: Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedOption = options[indexPath.row]
        if selectedOption == "Send a Message", let currentUserEmail = currentUser?.email, let contactEmail = contact?.userEmail {
            if !(contact?.isFriend)! {
                showAlert(title:"Alert", message:"Chat history is retained, but the counterpart will not receive your subsequent message.")
            }else {
                sendMessage(currentUserEmail: currentUserEmail, contactEmail: contactEmail)
            }
        }else if selectedOption == "Moments", let contact = contact {
            if !(contact.isFriend)! {
                showAlert(title:"Unavailable", message:"You cannot see moments as this user is no longer your friend.")
            }else {
                navigateToMyMomentsScreen(contact: contact)
            }
        }else if selectedOption == "Delete Contact", let contactEmail = contact?.userEmail {
            deleteContact(contactEmail: contactEmail)
        }else if selectedOption == "Pets", let contactEmail = contact?.userEmail {
            if !(contact?.isFriend)! {
                showAlert(title:"Unavailable", message:"You cannot see pets as this user is no longer your friend.")
            }else {
                navigateToMyPetsScreen(contactEmail: contactEmail)
            }
        }
    }
    
    func sendMessage(currentUserEmail: String, contactEmail: String) {
        let userChatsCollection = Firestore.firestore().collection("users").document(currentUserEmail).collection("chats")
        
        userChatsCollection.getDocuments { snapshot, error in
            if let error = error {
                print("Error getting chat references: \(error)")
                return
            }

            guard let snapshot = snapshot, !snapshot.isEmpty else {
                self.createChat(currentUserEmail: currentUserEmail, contactEmail: contactEmail)
                return
            }

            let chatRefs = snapshot.documents.compactMap { $0.get("ref") as? DocumentReference }
            let group = DispatchGroup()

            for chatRef in chatRefs {
                group.enter()
                chatRef.getDocument { (document, error) in
                    defer { group.leave() }

                    if let document = document, document.exists {
                        let friends = document.get("friends") as? [String] ?? []
                        if Set(friends) == Set([currentUserEmail, contactEmail]) {
                            // Find the chat with the exact match
                            self.navigateToMessageScreen(withChatId: document.documentID)
                            return
                        }
                    } else if let error = error {
                        print("Error getting chat document: \(error)")
                    }
                }
            }

            group.notify(queue: .main) {
                // If we're still on the same screen, no matching chat was found
                if self.navigationController?.topViewController == self {
                    self.createChat(currentUserEmail: currentUserEmail, contactEmail: contactEmail)
                }
            }
        }
    }


    func createChat(currentUserEmail: String, contactEmail: String) {
        let firestore = Firestore.firestore()
        let chatsCollection = firestore.collection("chats")
        
        var ref: DocumentReference? = nil
        ref = chatsCollection.addDocument(data: [
            "friends": [currentUserEmail, contactEmail]
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else if let newChatID = ref?.documentID {

                let chatDocumentReference = firestore.collection("chats").document(newChatID)
                let chatReferenceData: [String: Any] = ["ref": chatDocumentReference]
                
                firestore.collection("users").document(currentUserEmail).collection("chats").document(newChatID).setData(chatReferenceData)
                firestore.collection("users").document(contactEmail).collection("chats").document(newChatID).setData(chatReferenceData)

                self.navigateToMessageScreen(withChatId: newChatID)
            }
        }
    }

    func navigateToMessageScreen(withChatId chatId: String?) {
        guard let chatId = chatId else { return }
        let messageScreen = MessageViewController()
        messageScreen.chatID = chatId
        messageScreen.currentUser = self.currentUser
        self.navigationController?.pushViewController(messageScreen, animated: true)
    }
    
    func navigateToMyMomentsScreen(contact: Contact) {
        let MyMomentScreen = MyMomentsViewController()
        MyMomentScreen.userEmail = contact.userEmail
        MyMomentScreen.userName = contact.userName
        MyMomentScreen.currentUser = self.currentUser
        self.navigationController?.pushViewController(MyMomentScreen, animated: true)
    }
    
    func navigateToMyPetsScreen(contactEmail: String) {
        let MyPetsScreen = MyPetsViewController()
        MyPetsScreen.userEmail = contactEmail
        MyPetsScreen.hideAddBarButton = true
        self.navigationController?.pushViewController(MyPetsScreen, animated: true)
    }
    
    func deleteContact(contactEmail: String) {
        let alertController = UIAlertController(title: "Delete Contact", message: "Are you sure you want to delete this contact? This will also delete your chat history.", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let strongSelf = self else { return }

            strongSelf.performDeletion(contactEmail: contactEmail) {
                if !(strongSelf.contact?.isFriend ?? true) {
                    strongSelf.deleteNotFriends(contactEmail: contactEmail) {
                        strongSelf.showDeletionSuccessAndPop()
                    }
                } else {
                    strongSelf.changeFriendStatus(contactEmail: contactEmail) {
                        strongSelf.showDeletionSuccessAndPop()
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func performDeletion(contactEmail: String, completion: @escaping () -> Void) {
        guard let currentUserEmail = currentUser?.email else { return }
        let userDocument = Firestore.firestore().collection("users").document(currentUserEmail)
        let userChatsCollection = userDocument.collection("chats")

        userDocument.getDocument { (document, error) in
            if let document = document, let data = document.data() {
                var currentFriends = data["friends"] as? [String] ?? []
                var currentNotFriends = data["notFriends"] as? [String] ?? []

                if let friendIndex = currentFriends.firstIndex(of: contactEmail) {
                    currentFriends.remove(at: friendIndex)
                }
                if let notFriendIndex = currentNotFriends.firstIndex(of: contactEmail) {
                    currentNotFriends.remove(at: notFriendIndex)
                }

                userDocument.updateData(["friends": currentFriends, "notFriends": currentNotFriends]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Contact successfully updated.")
                        self.removeChatReference(userChatsCollection: userChatsCollection, contactEmail: contactEmail)
                    }
                }
            } else if let error = error {
                print("Error getting document: \(error)")
            }
        }
        
        completion()
    }

    func removeChatReference(userChatsCollection: CollectionReference, contactEmail: String) {
        userChatsCollection.getDocuments { snapshot, error in
            if let error = error {
                print("Error getting chat references: \(error)")
                return
            }

            guard let snapshot = snapshot else {
                print("No chat references found.")
                return
            }

            for chatRefDocument in snapshot.documents {
                if let chatRef = chatRefDocument.get("ref") as? DocumentReference {
                    chatRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            
                            let friends = document.get("friends") as? [String] ?? []
                            
                            if friends.count == 2 && Set(friends) == Set([contactEmail, self.currentUser?.email]) {
                                // Increment deletion operation count
                                let existingDeletionCount = document.get("deletionOperations") as? Int ?? 0
                                let updatedDeletionCount = existingDeletionCount + 1
                                
                                // Update deletion operation count
                                chatRef.updateData(["deletionOperations": updatedDeletionCount]) { error in
                                    if let error = error {
                                        print("Error updating deletionOperations count: \(error)")
                                    } else {
                                        print("DeletionOperations count successfully updated.")
                                        
                                        // Check if deletion count equals friends count, then delete the chat
                                        if updatedDeletionCount == friends.count {
                                            chatRef.delete() { error in
                                                if let error = error {
                                                    print("Error deleting chat document: \(error)")
                                                } else {
                                                    print("Chat document successfully deleted.")
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                // Delete the chat reference if it contains only the two specified users
                                userChatsCollection.document(chatRefDocument.documentID).delete() { error in
                                    if let error = error {
                                        print("Error removing chat reference: \(error)")
                                    } else {
                                        print("Chat reference successfully deleted.")
                                    }
                                }
                            }
                            
                        } else if let error = error {
                            print("Error getting chat document: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func changeFriendStatus(contactEmail: String, completion: @escaping () -> Void) {
        //Remove currentUserEmail from the contact's friends array, and add it to the contact's notFriends array
        guard let currentUserEmail = currentUser?.email else { return }

        let contactDocument = Firestore.firestore().collection("users").document(contactEmail)

        contactDocument.getDocument { documentSnapshot, error in
            if let document = documentSnapshot, let data = document.data() {
                var friends = data["friends"] as? [String] ?? []
                var notFriends = data["notFriends"] as? [String] ?? []

                
                if let index = friends.firstIndex(of: currentUserEmail) {
                    friends.remove(at: index)
                }

                if !notFriends.contains(currentUserEmail) {
                    notFriends.append(currentUserEmail)
                }

                contactDocument.updateData([
                    "friends": friends,
                    "notFriends": notFriends
                ]) { error in
                    if let error = error {
                        print("Error updating contact document: \(error)")
                    } else {
                        print("Contact document successfully updated with notFriends field.")
                    }
                }
            } else if let error = error {
                print("Error getting contact document: \(error)")
            }
        }
        completion()
    }
    
    func deleteNotFriends(contactEmail: String, completion: @escaping () -> Void) {
        guard let currentUserEmail = currentUser?.email else { return }
        
        let contactDocument = Firestore.firestore().collection("users").document(contactEmail)

        contactDocument.getDocument { documentSnapshot, error in
            if let document = documentSnapshot, let data = document.data() {
                var friends = data["friends"] as? [String] ?? []
                
                if let index = friends.firstIndex(of: currentUserEmail) {
                    friends.remove(at: index)
                }

                contactDocument.updateData([
                    "friends": friends
                ]) { error in
                    if let error = error {
                        print("Error updating contact document: \(error)")
                    } else {
                        print("Contact document successfully updated with notFriends field.")
                    }
                }
            } else if let error = error {
                print("Error getting contact document: \(error)")
            }
        }
        completion()
    }
    
    func showDeletionSuccessAndPop() {
        let alert = UIAlertController(title: "Success", message: "Contact successfully deleted.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

}
