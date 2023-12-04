//
//  ChatsViewController.swift
//  PawPal
//
//  Created by Yitian Guo on 11/19/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatsViewController: UIViewController {

    let chatsView = ChatsView()
    let database = Firestore.firestore()
    
    var currentUser:FirebaseAuth.User?
    var chatsList = [Chat]()
    
    var filteredChatsList = [Chat]()
    var isSearchActive: Bool = false
    
    override func loadView() {
        view = chatsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.currentUser = Auth.auth().currentUser
        fetchChats()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = false
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: titleFont, size: 21)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        title = "Chats"
        
        chatsView.tableViewChats.dataSource = self
        chatsView.tableViewChats.delegate = self
        chatsView.searchBar.delegate = self
        
        //MARK: recognizing the taps on the app screen, not the keyboard
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        view.addGestureRecognizer(tapRecognizer)
        
    }
    
    func fetchChats() {
        guard let userEmail = currentUser?.email else {
            print("User email is not available")
            return
        }

        let group = DispatchGroup()
        
        database.collection("users").document(userEmail).collection("chats").getDocuments { [weak self] (snapshot, error) in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching chat references: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self?.chatsList.removeAll()
            for document in documents {
                if let chatRef = document.get("ref") as? DocumentReference {
                    group.enter() // Enter the group before starting the fetch
                    self?.fetchChatDetail(chatRef, group: group)
                }
            }

            group.notify(queue: .main) {
                self?.chatsList.sort(by: { $0.lastMessageTimestamp.dateValue() > $1.lastMessageTimestamp.dateValue() })
                self?.chatsView.tableViewChats.reloadData()
            }
        }
    }

    func fetchChatDetail(_ chatRef: DocumentReference, group: DispatchGroup) {
        chatRef.getDocument { [weak self] (document, error) in
            defer { group.leave() } // Ensure that group.leave() is called when this block exits
            guard let document = document, let chat = try? document.data(as: Chat.self), error == nil else {
                print("Error fetching chat detail: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self?.chatsList.append(chat)
        }
    }
    
    //MARK: Hide Keyboard
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen
        view.endEditing(true)
    }

}
