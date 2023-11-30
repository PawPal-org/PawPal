//
//  NewFriendsViewController.swift
//  PawPal
//
//  Created by Yitian Guo on 11/30/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class NewFriendsViewController: UIViewController {

    let newFriendsView = NewFriendsView()
    let database = Firestore.firestore()
    
    var currentUser:FirebaseAuth.User?
    
    var newFriendsList = [FriendRequest]()
    
    override func loadView() {
        view = newFriendsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.currentUser = Auth.auth().currentUser
        fetchNewFriends()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = false
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: titleFont, size: 21)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        title = "New Friends"
        
        newFriendsView.tableViewNewFriends.dataSource = self
        newFriendsView.tableViewNewFriends.delegate = self
        
    }
    
    func fetchNewFriends(){
        guard let userEmail = currentUser?.email else {
            print("User email is not available")
            return
        }
        
        database.collection("users").document(userEmail).getDocument { [weak self] (document, error) in
            guard let document = document, error == nil else {
                print("Error fetching chat references: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self?.newFriendsList.removeAll()
            if let friendRequestsArray = document.data()?["friendsRequest"] as? [[String: Any]] {
                self?.newFriendsList = friendRequestsArray.compactMap { dict in
                    if let userEmail = dict.keys.first,
                       let timestamp = (dict[userEmail] as? Timestamp)?.dateValue() {
                        return FriendRequest(userEmail: userEmail, userName: nil, userProfilePicUrl: nil,timestamp: timestamp)
                    }
                    return nil
                }
                self?.newFriendsList.sort(by: { ($0.timestamp ) > ($1.timestamp ) })
                self?.fetchFriendsDetails()
            }
        }
        
    }
    
    func fetchFriendsDetails() {
        let group = DispatchGroup()
        
        for (index, contact) in newFriendsList.enumerated() {
            group.enter()
            database.collection("users").document(contact.userEmail).getDocument { [weak self] (document, error) in
                defer { group.leave() }
                guard let document = document, error == nil else {
                    print("Error fetching friend's data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                let name = document.data()?["name"] as? String ?? "Unknown"
                let profileImageUrl = document.data()?["profileImageUrl"] as? String ?? ""

                self?.newFriendsList[index].userName = name
                self?.newFriendsList[index].userProfilePicUrl = profileImageUrl

                DispatchQueue.main.async {
                    self?.newFriendsView.tableViewNewFriends.reloadData()
                }
            }
        }
        group.notify(queue: .main) {
            self.newFriendsView.tableViewNewFriends.reloadData()
        }
    }

}
