//
//  FriendsViewController.swift
//  PawPal
//
//  Created by Yitian Guo on 11/19/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FriendsViewController: UIViewController {

    let friendsView = FriendsView()
    let database = Firestore.firestore()
    
    var currentUser:FirebaseAuth.User?
    
    var contactsList = [Contact]()
    var filteredContactsList = [Contact]()
    var isSearchActive: Bool = false
    
    struct ContactSection {
        let letter: String
        var contacts: [Contact]
    }
    var contactSections = [ContactSection]()
    
    override func loadView() {
        view = friendsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.currentUser = Auth.auth().currentUser
        fetchContacts()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = false
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: titleFont, size: 21)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        title = "Friends"
        
        friendsView.tableViewContacts.dataSource = self
        friendsView.tableViewContacts.delegate = self
        friendsView.searchBar.delegate = self
        
        setupNavigationBar()
        
        //MARK: recognizing the taps on the app screen, not the keyboard
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        view.addGestureRecognizer(tapRecognizer)
        
    }
    
    func setupNavigationBar() {
        let barIcon = UIBarButtonItem(
            image: UIImage(systemName: "envelope.badge.person.crop")?.withTintColor(.orange, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(onNewFriendBarButtonTapped)
        )
        navigationItem.rightBarButtonItems = [barIcon]
    }
    
    @objc func onNewFriendBarButtonTapped() {
        let newFriendsScreen = NewFriendsViewController()
        newFriendsScreen.currentUser = self.currentUser
        self.navigationController?.pushViewController(newFriendsScreen, animated: true)
    }
    
    func fetchContacts(){
        guard let userEmail = currentUser?.email else {
            print("User email is not available")
            return
        }
        
        database.collection("users").document(userEmail).getDocument { [weak self] (document, error) in
            guard let document = document, error == nil else {
                print("Error fetching chat references: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self?.contactsList.removeAll()

            if let friends = document.data()?["friends"] as? [String]{
                self?.contactsList = friends.map { Contact(userEmail: $0, userName: nil, userProfilePicUrl: nil, isFriend: true) }
            }
            if let notFriends = document.data()?["notFriends"] as? [String] {
                let notFriendsList = notFriends.map { Contact(userEmail: $0, userName: nil, userProfilePicUrl: nil, isFriend: false) }
                self?.contactsList.append(contentsOf: notFriendsList)
            }
            self?.fetchFriendsDetails()
        }
        
    }
    
    func fetchFriendsDetails() {
        for (index, contact) in contactsList.enumerated() {
            database.collection("users").document(contact.userEmail).getDocument { [weak self] (document, error) in
                guard let document = document, error == nil else {
                    print("Error fetching friend's data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                let name = document.data()?["name"] as? String ?? "Unknown"
                let profileImageUrl = document.data()?["profileImageUrl"] as? String ?? ""

                self?.contactsList[index].userName = name
                self?.contactsList[index].userProfilePicUrl = profileImageUrl

                DispatchQueue.main.async {
                    self?.organizeContacts()
                    self?.friendsView.tableViewContacts.reloadData()
                }
            }
        }
    }
    
    func organizeContacts() {
        let groupedDictionary = Dictionary(grouping: contactsList, by: { String($0.userName?.prefix(1) ?? "#") })
        let keys = groupedDictionary.keys.sorted()
        contactSections = keys.map { key in
            return ContactSection(letter: key, contacts: groupedDictionary[key]!.sorted(by: { $0.userName ?? "" < $1.userName ?? "" }))
        }
    }
    
    //MARK: Hide Keyboard
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen
        view.endEditing(true)
    }

}
