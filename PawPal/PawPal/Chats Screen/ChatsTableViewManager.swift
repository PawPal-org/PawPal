//
//  ChatsTableViewManager.swift
//  PawPal
//
//  Created by Yitian Guo on 11/28/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredChatsList.count : chatsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewChatsID, for: indexPath) as! ChatsTableViewCell
        
        let chat = isSearchActive ? filteredChatsList[indexPath.row] : chatsList[indexPath.row]
        
        fetchFriendNameAndPic(from: chat.friends, for: cell)
        cell.labelLastMessage.text = chat.lastMessage
        cell.labelTimestamp.text = formatDate(chat.lastMessageTimestamp.dateValue())

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedChat = isSearchActive ? filteredChatsList[indexPath.row] : chatsList[indexPath.row]

        let chatID = selectedChat.id
        let messageScreen = MessageViewController()
        messageScreen.chatID = chatID
        messageScreen.currentUser = self.currentUser
        
        self.navigationController?.pushViewController(messageScreen, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func fetchFriendNameAndPic(from friends: [String], for cell: ChatsTableViewCell) {
        guard let currentUserEmail = currentUser?.email else {
            cell.labelName.text = "Unknown"
            return
        }

        let friendEmail = friends.first { $0 != currentUserEmail } ?? ""

        database.collection("users").document(friendEmail).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot, error == nil {
                let friendName = document.data()?["name"] as? String ?? "Unknown"
                let profilePicUrlString = document.data()?["profileImageUrl"] as? String ?? ""
                DispatchQueue.main.async {
                    cell.labelName.text = friendName
                }
                
                if let url = URL(string: profilePicUrlString) {
//                    URLSession.shared.dataTask(with: url) { data, response, error in
//                        guard let data = data, error == nil, let image = UIImage(data: data) else {
//                            print("Error downloading profile image: \(error?.localizedDescription ?? "Unknown error")")
//                            return
//                        }
//
//                        DispatchQueue.main.async {
//                            cell.buttonProfilePic.setBackgroundImage(image, for: .normal)
//                        }
//                    }.resume()
                    // Using SDWebImage to set the image
                    cell.buttonProfilePic.sd_setBackgroundImage(with: url, for: .normal, completed: nil)
                } else {
                    cell.buttonProfilePic.setBackgroundImage(UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            } else {
                print("Error fetching friend's information: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    cell.labelName.text = "Unknown"
                    cell.buttonProfilePic.setBackgroundImage(UIImage(systemName: "person.crop.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
        }
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

}
