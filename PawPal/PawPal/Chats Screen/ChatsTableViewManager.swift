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

        // Fetch the current user's notFriend list
        database.collection("users").document(currentUserEmail).getDocument { [weak self] (currentUserDoc, error) in
            guard let notFriendList = currentUserDoc?.data()?["notFriends"] as? [String], error == nil else {
                print("Error fetching current user's notFriend list: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let isNotFriend = notFriendList.contains(friendEmail)

            // Fetch friend's details from the users collection
            self?.database.collection("users").document(friendEmail).getDocument { (documentSnapshot, error) in
                if let document = documentSnapshot, error == nil {
                    let friendName = document.data()?["name"] as? String ?? "Unknown"
                    let profilePicUrlString = document.data()?["profileImageUrl"] as? String ?? ""
                    DispatchQueue.main.async {
                        cell.labelName.text = friendName
                        cell.labelName.textColor = isNotFriend ? .red : .black
                    }
                    
                    // Set the profile picture
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
                        cell.buttonProfilePic.sd_setImage(with: url, for: .normal, completed: nil)
                    } else {
                        cell.buttonProfilePic.setImage(nil, for: .normal)
                    }
                } else {
                    print("Error fetching friend's information: \(error?.localizedDescription ?? "Unknown error")")
                    DispatchQueue.main.async {
                        cell.labelName.text = "Unknown"
                        cell.buttonProfilePic.setImage(nil, for: .normal)
                        cell.labelName.textColor = .black
                    }
                }
            }
        }
    }

    func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "'Yesterday, 'h:mm a"
            return formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            return formatter.string(from: date)
        }
    }

}
