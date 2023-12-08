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
        // setupRightBarButton()
        fetchFriendNameAndPic()
        checkIfChatIsExpired()
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
        
        // Register for keyboard notifications
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Recognizing taps on the app screen
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false // Important to allow interaction with other elements
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
                        // let profilePicUrlString = document.data()?["profileImageUrl"] as? String ?? ""

                        DispatchQueue.main.async {
                            self.title = friendName
                            // self.updateProfilePicture(urlString: profilePicUrlString)
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
    
//    func updateProfilePicture(urlString: String) {
//        if let url = URL(string: urlString) {
//            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//                guard let data = data, error == nil, let image = UIImage(data: data) else {
//                    print("Error downloading profile image: \(error?.localizedDescription ?? "Unknown error")")
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    // Set the profile picture image
//                }
//            }.resume()
//        }
//    }
    
    func checkIfChatIsExpired() {
        guard let currentUserEmail = currentUser?.email, let chatID = self.chatID else {
            print("Missing currentUser email or chatID")
            return
        }

        database.collection("users").document(currentUserEmail).getDocument { [weak self] (documentSnapshot, error) in
            guard let self = self else { return }

            if let document = documentSnapshot, error == nil, let notFriendsList = document.data()?["notFriends"] as? [String] {
                self.database.collection("chats").document(chatID).getDocument { (chatSnapshot, error) in
                    if let chatDocument = chatSnapshot, let chatData = chatDocument.data(), let friends = chatData["friends"] as? [String] {
                        let friendEmail = friends.first { $0 != currentUserEmail } ?? ""
                        if notFriendsList.contains(friendEmail) {
                            DispatchQueue.main.async {
                                self.messageScreen.buttonSend.isHidden = true
                                self.messageScreen.textViewMessageText.isHidden = true
                                self.showMessageExpiredNotification()
                            }
                        }
                    } else {
                        print("Error fetching chat or counterpart details: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            } else {
                print("Error fetching user's notFriends list: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func showMessageExpiredNotification() {
        let expiredLabel = UILabel()
        expiredLabel.text = "This user is no longer your friend."
        expiredLabel.textColor = .systemRed
        expiredLabel.textAlignment = .center
        expiredLabel.numberOfLines = 0
        expiredLabel.translatesAutoresizingMaskIntoConstraints = false
        messageScreen.bottomSendView.addSubview(expiredLabel)

        NSLayoutConstraint.activate([
            expiredLabel.topAnchor.constraint(equalTo: messageScreen.bottomSendView.topAnchor),
            expiredLabel.bottomAnchor.constraint(equalTo: messageScreen.bottomSendView.bottomAnchor),
            expiredLabel.leadingAnchor.constraint(equalTo: messageScreen.bottomSendView.leadingAnchor),
            expiredLabel.trailingAnchor.constraint(equalTo: messageScreen.bottomSendView.trailingAnchor)
        ])
    }
    
    //MARK: on send button tapped...
    @objc func onButtonSendTapped(){
        if let messageText = messageScreen.textViewMessageText.text, !messageText.isEmpty {
            sendANewMessage(text: messageText)
            messageScreen.textViewMessageText.text = ""
            messageScreen.textViewMessageText.resignFirstResponder()
            
        } else {
            messageScreen.textViewMessageText.resignFirstResponder()
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

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let keyboardHeight = keyboardSize.height - view.safeAreaInsets.bottom
        messageScreen.bottomSendViewBottomConstraint.constant = -keyboardHeight // Adjust this line according to your layout constraints

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

        // Scroll to the last message
        scrollToLastMessage()
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        messageScreen.bottomSendViewBottomConstraint.constant = 0 // Reset the bottom constraint

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func scrollToLastMessage() {
        if messages.count > 0 {
            let lastIndexPath = IndexPath(row: messages.count - 1, section: 0)
            self.messageScreen.tableViewMessages.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Hide Keyboard
    @objc func hideKeyboardOnTap(_ recognizer: UITapGestureRecognizer){
        let location = recognizer.location(in: view)
        if view.hitTest(location, with: nil) is UIButton {
            return
        }
        //MARK: removing the keyboard from screen
        view.endEditing(true)
    }

}
