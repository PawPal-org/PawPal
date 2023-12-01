//
//  ContactViewController.swift
//  PawPal
//
//  Created by Yitian Guo on 11/30/23.
//

import UIKit
import FirebaseAuth

class ContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentUser:FirebaseAuth.User?
    var contact: Contact?
    
    let contactView = ContactView()
    var options = ["Moments", "Send a Message", "Delete Contact"]
    
    override func loadView() {
        view = contactView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: titleFont, size: 21)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        title = contact?.userName ?? "Contact"

        contactView.tableViewOptions.delegate = self
        contactView.tableViewOptions.dataSource = self
        contactView.tableViewOptions.register(OptionsTableViewCell.self, forCellReuseIdentifier: Configs.tableViewOptionsID)
        
        fetchProfilePic()
    }
    
    func fetchProfilePic() {
        if let imageUrlString = contact?.userProfilePicUrl, let url = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data, error == nil, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.contactView.profilePicButton.setBackgroundImage(image, for: .normal)
                    }
                }
            }.resume()
        }
    }

}
