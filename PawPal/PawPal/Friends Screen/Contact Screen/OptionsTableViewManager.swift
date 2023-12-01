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
            sendMessage(currentUserEmail: currentUserEmail, contactEmail: contactEmail)
        }else if selectedOption == "Moments", let contact = contact {
            navigateToMyMomentsScreen(contact: contact)
        }else if selectedOption == "Delete Contact", let contactEmail = contact?.userEmail {
            deleteContact(contactEmail: contactEmail)
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
    
    func deleteContact(contactEmail: String) {
        let alertController = UIAlertController(title: "Delete Contact", message: "Are you sure you want to delete this contact? This action cannot be undone.", preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.performDeletion(contactEmail: contactEmail)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func performDeletion(contactEmail: String) {
        // delete...
    }

}
