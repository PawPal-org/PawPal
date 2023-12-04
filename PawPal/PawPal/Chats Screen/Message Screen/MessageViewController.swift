//
//  MessageViewController.swift
//  PawPal
//
//  Created by Yitian Guo on 11/28/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MessageViewController: UIViewController {

    var chatID: String!
    var currentUser: FirebaseAuth.User?
    var messages = [Message]()
    
    let messageScreen = MessageView()
    let database = Firestore.firestore()
    
    override func loadView() {
        view = messageScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupRightBarButton()
        fetchFriendNameAndPic()
        navigationItem.hidesBackButton = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Scroll to the last message if the view has just appeared
        if messages.count > 0 {
            let lastIndexPath = IndexPath(row: messages.count - 1, section: 0)
            messageScreen.tableViewMessages.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //MARK: setting the delegate and data source...
        messageScreen.tableViewMessages.dataSource = self
        messageScreen.tableViewMessages.delegate = self
         
        //MARK: removing the separator line...
        messageScreen.tableViewMessages.separatorStyle = .none
        
        //MARK: getting all messages...
        getAllMessages()
        
        //MARK: adding action for Login screen...
        messageScreen.buttonSend.addTarget(self, action: #selector(onButtonSendTapped), for: .touchUpInside)
        
        //MARK: recognizing the taps on the app screen, not the keyboard
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func fetchFriendNameAndPic() {
        guard let currentUserEmail = currentUser?.email else {
            return
        }
        
        database.collection("chats").document(chatID).getDocument { [weak self] (documentSnapshot, error) in
            guard let self = self else { return }

            if let document = documentSnapshot, error == nil, let friends = document.data()?["friends"] as? [String] {
                // Assuming the participants array contains the emails of the two users in the chat
                let friendEmail = friends.first { $0 != currentUserEmail } ?? ""

                // Fetch friend's details from the users collection
                self.database.collection("users").document(friendEmail).getDocument { (documentSnapshot, error) in
                    if let document = documentSnapshot, error == nil {
                        let friendName = document.data()?["name"] as? String ?? "Unknown"
                        let profilePicUrlString = document.data()?["profileImageUrl"] as? String ?? ""

                        DispatchQueue.main.async {
                            self.title = friendName
                            self.updateProfilePicture(urlString: profilePicUrlString)
                        }
                    } else {
                        print("Error fetching friend's information: \(error?.localizedDescription ?? "Unknown error")")
                        DispatchQueue.main.async {
                            self.title = "Unknown"
                        }
                    }
                }
            } else {
                print("Error fetching chat participants: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func updateProfilePicture(urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    print("Error downloading profile image: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                DispatchQueue.main.async {
                    // Set the profile picture image
                }
            }.resume()
        }
    }
    
    //MARK: on send button tapped...
    @objc func onButtonSendTapped(){
        
        if let messageText = messageScreen.textViewMessageText.text, !messageText.isEmpty {
            sendANewMessage(text: messageText)
        } else {
            // Handle the case where the text field is empty
            print("send message is empty")
        }
    }
    
    func sendANewMessage(text: String) {
        guard let sender = currentUser?.email else {
            print("Current user display name is nil")
            return
        }
        
        let message = Message(sender: sender,
                              messageText: text,
                              timestamp: Date())
        
        do {
            try database.collection("chats").document(chatID).collection("messages").addDocument(from: message) { error in
                if let error = error {
                    print("Error sending message: \(error.localizedDescription)")
                } else {
                    // update last message info in chat document
                    self.updateLastMessageInfo(chatID: self.chatID, lastMessage: text)
                    self.getAllMessages()
                }
            }
        } catch {
            print("Error encoding message: \(error.localizedDescription)")
        }
    }
    
    func updateLastMessageInfo(chatID: String, lastMessage: String) {
        database.collection("chats").document(chatID).updateData([
            "lastMessage": lastMessage,
            "lastMessageTimestamp": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                print("Error updating last message info: \(error)")
            }
        }
    }
    
    func getAllMessages(){
        // fetch all messages in Document(chatID)
        self.database.collection("chats").document(chatID).collection("messages")
            .order(by: "timestamp", descending: false) // messages in chronological order
            .addSnapshotListener(includeMetadataChanges: false) { [weak self] querySnapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error getting messages: \(error.localizedDescription)")
                } else if let documents = querySnapshot?.documents {
                    self.messages.removeAll()
                    for document in documents {
                        do {
                            let message = try document.data(as: Message.self)
                            self.messages.append(message)
                        } catch {
                            print("Error decoding message: \(error)")
                        }
                    }
                    // messages sorted by timestamp in ascending order
                    self.messages.sort(by: { $0.timestamp < $1.timestamp })
                    self.messageScreen.tableViewMessages.reloadData()
                    self.messageScreen.textViewMessageText.text = ""
                    
                    // scroll to the last row in the section
                    if self.messages.count > 0 {
                        let lastIndexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.messageScreen.tableViewMessages.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
                    }
                }
            }
    }
    
    //MARK: Hide Keyboard
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen
        view.endEditing(true)
    }

}
